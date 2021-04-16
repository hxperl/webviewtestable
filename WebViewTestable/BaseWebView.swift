import SwiftUI
import WebKit

struct BaseWebView: View {
  let url: URL
  var body: some View {
    WebView(request: URLRequest(url: url))
  }
}

struct WebView: UIViewRepresentable {
  let request: URLRequest
  class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
    let parent: WebView
    init(_ parent: WebView) {
      self.parent = parent
    }
    
    func webView(
      _ webView: WKWebView,
      didReceive challenge: URLAuthenticationChallenge,
      completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
      if let serverTrust = challenge.protectionSpace.serverTrust {
        completionHandler(.useCredential, URLCredential(trust: serverTrust))
      }
    }
    
    func webView(
      _ webView: WKWebView,
      decidePolicyFor navigationAction: WKNavigationAction,
      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
      if let url = navigationAction.request.url,
         UIApplication.shared.canOpenURL(url) {
        if url.absoluteString.contains("kakao") {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
          decisionHandler(.cancel)
        } else {
          decisionHandler(.allow)
        }
      } else {
        decisionHandler(.allow)
      }
    }
  }
  
  func makeCoordinator() -> WebView.Coordinator {
    Coordinator(self)
  }
  
  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.uiDelegate = context.coordinator
    webView.navigationDelegate = context.coordinator
    return webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.load(request)
  }
}



struct HideSystemNavigationBar: ViewModifier {
  func body(content: Content) -> some View {
    content
      .navigationBarTitle("")
      .navigationBarHidden(true)
  }
}
