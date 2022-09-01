//
//  HeadlineView.swift
//  Feed
//
//  Created by Pavel Poddubotskiy on 1.09.22.
//

import UIKit

class HeadlineView: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var bottomSeparator: UIView = {
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

extension HeadlineView {
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemBackground
        addSubview(label)
        addSubview(bottomSeparator)
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            //Label
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            //BottomSeparator
            bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
