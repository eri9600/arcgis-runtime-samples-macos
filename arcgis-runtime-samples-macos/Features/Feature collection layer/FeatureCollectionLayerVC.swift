//
// Copyright 2017 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Cocoa
import ArcGIS

class FeatureCollectionLayerVC: NSViewController {

    @IBOutlet var mapView:AGSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize map with basemap
        let map = AGSMap(basemap: AGSBasemap.oceansBasemap())
        
        //initial viewpoint
        let point = AGSPoint(x: -79.497238, y: 8.849289, spatialReference: AGSSpatialReference.WGS84())
        map.initialViewpoint = AGSViewpoint(center: point, scale: 1.5e6)
        
        //assign map to the map view
        self.mapView.map = map
        
        self.addFeatureCollectionLayer()
    }
    
    private func addFeatureCollectionLayer() {
        //feature collection table for point, polyline and polygon
        let pointsCollectionTable = self.pointsCollectionTable()
        let linesCollectionTable = self.linesCollectionTable()
        let polygonsCollectionTable = self.polygonsCollectionTable()
        
        //feature collection
        let featureCollection = AGSFeatureCollection(featureCollectionTables: [pointsCollectionTable, linesCollectionTable, polygonsCollectionTable])
        
        //feature collection layer
        let featureCollectionLayer = AGSFeatureCollectionLayer(featureCollection: featureCollection)
        
        //add layer to the map
        self.mapView.map?.operationalLayers.addObject(featureCollectionLayer)
    }
    
    private func pointsCollectionTable() -> AGSFeatureCollectionTable {
        
        //create schema for points feature collection table
        var fields = [AGSField]()
        let placeField = AGSField(fieldType: .Text, name: "Place", alias: "Place name", length: 40, domain: nil, editable: true, allowNull: false)
        fields.append(placeField)
        
        //initialize feature collection table with the fields created
        //and geometry type as Point
        let pointsCollectionTable = AGSFeatureCollectionTable(fields: fields, geometryType: .Point, spatialReference: AGSSpatialReference.WGS84())
        
        //renderer
        let symbol = AGSSimpleMarkerSymbol(style: .Triangle, color: NSColor.redColor(), size: 18)
        pointsCollectionTable.renderer = AGSSimpleRenderer(symbol: symbol)
        
        // Create a new point feature, provide geometry and attribute values
        let pointFeature = pointsCollectionTable.createFeature()
        pointFeature.attributes["Place"] = "Current location"
        let point = AGSPoint(x: -79.497238, y: 8.849289, spatialReference: AGSSpatialReference.WGS84())
        pointFeature.geometry = point
        
        //add feature to the feature collection table
        pointsCollectionTable.addFeature(pointFeature, completion: nil)
        
        return pointsCollectionTable
    }
    
    private func linesCollectionTable() -> AGSFeatureCollectionTable {
        
        //create schema for points feature collection table
        var fields = [AGSField]()
        let boundaryField = AGSField(fieldType: .Text, name: "Boundary", alias: "Boundary name", length: 40, domain: nil, editable: true, allowNull: false)
        fields.append(boundaryField)
        
        //initialize feature collection table with the fields created
        //and geometry type as Polyline
        let linesCollectionTable = AGSFeatureCollectionTable(fields: fields, geometryType: .Polyline, spatialReference: AGSSpatialReference.WGS84())
        
        //renderer
        let symbol = AGSSimpleLineSymbol(style: .Dash, color: NSColor.greenColor(), width: 3)
        linesCollectionTable.renderer = AGSSimpleRenderer(symbol: symbol)
        
        // Create a new point feature, provide geometry and attribute values
        let lineFeature = linesCollectionTable.createFeature()
        lineFeature.attributes["Boundary"] = "AManAPlanACanalPanama"
        
        //geometry
        let point1 = AGSPoint(x: -79.497238, y: 8.849289, spatialReference: AGSSpatialReference.WGS84())
        let point2 = AGSPoint(x: -80.035568, y: 9.432302, spatialReference: AGSSpatialReference.WGS84())
        lineFeature.geometry = AGSPolyline(points: [point1, point2])
        
        //add feature to the feature collection table
        linesCollectionTable.addFeature(lineFeature, completion: nil)
        
        return linesCollectionTable
    }
    
    private func polygonsCollectionTable() -> AGSFeatureCollectionTable {
        
        //create schema for points feature collection table
        var fields = [AGSField]()
        let areaField = AGSField(fieldType: .Text, name: "Area", alias: "Area name", length: 40, domain: nil, editable: true, allowNull: false)
        fields.append(areaField)
        
        //initialize feature collection table with the fields created
        //and geometry type as Polygon
        let polygonsCollectionTable = AGSFeatureCollectionTable(fields: fields, geometryType: .Polygon, spatialReference: AGSSpatialReference.WGS84())
        
        //renderer
        let lineSymbol = AGSSimpleLineSymbol(style: .Solid, color: NSColor.blueColor(), width: 2)
        let fillSymbol = AGSSimpleFillSymbol(style: .DiagonalCross, color: NSColor.cyanColor(), outline: lineSymbol)
        polygonsCollectionTable.renderer = AGSSimpleRenderer(symbol: fillSymbol)
        
        // Create a new point feature, provide geometry and attribute values
        let polygonFeature = polygonsCollectionTable.createFeature()
        polygonFeature.attributes["Area"] = "Restricted area"
        
        //geometry
        let point1 = AGSPoint(x: -79.497238, y: 8.849289, spatialReference: AGSSpatialReference.WGS84())
        let point2 = AGSPoint(x: -79.337936, y: 8.638903, spatialReference: AGSSpatialReference.WGS84())
        let point3 = AGSPoint(x: -79.11409, y: 8.895422, spatialReference: AGSSpatialReference.WGS84())
        polygonFeature.geometry =  AGSPolygon(points: [point1, point2, point3])
        
        //add feature to the feature collection table
        polygonsCollectionTable.addFeature(polygonFeature, completion: nil)
        
        return polygonsCollectionTable
    }
}