//
//  WebDetailViewController.swift
//  Feed
//
//  Created by Pavel Poddubotskiy on 1.09.22.
//

import UIKit
import WebKit

final class WebDetailViewController: UIViewController {
    
    var stringUrl = ""
    
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        
        guard let url = URL(string: stringUrl) else { return }
        webView.load(URLRequest(url: url))
    }
}

extension WebDetailViewController {
    private func style() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
