//
//  RNAGSGeodatabase.swift
//  ReactNativeDemo
//
//  Created by Lane Lu on 2022/8/12.
//

import ArcGIS
import Foundation

public class RNAGSGeodatabase {
    let referenceId: NSString
    let geodatabaseURL: URL
    var featureDictionaries: [LayerDictionary]
    var annotationDictionaries: [LayerDictionary]

    // MARK: Initializer
    init(rawData: NSDictionary) {
        // Read reference Id
        guard let referenceIdRaw = rawData["referenceId"] as? NSString else {
            fatalError("The RNAGSGeodatabase needs a reference ID.")
        }
        referenceId = referenceIdRaw

        // Read geodatabase URL and create object
        guard let urlRaw = rawData["geodatabaseURL"] as? NSString, let geodatabaseURLRaw = URL(string: urlRaw as String) else {
            fatalError("WARNING: Invalid geodatabaseURL entered. No geodatabase will be added.")
        }
        geodatabaseURL = geodatabaseURLRaw

        // Read feature layer data & annotation layer data
        featureDictionaries = []
        annotationDictionaries = []
        update(rawData: rawData)
    }

    func update(rawData: NSDictionary) {
        // Read feature layer data
        featureDictionaries.removeAll()
        if let rawDataFeatureLayers = rawData["featureLayers"] as? [NSDictionary] {
            for rawDataFeatureLayer in rawDataFeatureLayers {
                featureDictionaries.append(LayerDictionary(rawData: rawDataFeatureLayer))
            }
        }

        // Read annotation layer data
        annotationDictionaries.removeAll()
        if let rawDataAnnotationLayers = rawData["annotationLayers"] as? [NSDictionary] {
            for rawDataAnnotationLayer in rawDataAnnotationLayers {
                annotationDictionaries.append(LayerDictionary(rawData: rawDataAnnotationLayer))
            }
        }
    }

    func geodatabaseDidLoad(completion: @escaping (_ featureLayers: [RNAGSFeatureLayer]?, _ annotationLayers: [RNAGSAnnotationLayer]?) -> Void) {
        let geodatabase = AGSGeodatabase(fileURL: geodatabaseURL)
        geodatabase.load() {error in
            if let error = error {
                print("WARNING: Invalid geodatabase data. \(error)")
            } else {
                let featureLayers = self.loadFeatureLayers(geodatabase: geodatabase)
                let annotationLayers = self.loadAnnotationLayers(geodatabase: geodatabase)
                //let viewpoint = self.loadViewpoint(featureLayers: featureLayers)
                completion(featureLayers, annotationLayers)
            }
        }
    }

    func loadFeatureLayers(geodatabase: AGSGeodatabase) -> [RNAGSFeatureLayer] {
        // Create feature layers
        var i = 0
        var featureLayers: [RNAGSFeatureLayer] = []
        for featureTable in geodatabase.geodatabaseFeatureTables {
            if featureDictionaries.isEmpty {
                featureLayers.append(RNAGSFeatureLayer(geodatabase: self, featureTable: featureTable, rawData: nil))
            } else if let featureDictionary = findDictionay(tableName: featureTable.tableName, tableIndex: i, featureDictionaries) {
                featureLayers.append(RNAGSFeatureLayer(geodatabase: self, featureTable: featureTable, rawData: featureDictionary))
            }
            i = i + 1
        }
        return featureLayers
    }

    func loadAnnotationLayers(geodatabase: AGSGeodatabase) -> [RNAGSAnnotationLayer] {
        // Create annotation layers
        var i = 0
        var annotationLayers: [RNAGSAnnotationLayer] = []
        for annotationTable in geodatabase.geodatabaseAnnotationTables {
            if annotationDictionaries.isEmpty {
                annotationLayers.append(RNAGSAnnotationLayer(geodatabase: self, annotationTable: annotationTable, rawData: nil))
            } else if let annotationDistionary = findDictionay(tableName: annotationTable.tableName, tableIndex: i, annotationDictionaries) {
                annotationLayers.append(RNAGSAnnotationLayer(geodatabase: self, annotationTable: annotationTable, rawData: annotationDistionary))
            }
            i = i + 1
        }
        return annotationLayers
    }

    private func findDictionay(tableName: String, tableIndex: Int, _ dictionaries: [LayerDictionary]) -> NSDictionary? {
        for ld in dictionaries {
            if tableName == ld.tableName || tableIndex == ld.tableIndex {
                return ld.rawData
            }
        }
        return nil
    }

    public class LayerDictionary {
        var rawData: NSDictionary

        init(rawData: NSDictionary) {
            self.rawData = rawData
        }

        var tableName: String {
            get {
                if let s = rawData["tableName"] as? NSString {
                    return String(s)
                } else {
                    return ""
                }
            }
        }

        var tableIndex: Int {
            get {
                if let i = rawData["tableIndex"] as? NSNumber {
                    return i.intValue
                } else {
                    return -1
                }
            }
        }
    }
}
