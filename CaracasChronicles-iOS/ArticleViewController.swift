//
//  ArticleViewController.swift
//  CaracasChronicles-iOS
//
//  Created by Alejandro on 1/21/16.
//
//

import UIKit

class ArticleViewController: UIViewController {
    var URL: NSURL!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(NSURLRequest(URL: URL))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ArticleViewController: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}