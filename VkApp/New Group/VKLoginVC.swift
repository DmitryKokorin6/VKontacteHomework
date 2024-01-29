//
//  VKLoginVC.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 02.10.2023.
//

import Foundation
import WebKit

final class VKLoginVC: UIViewController {
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue) {
        Session.instance.token = ""
        Session.instance.userId = "0"
        // обнуляю данные на веь View
        // иначе не получиься выйьи оь прилоия, поьому чьо при выходе назад
        let dataSource = WKWebsiteDataStore.default()
        dataSource.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach {
                //если содержит vk
                if $0.displayName.contains("vk") {
                    dataSource.removeData(
                        ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                        for: [$0]) { [weak self] in
                            guard let self = self,
                                  let url = urlComponents.url
                            else { return }
                            self.webView.load(URLRequest(url: url))
                        }
                }
            }
        }
    }
    
    private var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "8222650"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        return components
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let url = urlComponents.url
        else { return }
        webView.load(URLRequest(url: url))
    }
}

extension VKLoginVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
        // разрешение проходииь дальше we View
        // decisionHandler делаеь проход между дисплеми
        else { return decisionHandler(.allow) }
        // fragment это , что возмвращаеь сервер , то куда хочу перейти, чьо и query Iyem
        let parameters = fragment
        // делю на кдддненты
            .components(separatedBy: "&")
        // каждый элемень делиься на =, ьереься элемень где имееься =
            .map { $0.components(separatedBy: "=") }
        //приведение к нужному типу
            .reduce([String : String]()) { partialResult, params in
                var dict = partialResult
                let key = params[0]
                let value = params[1]
                dict[key] = value
                
                return dict
            }
        
        guard
            let token = parameters["access_token"],
            let userIdString = parameters["user_id"],
            let userId = Int(userIdString)
        else { return decisionHandler(.allow) }
        
        print(token)
        print(userId)
        
        Session.instance.token = token
        Session.instance.userId = userIdString
        
        performSegue(
            withIdentifier: "goToLogin",
            sender: nil)
        //чтоьы не переходило дальше на пусьую строку blank.html
        decisionHandler(.cancel)
    }
}
