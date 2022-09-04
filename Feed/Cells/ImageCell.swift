//
//  ImageCell.swift
//  Feed
//
//  Created by Pavel Poddubotskiy on 1.09.22.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    
    static let reuseID = "ImageCell"
    
    let headlineView = HeadlineView()
    let sublineView = SublineView()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageCell {
    
    func style() {
        contentView.addSubview(imageView)
        contentView.addSubview(headlineView)
        contentView.addSubview(sublineView)
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }
    
    func layout() {
        
        NSLayoutConstraint.activate([
            //Headline
            headlineView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            //ImageView
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: headlineView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            //SublineView
            sublineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sublineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sublineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        headlineView.label.text = ""
        sublineView.label.text = ""
    }
}
