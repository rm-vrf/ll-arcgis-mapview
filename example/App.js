import React, { useEffect, useState } from "react";
import { Text, Button, Image, Alert } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import MapOnline from "./src/MapOnline";
import GetMapArea from "./src/GetMapArea";

const Stack = createNativeStackNavigator();
const navigationRef = React.createRef();

const App = () => {
  return (
    <NavigationContainer ref={navigationRef}>
      <Stack.Navigator>
        <Stack.Screen name="Home" component={HomeScreen} options={{ title: 'ArcGIS Map View' }} />
        <Stack.Screen name="Map (online)" component={MapOnline} />
        <Stack.Screen name="GetMapArea" component={GetMapArea} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

const HomeScreen = ({ navigation }) => {
  return (
    <>
      <Button title="Map (online)" onPress={() => navigation.navigate('Map (online)', {})} />
      <Button title="Get Map Area" onPress={() => navigation.navigate('GetMapArea', {})} />
    </>
  );
};

export default App;