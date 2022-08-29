//
//  RNArcGISMapViewManager.swift
//  SampleArcGIS
//
//  Created by David Galindo on 1/31/19.
//  Copyright © 2019 David Galindo. All rights reserved.
//

import Foundation
import ArcGIS


@objc(RNArcGISMapViewManager)
public class RNArcGISMapViewManager: RCTViewManager {
    var agsMapView: RNArcGISMapView?
    
    override public func view() -> UIView! {
        if (agsMapView == nil) {
            agsMapView = RNArcGISMapView()
            agsMapView!.bridge = self.bridge
        }
        return agsMapView!
    }
    
    override public class func requiresMainQueueSetup() -> Bool {
        return true;
    }
    
    // MARK: Exposed Obj-C bridging functions
    @objc func showCalloutViaManager(/*_ node: NSNumber, */_ args: NSDictionary) {
        DispatchQueue.main.async {
            //let component = self.bridge.uiManager.view(forReactTag: node) as! RNArcGISMapView
            let component = self.agsMapView!
            component.showCallout(args)
        }
    }
    
    @objc func centerMapViaManager(/*_ node: NSNumber, */_ args: NSArray) {
        DispatchQueue.main.async {
            //let component = self.bridge.uiManager.view(forReactTag: node) as! RNArcGISMapView
            let component = self.agsMapView!
            component.centerMap(args)
        }
    }
    
    @objc func addGraphicsOverlayViaManager(/*_ node: NSNumber, */_ args: NSDictionary) {
        DispatchQueue.main.async {
            //let component = self.bridge.uiManager.view(forReactTag: node) as! RNArcGISMapView
            let component = self.agsMapView!
            component.addGraphicsOverlay(args)
        }
    }
    
    @objc func addPointsToOverlayViaManager(/*_ node: NSNumber, */_ args: NSDictionary) {
        DispatchQueue.main.async {
            //let component = self.bridge.uiManager.view(forReactTag: node) as! RNArcGISMapView
            let component = self.agsMapView!
            component.addPointsToGraphicsOverlay(args)
        }
    }
    
    @objc func removePointsFromOverlayViaManager(/*_ node: NSNumber, */_ args: NSDictionary) {
        DispatchQueue.main.async {
            //let component = self.bridge.uiManager.view(forReactTag: node) as! RNArcGISMapView
            let component = self.agsMapView!
            component.removePointsFromGraphicsOverlay(args)
        }
    }
    
    @objc func removeGraphicsOverlayViaManager(/*_ node: NSNumber, */_ args: NSString) {
        DispatchQueue.main.async {
            //let component = self.bridge.uiManager.view(forReactTag: node) as! RNArcGISMapView
            let component = self.agsMapView!
            component.removeGraphicsOverlay(args)
        }
    }
  
    @objc func addLayersToGeodatabaseViaManager(_ args: NSDictionary) {
        DispatchQueue.main.async {
            let component = self.agsMapView!
            component.addLayersToGeodatabase(args)
        }
    }
  
    @objc func removeLayersFromGeodatabaseViaManager(_ args: NSDictionary) {
        DispatchQueue.main.async {
            let component = self.agsMapView!
            component.removeLayersFromGeodatabase(args)
        }
    }
  
    @objc func removeGeodatabaseViaManager(_ args: NSString) {
        DispatchQueue.main.async {
            let component = self.agsMapView!
            component.removeGeodatabase(args)
        }
    }
    
    @objc func updatePointsInGraphicsOverlayViaManager(/*_ node: NSNumber, */_ args: NSDictionary) {
        DispatchQueue.main.async {
            //let component = self.bridge.uiManager.view(forReactTag: node) as! RNArcGISMapView
            let component = self.agsMapView!
            component.updatePointsInGraphicsOverlay(args)
        }
    }
  
    @objc func addGeodatabaseViaManager(_ args: NSDictionary) {
        DispatchQueue.main.async {
            //let component = self.bridge.uiManager.view(forReactTag: node) as! RNArcGISMapView
            let component = self.agsMapView!
            component.addGeodatabase(args)
        }
    }
    
    @objc func routeGraphicsOverlayViaManager(_ node: NSNumber, args: NSDictionary) {
        DispatchQueue.main.async {
            let component = self.bridge.uiManager.view(forReactTag: node) as! RNArcGISMapView
            component.routeGraphicsOverlay(args)
        }
    }
    
    @objc func setRouteIsVisibleViaManager(_ node: NSNumber, args: ObjCBool) {
        DispatchQueue.main.async {
            let component = self.bridge.uiManager.view(forReactTag: node) as! RNArcGISMapView
            component.setRouteIsVisible(args.boolValue)
        }
    }
    
    @objc func getRouteIsVisibleViaManager(_ node: NSNumber, args: @escaping RCTResponseSenderBlock) {
        DispatchQueue.main.async {
            let component = self.bridge.uiManager.view(forReactTag: node) as! RNArcGISMapView
            component.getRouteIsVisible(args)
        }
    }
    
    @objc func dispose(/*_ node: NSNumber*/) {
        self.agsMapView?.graphicsOverlays.removeAllObjects()
        self.agsMapView?.map = nil
        self.agsMapView = nil
    }
    
    @objc func setLicenseKey(_ key: String) {
        do {
            try AGSArcGISRuntimeEnvironment.setLicenseKey(key)
        }
        catch let error as NSError {
            print("error: \(error)")
        }
    }
}

@objc(RNArcGISMapViewModule)
public class RNArcGISMapViewModule: RCTEventEmitter {
    
    // MARK: Event emitting to JS
    @objc func sendIsRoutingChanged(_ value: Bool) {
        sendEvent(withName: "isRoutingChanged", body: [value])
    }
    
    
    // MARK: Overrides
    
    override public func supportedEvents() -> [String]! {
        return ["isRoutingChanged"]
    }
    
    @objc override public static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override public func constantsToExport() -> [AnyHashable : Any]! {
        return [:]
    }
    
}
