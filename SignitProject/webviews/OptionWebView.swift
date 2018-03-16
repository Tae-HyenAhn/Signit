
import UIKit
import WebKit

class OptionWebView: UIViewController, WKUIDelegate {

    var url : String = String()
    
    var webView : WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

}
