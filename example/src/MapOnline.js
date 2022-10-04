import React, {useRef, useState} from 'react';
import { Image, Button, StyleSheet } from 'react-native';
import ArcGISMapView, { setLicenseKey } from 'll-arcgis-mapview';

const MapOnline = () => {
    const key = 'AAPKc85619ab61144011b89e94bd99e0a55cJXjNQG8TIn_54f2fp1azph9IB-PXQPCkJorOQirjGhb5wt7D6EreTHFLPkyIestQ';
    setLicenseKey(key);
    let agsView = useRef(null);

    const points = [
        {
            latitude: 34.0005930608889,
            longitude: -118.80657463861,
            scale: 10000.0,
        },
        {
            latitude: 42.361145,
            longitude: -71.057083,
            scale: 9027.977411,
        },
    ];

    const overlay = {
        referenceId: 'graphicsOverlay',
        points: [{
            latitude: 34.00531212532058,
            longitude: -118.80930002749008,
            rotation: 0,
            referenceId: 'Birdview Ave',
            graphicId: 'normalPoint',
        }, {
            latitude: 42.361145,
            longitude: -71.057083,
            rotation: 0,
            referenceId: 'Boston',
            graphicId: 'personPoint',
        }],
        pointGraphics: [{
            graphicId: 'normalPoint',
            graphic: Image.resolveAssetSource(require('../image/normalpoint.png')),
        },{
            graphicId: 'personPoint',
            graphic: Image.resolveAssetSource(require('../image/personpoint.png')),
        }]
    };

    const addOverlay = {
        overlayReferenceId: 'graphicsOverlay',
        points: [{
            latitude: 34.00091489824838,
            longitude: -118.8068756989962,
            rotation: 0,
            referenceId: 'Point Dume',
            graphicId: 'planePoint',
        }],
        pointGraphics: [{
            graphicId: 'planePoint',
            graphic: Image.resolveAssetSource(require('../image/planepoint.png')),
        }]
    };

    const updateOverlay = {
        overlayReferenceId: 'graphicsOverlay',
        animated: true,
        updates: [{
            referenceId: 'Point Dume',
            latitude: 34.00180158650602,
            longitude: -118.80625773294051,
            //graphicId: 'personPoint',
        }],
    };

    const callout = {
        title: 'Cliffside Dr',
        text: 'Cliffside Dr, Malibu, CA 90265 | Spokeo',
        shouldRecenter: true,
        point: {
            latitude: 34.007161186714214,
            longitude: -118.8004553264204,
        },
    };
    
    const [ center, setCenter ] = useState(points[0]);

    return (
        <>
            <Button 
                title='Add overlay'
                onPress={() => { agsView.addGraphicsOverlay(overlay); }}>
            </Button>
            <Button 
                title='Add point'
                onPress={() => { agsView.addPointsToOverlay(addOverlay); }}>
            </Button>
            <Button 
                title='Move point'
                onPress={() => { agsView.updatePointsOnOverlay(updateOverlay); }}>
            </Button>
            <Button 
                title='Remove point'
                onPress={() => { agsView.removePointsFromOverlay({overlayReferenceId: 'graphicsOverlay', referenceIds: ['Point Dume']}); }}>
            </Button>
            <Button 
                title='Remove overlay'
                onPress={() => { agsView.removeGraphicsOverlay('graphicsOverlay'); }}>
            </Button>
            <Button 
                title='Callout'
                onPress={() => { agsView.showCallout(callout); }}>
            </Button>
            <ArcGISMapView
                style={styles.map} 
                spatialReference = {{ wkid: 4326 }}
                initialMapCenter={[center]}
                recenterIfGraphicTapped={true}
                //basemapUrl={'https://www.arcgis.com/home/item.html?id=' + basemap}
                onMapDidLoad={e => { console.log('onMapDidLoad', e.nativeEvent) }} 
                onSingleTap={e => { console.log('onSingleTap', e.nativeEvent) }} 
                onLongPress={e => { console.log('onLongPress', e.nativeEvent) }}
                //onMapMoved={e => { console.log('onMapMoved', e.nativeEvent) }} 
                onOverlayWasAdded = {e => { console.log('onOverlayWasAdded', e.nativeEvent) }}
                onOverlayWasModified = {e => { console.log('onOverlayWasModified', e.nativeEvent) }}
                onOverlayWasRemoved = {e => { console.log('onOverlayWasRemoved', e.nativeEvent) }}
                ref={element => agsView = element}
            />
        </>
    );
};

const styles = StyleSheet.create({
    map: {
      flex: 4,
    },
});

export default MapOnline;
