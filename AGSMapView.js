//  Created by react-native-create-bridge

import React from 'react'
import { requireNativeComponent, NativeModules } from 'react-native'
const AGSMap = requireNativeComponent('RNArcGISMapView', ArcGISMapView);

class ArcGISMapView extends React.Component {
    constructor(props) {
        super(props);
        this.agsMapRef = React.createRef(null);
    }

    // MARK: Exposed native methods
    showCallout = (args) => {
        NativeModules.RNArcGISMapViewManager.showCalloutViaManager(args);
    };
    
    recenterMap = (pointArray) => {
        NativeModules.RNArcGISMapViewManager.centerMapViaManager(pointArray);
    }
    
    addGraphicsOverlay = (overlayData) => {
        NativeModules.RNArcGISMapViewManager.addGraphicsOverlayViaManager(overlayData);
    }

    addPointsToOverlay = (args) => {
        NativeModules.RNArcGISMapViewManager.addPointsToOverlayViaManager(args);
    }

    removePointsFromOverlay = (args) => {
        NativeModules.RNArcGISMapViewManager.removePointsFromOverlayViaManager(args);
    }

    updatePointsOnOverlay = (args) => {
        NativeModules.RNArcGISMapViewManager.updatePointsInGraphicsOverlayViaManager(args);
    }
    
    removeGraphicsOverlay = (overlayId) => {
        NativeModules.RNArcGISMapViewManager.removeGraphicsOverlayViaManager(overlayId);
    }

    addGeodatabase = (geodatabaseData) => {
        NativeModules.RNArcGISMapViewManager.addGeodatabaseViaManager(geodatabaseData);
    }

    addLayersToGeodatabase = (args) => {
        NativeModules.RNArcGISMapViewManager.addLayersToGeodatabaseViaManager(args);
    }

    removeLayersFromGeodatabase = (args) => {
        NativeModules.RNArcGISMapViewManager.removeLayersFromGeodatabaseViaManager(args);
    }

    removeGeodatabase = (geodatabaseId) => {
        NativeModules.RNArcGISMapViewManager.removeGeodatabaseViaManager(geodatabaseId);
    }

    // MARK: Render
    render() {
        return <AGSMap {...this.props} ref={this.agsMapRef} />
    }

    // MARK: Disposal
    componentWillUnmount() {
        NativeModules.RNArcGISMapViewManager.dispose();
    }    
}

export const setLicenseKey = (string) => {
    NativeModules.RNArcGISMapViewManager.setLicenseKey(string);
};

export default ArcGISMapView;