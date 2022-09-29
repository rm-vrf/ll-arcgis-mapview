import React, {useRef, useState} from 'react';
import { Image, Button, StyleSheet } from 'react-native';
import ArcGISMapView, { setLicenseKey } from 'll-arcgis-mapview';

const Basemap = () => {
    const key = 'AAPKc85619ab61144011b89e94bd99e0a55cJXjNQG8TIn_54f2fp1azph9IB-PXQPCkJorOQirjGhb5wt7D6EreTHFLPkyIestQ';
    setLicenseKey(key);
    let agsView = useRef(null);

    const point = [
        {
            latitude: 34.0005930608889,
            longitude: -118.80657463861,
            scale: 10000.0,
        },
    ];

    const maps = [
        'https://www.arcgis.com/home/item.html?id=5be0bc3ee36c4e058f7b3cebc21c74e6', 
        'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer', 
        'https://sampleserver5.arcgisonline.com/arcgis/rest/services/Elevation/WorldElevations/MapServer'];

    const [ basemap, setBasemap ] = useState('');

    return (
        <>
            <Button 
                title='Change basemap' 
                onPress={() => { setBasemap(basemap === maps[0] ? maps[1] : basemap === maps[1] ? maps[2] : maps[0]); }}>
            </Button>
            <ArcGISMapView
                style={styles.map} 
                initialMapCenter={[point]}
                recenterIfGraphicTapped={true}
                basemapUrl={basemap}
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

export default Basemap;
