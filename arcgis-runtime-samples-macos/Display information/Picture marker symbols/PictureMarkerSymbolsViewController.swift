// Copyright 2016 Esri.
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

import Cocoa
import ArcGIS

class PictureMarkerSymbolsViewController: NSViewController {
    
    @IBOutlet var mapView:AGSMapView!
    
    private var graphicsOverlay = AGSGraphicsOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize map with basemap
        let map = AGSMap(basemap: AGSBasemap.topographicBasemap())
        
        //initial envelope
        let center = AGSPoint(x: -225166.5, y: 6551249, spatialReference: AGSSpatialReference.webMercator())
        map.initialViewpoint = AGSViewpoint(center: center, scale: 1e5)
        
        //assign the map to the map view
        self.mapView.map = map
        
        //add the graphics overlay to the map view
        self.mapView.graphicsOverlays.addObject(self.graphicsOverlay)
        
        //add picture marker symbol using a remote image
        self.addPictureMarkerSymbolFromURL()
        
        //add picture marker symbol using image in assets
        self.addPictureMarkerSymbolFromImage()
    }
    
    private func addPictureMarkerSymbolFromURL() {
        let url = NSURL(string: "https://sampleserver6.arcgisonline.com/arcgis/rest/services/Recreation/FeatureServer/0/images/e82f744ebb069bb35b234b3fea46deae")!
        
        let campsiteSymbol = AGSPictureMarkerSymbol(URL: url)
        
        //optionally set the size (if not set, the size in pixels of the image will be used)
        campsiteSymbol.width = 24
        campsiteSymbol.height = 24
        
        //location for camp site
        let campsitePoint = AGSPoint(x: -223560, y: 6552021, spatialReference: AGSSpatialReference.webMercator())
        
        //graphic for camp site
        let graphic = AGSGraphic(geometry: campsitePoint, symbol: campsiteSymbol, attributes: nil)
        
        //add the graphic to the overlay
        self.graphicsOverlay.graphics.addObject(graphic)
    }
    
    private func addPictureMarkerSymbolFromImage() {
        //image name
        let imageName = "PinBlueStar"
        
        //create pin symbol using the image
        let pinSymbol = AGSPictureMarkerSymbol(image: NSImage(named: imageName)!)
        
        //change offsets, so the symbol aligns properly to the point
        pinSymbol.offsetY = pinSymbol.image!.size.height/2
        
        //location for pin
        let pinPoint = AGSPoint(x: -226773, y: 6550477, spatialReference: AGSSpatialReference.webMercator())
        
        //graphic for pin
        let graphic = AGSGraphic(geometry: pinPoint, symbol: pinSymbol, attributes: nil)
        
        //add the graphic to the overlay
        self.graphicsOverlay.graphics.addObject(graphic)
    }
    
    
}