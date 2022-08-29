//
//  RNAGSFeatureLayer.swift
//  ReactNativeDemo
//
//  Created by Lane Lu on 2022/8/12.
//

import ArcGIS
import Foundation

public class RNAGSFeatureLayer : AGSFeatureLayer {
    let geodatabaseReferenceId: NSString
    let referenceId: NSString

    init(geodatabase: RNAGSGeodatabase, featureTable: AGSGeodatabaseFeatureTable, rawData: NSDictionary?) {
        geodatabaseReferenceId = geodatabase.referenceId

        if let referenceIdRaw = rawData?["referenceId"] as? NSString {
            referenceId = referenceIdRaw
        } else {
            referenceId = NSString(string: featureTable.tableName)
        }

        super.init(featureTable: featureTable)

        if let definitionExpressionRaw = rawData?["definitionExpression"] as? NSString {
            definitionExpression = String(definitionExpressionRaw)
        }
    }
}
