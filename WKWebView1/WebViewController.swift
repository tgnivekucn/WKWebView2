//
//  WebViewController.swift
//  WKWebView1
//
//  Created by 粘光裕 on 2018/11/1.
//  Copyright © 2018年 com.open.lib. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {
    var mWebView: WKWebView? = nil
    @IBOutlet weak var mBackBtn: UIButton!
    @IBOutlet weak var mForwardBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURL()
    }
    
    private func loadURL() {
        mBackBtn.isEnabled = false
        mForwardBtn.isEnabled = false
        // init and load request in webview.
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "ToApp")
        mWebView = WKWebView(frame: self.view.frame, configuration: configuration)
        mWebView?.frame.origin.y = mBackBtn.frame.origin.y + CGFloat(40)
        if let mWebView = mWebView {
            mWebView.navigationDelegate = self
            let HTML = try! String(contentsOfFile: Bundle.main.path(forResource: "demo", ofType: "html")!, encoding: String.Encoding.utf8)
            mWebView.loadHTMLString(HTML, baseURL: nil)
            self.view.addSubview(mWebView)
            self.view.sendSubviewToBack(mWebView)
        }
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        if mWebView?.goBack() == nil {
            print("No more page to back")
        }

    }
    
    @IBAction func forwardAction(_ sender: UIButton) {
        if mWebView?.goForward() == nil {
            print("No more page to forward")
        }
    }
    @IBAction func sendMsgToJS(_ sender: UIButton) {
        mWebView?.evaluateJavaScript("sendMessage('swift message')") { (result, err) in
            print(result, err)
        }
    }
}


extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        if let webView = mWebView {
            mForwardBtn.isEnabled = webView.canGoForward
            mBackBtn.isEnabled = webView.canGoBack
        }
    }
}


extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
    }
}
