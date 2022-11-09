//
//  RNAGSMapExporter.swift
//  ReactNativeDemo
//
//  Created by Lane Lu on 2022/10/12.
//

import Foundation
import ArcGIS

public class RNAGSMapExporter {
  public var progressEvent: RCTDirectEventBlock?
  private let mapView: AGSMapView
  private var resolve: RCTPromiseResolveBlock?
  private var reject: RCTPromiseRejectBlock?
  
  /// The resulting vector tiled layer.
  private var vectorTiledLayer: AGSArcGISVectorTiledLayer?
  /// The extent of the map that is to be exported.
  private var extent: AGSEnvelope?
  /// The export task to request the tile package with the same URL as the tile layer.
  private var exportVectorTilesTask: AGSExportVectorTilesTask?
  /// An export job to download the tile package.
  private var job: AGSExportVectorTilesJob? {
    didSet {
      // Remove key-value observation.
      progressObservation = nil
      // Observe the localized description in order to update the text label.
      progressObservation = job?.progress.observe(\.localizedDescription, options: .initial) { [weak self] progress, _ in
        if let progressEvent = self?.progressEvent {
          let reactResult: [AnyHashable: Any] = [
            "fractionCompleted": progress.fractionCompleted,
            "completedUnitCount": progress.completedUnitCount,
            "debugDescription": progress.debugDescription,
            "isCancelled": progress.isCancelled,
            "isFinished": progress.isFinished,
            "isPaused": progress.isPaused,
            "totalUnitCount": progress.totalUnitCount,
            "description": progress.description,
            "estimatedTimeRemaining": progress.estimatedTimeRemaining ?? -1,
            //"fileURL": progress.fileURL,
            "fileCompletedCount": progress.fileCompletedCount ?? -1,
            "fileTotalCount": progress.fileTotalCount ?? -1,
            "localizedDescription": progress.localizedDescription ?? ""
          ]
          progressEvent(reactResult)
        }
      }
    }
  }
  
  /// A URL to the temporary directory to temporarily store the exported vector tile package.
  private let vtpkTemporaryURL: URL
  /// A URL to the temporary directory to temporarily store the style item resources.
  private let styleTemporaryURL: URL
  /// A directory to temporarily store all items.
  private let temporaryDirectory: URL
  
  /// Observation to track the export vector tiles job.
  private var progressObservation: NSKeyValueObservation?
  
  init(mapView: AGSMapView, progressEvent: RCTDirectEventBlock?) {
    // Init and create directory
    temporaryDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(ProcessInfo().globallyUniqueString)
    print("temporaryDirectory: \(temporaryDirectory)")
    try? FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: false)
    vtpkTemporaryURL = temporaryDirectory
      .appendingPathComponent("tileCache", isDirectory: false)
      .appendingPathExtension("vtpk")
    styleTemporaryURL = temporaryDirectory
      .appendingPathComponent("styleItemResources", isDirectory: true)
    
    // Init properties
    self.mapView = mapView
    self.progressEvent = progressEvent
  }
  
  public func exportVectorTiles(_ args: NSDictionary, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) {
    // Init callback block
    self.resolve = resolve
    self.reject = reject
    
    // Obtain the vector tiled layer and its URL from the baselayers.
    guard let vectorTiledLayer = self.mapView.map?.basemap.baseLayers.firstObject as? AGSArcGISVectorTiledLayer,
          let vectorTiledLayerURL = vectorTiledLayer.url else { return }
    // The export task to request the tile package with the same URL as the tile layer.
    let exportVectorTilesTask = AGSExportVectorTilesTask(url: vectorTiledLayerURL)
    self.exportVectorTilesTask = exportVectorTilesTask
    exportVectorTilesTask.load {[weak self] error in
      guard let self = self else { return }
      if let error = error {
        if let reject = reject {
          reject("E_EXPORTVECTORTILES", "error when export vector tiled layer", error)
        }
      } else {
        self.initiateDownload(exportTask: exportVectorTilesTask, vectorTileCacheURL: vectorTiledLayerURL)
      }
    }
  }
  
  public func cancelExportVectorTiles() {
    // Cancel export vector tiles job and remove the temporary files.
    job?.progress.cancel()
    removeTemporaryFiles()
  }

  /// Initiate the `AGSExportVectorTilesTask` to download a tile package.
  /// - Parameters:
  ///   - exportTask: An `AGSExportVectorTilesTask` to run the export job.
  ///   - vectorTileCacheURL: A URL to where the tile package should be saved.
  func initiateDownload(exportTask: AGSExportVectorTilesTask, vectorTileCacheURL: URL) {
    // Set the max scale parameter to 10% of the map's scale to limit the
    // number of tiles exported to within the vector tiled layer's max tile export limit.
    let maxScale = mapView.mapScale * 0.1
    // Get current area of interest marked by the extent view.
    let areaOfInterest = envelope()
    print("maxScale: \(maxScale), areaOfInterest: \(areaOfInterest.xMin), \(areaOfInterest.yMin), \(areaOfInterest.xMax), \(areaOfInterest.yMax)")
    // Get the parameters by specifying the selected area and vector tiled layer's max scale as maxScale.
    exportTask.defaultExportVectorTilesParameters(withAreaOfInterest: areaOfInterest, maxScale: maxScale) { [weak self] parameters, error in
      guard let self = self, let exportVectorTilesTask = self.exportVectorTilesTask else { return }
      if let params = parameters {
        // Start exporting the tiles with the resulting parameters.
        self.exportVectorTiles(exportTask: exportVectorTilesTask, parameters: params, vectorTileCacheURL: vectorTileCacheURL)
      } else if let error = error {
        if let reject = self.reject {
          reject("E_EXPORTVECTORTILES", "error when export vector tiled layer", error)
        }
      }
    }
  }
  
  /// Export vector tiles with the `AGSExportVectorTilesJob` from the export task.
  /// - Parameters:
  ///   - exportTask: An `AGSExportVectorTilesTask` to run the export job.
  ///   - parameters: The parameters of the export task.
  ///   - vectorTileCacheURL: A URL to where the tile package is saved.
  func exportVectorTiles(exportTask: AGSExportVectorTilesTask, parameters: AGSExportVectorTilesParameters, vectorTileCacheURL: URL) {
    // Create the job with the parameters and download URLs.
    let job = exportTask.exportVectorTilesJob(with: parameters, vectorTileCacheDownloadFileURL: vtpkTemporaryURL, itemResourceCacheDownloadDirectory: styleTemporaryURL)
    self.job = job
    // Start the job.
    job.start(statusHandler: nil) { [weak self] (result, error) in
      guard let self = self else { return }
      self.job = nil
      if let result = result,
         let tileCache = result.vectorTileCache,
         let itemResourceCache = result.itemResourceCache {
        //print("tileCache: \(tileCache.fileURL), itemResourceCache: \(itemResourceCache.fileURL)")
        if let resolve = self.resolve {
          let reactResult: [AnyHashable: Any] = [
            "tileCache": tileCache.fileURL.description,
            "itemResourceCache": itemResourceCache.fileURL.description
          ]
          resolve(reactResult)
        }
      } else if let error = error {
        let nsError = error as NSError
        if !(nsError.domain == NSCocoaErrorDomain && nsError.code == NSUserCancelledError) {
          if let reject = self.reject {
            reject("E_EXPORTVECTORTILES", "error when export vector tiled layer", error)
          }
        }
      }
    }
  }
  
  /// Get the extent within the extent view for generating a vector tile package.
  func envelope() -> AGSEnvelope {
    let env = AGSGeometryEngine.projectGeometry(self.mapView.visibleArea!.extent, to: mapView.spatialReference!) as! AGSEnvelope
    return env
  }
  
  /// Remove temporary files that are created for each job.
  func removeTemporaryFiles() {
    try? FileManager.default.removeItem(at: self.vtpkTemporaryURL)
    try? FileManager.default.removeItem(at: self.styleTemporaryURL)
  }
}

