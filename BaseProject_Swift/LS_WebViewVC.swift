//
//  MQL_WebViewVC.swift
//  MangQiLai
//
//  Created by 刘帅 on 2020/3/26.
//  Copyright © 2020 ArthurShuai. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import LSRouter_Swift

class LS_WebViewVC: UIViewController, WKUIDelegate, WKNavigationDelegate {

    private var webView: WKWebView?
    
    var htmlName = ""
    var htmlStr = ""
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configWebView()
        LSRouter.addLoadProgress(width: SCREEN_WIDTH, height: 2, lineColor: LSRouter.color(rgbValue: 0xFF5722), presenter: self)
        if url.count > 0 {
            webView?.load(URLRequest(url: url.urlQueryAllow()!))
        } else {
            if htmlName.count > 0 {
                htmlStr = try! String(contentsOfFile: Bundle.main.path(forResource: htmlName, ofType: "html")!, encoding: .utf8)
            }
            htmlStr = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>" + htmlStr
            webView?.loadHTMLString(htmlStr, baseURL: URL(string: ""))
        }
    }
    
    private func configWebView()
    {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let config = WKWebViewConfiguration()
        config.preferences = preferences
        config.allowsInlineMediaPlayback = true
        config.requiresUserActionForMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        config.userContentController = WKUserContentController()
        
        view.backgroundColor = .white
        webView = WKWebView(frame: .zero, configuration: config)
        webView?.backgroundColor = .white
        webView?.isOpaque = false
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        webView?.scrollView.showsVerticalScrollIndicator = false
        webView?.scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(webView!)
        webView?.snp.makeConstraints({ (maker) in
            maker.top.leading.bottom.trailing.equalToSuperview()
        })
        
        navigationController?.navigationBar.backItem?.title = ""
        if #available(iOS 11.0, *) {
            webView?.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            edgesForExtendedLayout = UIRectEdge()
        }
    }

}

// MARK: - WKNavigationDelegate

extension LS_WebViewVC {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        LSRouter.startLoadProgressAt(presenter: self)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        LSRouter.finishedLoadProgressAt(presenter: self)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        LSRouter.finishedLoadProgressAt(presenter: self)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        LSRouter.finishedLoadProgressAt(presenter: self)
        LSRouter.showHint(text: "页面加载失败", presenter: self)
    }
    
    // 处理拨打电话以及Url跳转等等
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let scheme = navigationAction.request.url?.scheme
        if scheme == "tel" {
            DispatchQueue.main.async {
                if UIApplication.shared.canOpenURL(navigationAction.request.url!) {
                    UIApplication.shared.openURL(navigationAction.request.url!)
                }
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
}

// MARK: - WKUIDelegate

extension LS_WebViewVC {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        LSRouter.showHint(text: LSRouter.toString(data: message), presenter: self)
        completionHandler()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        LSRouter.alert2("提示", LSRouter.toString(data: message), { (_) in
            completionHandler(true)
        }) { (_) in
            completionHandler(false)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        var config = LSRouter.AlertConfig()
        config.title = title
        config.message = LSRouter.toString(data: prompt)
        config.hasTextField = true
        var textFieldCopy = UITextField()
        config.configurations = [{(textField) in
            textField.text = defaultText
            textFieldCopy = textField
        }]
        config.actionTitles = [ALERT_CONFIRM, ALERT_CANCEL]
        config.actionStyles = [.default, .cancel]
        config.actions = [{(_) in
            completionHandler(textFieldCopy.text)
        }]
        LSRouter.showAlert(obj: self, config)
    }
    
}
