# ll-arcgis-mapview

This project is froked from https://github.com/davidgalindo/react-native-arcgis-mapview.

## Install the package and link it

```shell
$ yarn add ll-arcgis-mapview
$ cd ios
$ pod install
```

## Usage

```javascript
import ArcGISMapView, { setLicenseKey } from 'll-arcgis-mapview';

const key = 'AAPK...IestQ';
setLicenseKey(key);
let agsView = useRef(null);

return (
  <ArcGISMapView
    style={styles.map}
    ref={element => agsView = element}
  />
);

const styles = StyleSheet.create({
  map: {
    flex: 4,
  },
});
```

## Props

| Prop Name | Type | Description | Sample Value |
| --- | --- | --- | --- |
| initialMapCenter | Object Array | Specifies the initial center of the map. | `[{latitude: 36.244797, longitude: -94.148060, scale: 10000.0}]` |
| recenterIfGraphicTapped | Boolean | If true, the map will recenter if a graphic is tapped on. | `true` / `false` |
| basemapUrl | String | A URL that links to an ArcGIS Online map with your style | `https://www.arcgis.com/home/item.html?id=5be0bc3ee36c4e058f7b3cebc21c74e6` |

## Callbacks

| Callback Name | Description | Parameters |
| --- | --- | --- |
| onSingleTap | A callback that runs whenever the map is tapped once. A graphics ID is returned if a graphic was tapped on. A Geodatabase object props is returned if a feature object was tapped on. | `{ points: { mapPoint: {latitude: Number, longitude: Number}, screenPoint: {x: Number, y: Number}, }, graphicReferenceId: String?, geoElementAttributes: Object? }` |
| onMapMoved | Called when map was moved. | `{ referenceId: String }` |
| onMapDidLoad | Executed when the map finishes loading or runs into an error. | `{ success: Boolean, errorMessage: String? }` |
| onOverlayWasAdded | Called when overlay is added. | `{ referenceId: String }` |
| onOverlayWasModified | Called when an overlay was modified. | `{ referenceId: String, action: String, success: Boolean, errorMessage: String? }` |
| onOverlayWasRemoved | Called when overlay is removed. | `{ referenceId: String }` |
| onGeodatabaseWasAdded | Called when a Geodatabase feature layer is added. | `{ referenceId: String, featureLayers: [String], annotationLayers: [String] }` |
| onGeodatabaseWasModified | Called when a Geodatabase feature layer was modified. | `{ referenceId: String, action: String, success: Boolean, errorMessage: String?, featureLayers: [String], annotationLayers: [String] }` |
| onGeodatabaseWasRemoved | Called when Geodatabase feature layer is removed. | `{ referenceId: String }` |

## Methods

| Callback Name | Description | Parameters |
| --- | --- | --- |
| showCallout | Creates a callout popup with a title and description at the given point. | `{ point: {latitude, longitude} , title: String?, text String?, shouldRecenter: Boolean? }` |
| recenterMap | Recenters the map around the given point(s). | `[ {latitude: Number, longitude: Number, scale: Number?} ]` |
| addGraphicsOverlay | Adds a graphics overlay with the given points. See below for more information. | `{  pointGraphics: [graphicId: String, graphic: Image]?, referenceId: String, points: [Point] }` |
| addPointsToOverlay | Adds points to the overlay with the given overlayReferenceId. | `{ overlayReferenceId: String, points: [Point] }` |
| removePointsFromOverlay | Removes points from the overlay with the given overlayReferenceID. The reference ID array are the IDs of the points you wish to remove. | `{ overlayReferenceId: String, referenceIds: [String] }` |
| updatePointsOnOverlay | Updates points on a given overlay. All properties within an individual Point object are optional, though latitude and longitude must both be provided if you are updating either one. Animated controls whether or not the app should animate the transition from one point/rotation to another. Make sure each update is spaced about 500ms apart. | `{ overlayReferenceId: String, updates: [Point], animated: Boolean }` |
| removeGraphicsOverlay | Removes the graphics overlay with the given ID. | `{ overlayId: String }` |
| addGeodatabase | Adds Geodatabase feature layers. | `{ referenceId: String, geodatabaseURL: String, featureLayers: [{ referenceId: String, tableName: String, definitionExpression: String?, }], annotationLayers: [{ referenceId: String, tableName: String, }] }` |
| addLayersToGeodatabase | Adds feature layers and annotation layers to the Geodatabase with the given geodatabaseReferenceId. | `{ geodatabaseReferenceId: String, featureLayers: [{ referenceId: String, tableName: String, definitionExpression: String? }], annotationLayers: [{ referenceId: String, tableName: String }] }` |
| removeLayersFromGeodatabase | Removes feature layers from the Geodatabase with the given geodatabaseReferenceID. | `{ geodatabaseReferenceId: String, featureLayerReferenceIds: [String], annotationLayerReferenceIds: [String] }` |
| removeGeodatabase | Removes the Geodatabase with the given ID. | `{ geodatabaseReferenceId: String }` |

### The Point Object

Above, the Point object was referenced as 'Point.' The Point object is structured as follows:

```
{
  latitude: Number,
  longitude: Number,
  rotation: Number? = 0,
  referenceId: String,
  graphicId: String?,
}
```

### The Image Object

When defining graphics, use the following format:

```
import { Image } from 'react-native';

pointGraphics: [
  { graphicId: 'graphicId', graphic: Image.resolveAssetSource(require('path_to_your_local_image')) },
  // Repeat for as many graphics as you'd like
]
```
