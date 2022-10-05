import React, {useRef, useState} from 'react';
import { Button, StyleSheet } from 'react-native';
import ArcGISMapView, { setLicenseKey } from 'll-arcgis-mapview';

const BaseLayer = () => {
    const key = 'AAPKc85619ab61144011b89e94bd99e0a55cJXjNQG8TIn_54f2fp1azph9IB-PXQPCkJorOQirjGhb5wt7D6EreTHFLPkyIestQ';
    setLicenseKey(key);
    let agsView = useRef(null);

    const point = [
        {
            latitude: 34.0005930608889,
            longitude: -118.80657463861,
        },
    ];

    const baseLayer = {
        referenceId: 'baseLayerId', 
        url: 'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer'
    }

    return (
        <>
            <Button 
                title='Add Base Layer'
                onPress={() => {
                    agsView.addBaseLayer(baseLayer);
                }}
            />
            <Button 
                title='Remove Base Layer'
                onPress={() => {
                    agsView.removeBaseLayer(baseLayer.referenceId);
                }}
            />
            <ArcGISMapView
                style={styles.map} 
                initialMapCenter={[point]}
                recenterIfGraphicTapped={true}
                ref={element => agsView = element}
                onOverlayWasModified = {e => { console.log('onOverlayWasModified', e.nativeEvent) }}
            />
        </>
    );
};

const styles = StyleSheet.create({
    map: {
      flex: 4,
    },
});

export default BaseLayer;
