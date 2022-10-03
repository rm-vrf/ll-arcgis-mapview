import React, {useRef, useState} from 'react';
import { Image, Button, StyleSheet } from 'react-native';
import ArcGISMapView, { setLicenseKey } from 'll-arcgis-mapview';

const ZoomMap = () => {
    const key = 'AAPKc85619ab61144011b89e94bd99e0a55cJXjNQG8TIn_54f2fp1azph9IB-PXQPCkJorOQirjGhb5wt7D6EreTHFLPkyIestQ';
    setLicenseKey(key);
    let agsView = useRef(null);

    const points = [
        {
            latitude: 34.0005930608889,
            longitude: -118.80657463861,
        },
        {
            latitude: 42.361145,
            longitude: -71.057083,
        },
    ];

    const [ center, setCenter ] = useState(points[0]);
    var zoomLevel = 2;
    var scale = 10000000;

    return (
        <>
            <Button 
                title='Change map center' 
                onPress={() => {
                    const i = points[0].latitude === center.latitude ? 1 : 0;
                    setCenter(points[i]);
                    agsView.recenterMap([center]);
                }}>
            </Button>
            <Button 
                title='Zoom map'
                onPress={() => {
                    zoomLevel = zoomLevel >= 20 ? 2 : zoomLevel + 2; 
                    console.log("zoomLevel", zoomLevel);
                    agsView.zoomMap(zoomLevel); 
                }}
            ></Button>
            <Button 
                title='Scale map'
                onPress={() => {
                    scale = scale <= 10000 ? 10000000 : scale / 2; 
                    console.log("scale", scale);
                    agsView.scaleMap(scale); 
                }}
            ></Button>
            <ArcGISMapView
                style={styles.map} 
                initialMapCenter={[center]}
                recenterIfGraphicTapped={true}
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

export default ZoomMap;
