import React, {useRef, useState} from 'react';
import { Text, Button, StyleSheet } from 'react-native';
import ArcGISMapView, { setLicenseKey } from 'll-arcgis-mapview';

const ExportVectorTiles = () => {
    const key = 'AAPKc85619ab61144011b89e94bd99e0a55cJXjNQG8TIn_54f2fp1azph9IB-PXQPCkJorOQirjGhb5wt7D6EreTHFLPkyIestQ';
    const points = [
        {
            latitude: 34.049, 
            longitude: -117.181
            //latitude: 42.361145,
            //longitude: -71.057083,
        },
    ];
    const [ tileCache, setTileCache ] = useState('');
    const [ message, setMessage ] = useState('0%'); 
    const [ center, setCenter ] = useState(points[0]);
    const [ basemap, setBasemap ] = useState('');
    var zoomLevel = 15;

    let agsView = useRef(null);
    setLicenseKey(key);

    return (
        <>
            <Text>{message}</Text>
            <Button 
                title='Export area as vector tiles' 
                onPress={() => {
                    agsView.exportVectorTiles({}).then(result => {
                        console.log('result', result);
                        setTileCache(result.tileCache);
                    });
                }}>
            </Button>
            <Button 
                title='Display downloaded file'
                onPress={() => {
                    setBasemap(tileCache);
                }}
            ></Button>
            <ArcGISMapView
                style={styles.map} 
                ref={element => agsView = element}
                initialMapCenter={[center]}
                recenterIfGraphicTapped={false}
                basemapUrl={basemap}
                onMapDidLoad = {e => {
                    console.log('onMapDidLoad', e.nativeEvent); 
                    setTimeout(function() {
                        agsView.zoomMap(zoomLevel);
                    }, 1000); 
                }}
                onMapExportProgress = {e => {
                    console.log("onMapExportProgress", e.nativeEvent);
                    setMessage(e.nativeEvent.localizedDescription);
                }}
            />
        </>
    );
};

const styles = StyleSheet.create({
    map: {
      flex: 4,
    },
});

export default ExportVectorTiles;