//
//  TrailerPlayViewController.swift
//  Flix
//
//  Created by Sanaz Khosravi on 9/12/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit
import WebKit

class TrailerPlayViewController: UIViewController {

    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet var myWebView: WKWebView!
    
    var youtubeKey : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let videoURL:URL = URL(string: "https://www.youtube.com/watch?v=\(youtubeKey)autoplay=1"){
            let configuration = WKWebViewConfiguration()
            configuration.allowsInlineMediaPlayback = true
            configuration.mediaTypesRequiringUserActionForPlayback = .audio
            myWebView.load(URLRequest(url: videoURL))
        }
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
