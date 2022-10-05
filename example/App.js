import React, { useEffect, useState } from "react";
import { Text, Button, Image, Alert } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import MapOnline from "./src/MapOnline";
import GetMapArea from "./src/GetMapArea";
import Basemap from "./src/Basemap";
import ZoomMap from "./src/ZoomMap";
import BaseLayer from "./src/BaseLayer";

const Stack = createNativeStackNavigator();
const navigationRef = React.createRef();

const App = () => {
  return (
    <NavigationContainer ref={navigationRef}>
      <Stack.Navigator>
        <Stack.Screen name="Home" component={HomeScreen} options={{ title: 'ArcGIS Map View' }} />
        <Stack.Screen name="Map (online)" component={MapOnline} />
        <Stack.Screen name="GetMapArea" component={GetMapArea} />
        <Stack.Screen name="Basemap" component={Basemap} />
        <Stack.Screen name="ZoomMap" component={ZoomMap} />
        <Stack.Screen name="BaseLayer" component={BaseLayer} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

const HomeScreen = ({ navigation }) => {
  return (
    <>
      <Button title="Map (online)" onPress={() => navigation.navigate('Map (online)', {})} />
      <Button title="Get Map Area" onPress={() => navigation.navigate('GetMapArea', {})} />
      <Button title="Change Basemap" onPress={() => navigation.navigate('Basemap', {})} />
      <Button title="Set Zoom" onPress={() => navigation.navigate('ZoomMap', {})} />
      <Button title="Base Layer" onPress={() => navigation.navigate('BaseLayer', {})} />
    </>
  );
};

export default App;