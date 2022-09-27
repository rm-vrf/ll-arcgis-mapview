import React, {useRef, useState} from 'react';
import { Text, Button, StyleSheet } from 'react-native';
import ArcGISMapView, { setLicenseKey } from 'll-arcgis-mapview';

const GetMapArea = () => {
    const key = 'AAPKc85619ab61144011b89e94bd99e0a55cJXjNQG8TIn_54f2fp1azph9IB-PXQPCkJorOQirjGhb5wt7D6EreTHFLPkyIestQ';
    setLicenseKey(key);
    let agsView = useRef(null);

    const [ message, setMessage ] = useState('N/A'); 

    return (
        <>
            <Text>{message}</Text>
            <Button 
                title='Get Visible Area'
                onPress={() => { agsView.getVisibleArea().then(result => setMessage(JSON.stringify(result))); }}>
            </Button>
            <ArcGISMapView
                style={styles.map} 
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

export default GetMapArea;
