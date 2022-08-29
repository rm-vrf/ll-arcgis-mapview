//
//  RNAGSAnnotationLayer.swift
//  ReactNativeDemo
//
//  Created by Lane Lu on 2022/8/12.
//

import Foundation
import ArcGIS

public class RNAGSAnnotationLayer : AGSAnnotationLayer {
    let geodatabaseReferenceId: NSString
    let referenceId: NSString

    init(geodatabase: RNAGSGeodatabase, annotationTable: AGSGeodatabaseFeatureTable, rawData: NSDictionary?) {
        geodatabaseReferenceId = geodatabase.referenceId

        if let referenceIdRaw = rawData?["referenceId"] as? NSString {
            referenceId = referenceIdRaw
        } else {
            referenceId = NSString(string: annotationTable.tableName)
        }

        super.init(featureTable: annotationTable)
    }
}
