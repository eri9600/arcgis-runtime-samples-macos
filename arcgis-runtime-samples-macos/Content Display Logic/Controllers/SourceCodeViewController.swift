//
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
//

import Cocoa
import WebKit

class SourceCodeViewController: NSViewController, NSSearchFieldDelegate {

    @IBOutlet var popUpButton:NSPopUpButton!
    @IBOutlet var webView:WebView!
    @IBOutlet var searchField: NSSearchField!
    @IBOutlet var noResultLabel: NSTextField!
    
    var fileNames:[String]! {
        didSet {
            //load the source code
            if self.fileNames != nil && self.fileNames.count > 0 {
                self.loadHTMLPage(self.fileNames[0])
            }
            
            //populate popUpButton
            self.popUpButton.addItems(withTitles: self.fileNames)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - HTML logic
    
    func loadHTMLPage(_ filename:String) {
        if let content = self.contentOfFile(filename) {
            let htmlString = self.htmlStringForContent(content)
            self.webView.mainFrame.loadHTMLString(htmlString, baseURL: URL(fileURLWithPath: Bundle.main.bundlePath))
        }
    }
    
    func contentOfFile(_ name:String) -> String? {
        //find the path of the file
        if let path = Bundle.main.path(forResource: name, ofType: ".swift") {
            //read the content of the file
            if let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) {
                return content
            }
        }
        return nil
    }
    
    func htmlStringForContent(_ content:String) -> String {
        let cssPath = Bundle.main.path(forResource: "xcode", ofType: "css") ?? ""
        let jsPath = Bundle.main.path(forResource: "highlight.pack", ofType: "js") ?? ""
//        let scale  = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? "0.5" : "1.0"
        let scale = "1.0"
        let stringForHTML = "<html> <head>" +
            "<meta name='viewport' content='width=device-width, initial-scale='\(scale)'/> " +
            "<link rel=\"stylesheet\" href=\"\(cssPath)\">" +
            "<script src=\"\(jsPath)\"></script>" +
            "<script>hljs.initHighlightingOnLoad();</script> </head> <body>" +
            "<pre><code class=\"Swift\">\(content)</code></pre>" +
        "</body> </html>"
        //        println(stringForHTML)
        // style=\"white-space:initial;\"
        return stringForHTML
    }
    
    //MARK: - Actions
    
    @IBAction func popUpButtonAction(_ sender: AnyObject) {
        let filename = popUpButton.titleOfSelectedItem!
        self.loadHTMLPage(filename)
    }
    
    @IBAction func search(_ sender: AnyObject) {
        if self.searchField.stringValue.isEmpty {
            return
        }
        
        let success = self.webView.search(for: self.searchField.stringValue, direction: true, caseSensitive: false, wrap: true)
        
        if !success {
            //show no result label
            self.noResultLabel.isHidden = false
        }
    }
    
    //MARK: - NSSearchField delegate
    
    override func controlTextDidChange(_ notification: Notification) {
        if let sender = notification.object as? NSSearchField , sender == self.searchField {
            //hide no results label if visible
            self.noResultLabel.isHidden = true
        }
    }
    
    //support for search when focused on webView and return key pressed
    override func keyDown(with event: NSEvent) {
        
        //for return key inside web view
        if event.keyCode == 36 {
            if let webHTMLView = self.view.window?.firstResponder as? NSView, webHTMLView.isDescendant(of: self.webView) {
                
                self.search(self.searchField)
            }
        }
    }
}
