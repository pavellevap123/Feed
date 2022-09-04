//
//  SublineView.swift
//  Feed
//
//  Created by Pavel Poddubotskiy on 1.09.22.
//

import UIKit

final class SublineView: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        return imageView
    }()
    
    private lazy var topSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 40)
    }
}

extension SublineView {
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemBackground
        addSubview(topSeparator)
        addSubview(label)
        addSubview(imageView)
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            //topSeparator
            topSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSeparator.topAnchor.constraint(equalTo: topAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            //Label
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            //Image
            trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
