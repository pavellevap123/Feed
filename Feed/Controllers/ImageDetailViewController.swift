//
//  ImageDetailViewController.swift
//  Feed
//
//  Created by Pavel Poddubotskiy on 1.09.22.
//

import UIKit

final class ImageDetailViewController: UIViewController {
    
    var image: UIImage?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension ImageDetailViewController {
    private func style() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        imageView.image = image
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
