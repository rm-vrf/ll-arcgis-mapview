import React, { useEffect, useState } from "react";
import { Text, Button, Image, Alert } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import MapOnline from "./src/MapOnline";

const Stack = createNativeStackNavigator();
const navigationRef = React.createRef();

const App = () => {
  return (
    <NavigationContainer ref={navigationRef}>
      <Stack.Navigator>
        <Stack.Screen name="Home" component={HomeScreen} options={{ title: 'ArcGIS Map View' }} />
        <Stack.Screen name="Map (online)" component={MapOnline} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

const HomeScreen = ({ navigation }) => {
  return (
    <>
      <Button title="Map (online)" onPress={() => navigation.navigate('Map (online)', {})} />
    </>
  );
};

export default App;