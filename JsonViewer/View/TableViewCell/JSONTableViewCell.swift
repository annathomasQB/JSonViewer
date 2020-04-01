//
//  JSONTableViewCell.swift
//  JsonViewer
//
//  Created by AnnaThomas on 01/04/20.
//  Copyright © 2020 QBurst Technologies. All rights reserved.
//

import Foundation
import UIKit

class JSONTableViewCell: UITableViewCell {
    var imageLoader = ImageLoader()
    var jsonModel:JSONModel? {
        didSet {
            guard let jsonModel = jsonModel else {return}
            if let title = jsonModel.title {
                titleLabel.text = title
            }
            if let description = jsonModel.description {
                descriptionLabel.text = description
            }
            if let imageName = jsonModel.image {
                imageLoader.obtainImageWithPath(imagePath: imageName) { (image) in
                    DispatchQueue.main.async {
                        self.jsonImageView.image = image
                    }
                }
            }
        }
    }
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jsonImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = 35
        img.clipsToBounds = true
        return img
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(jsonImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        let marginGuide = contentView.layoutMarginsGuide

        NSLayoutConstraint.activate([
            // imageview
            jsonImageView.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor),
            jsonImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 2),
            jsonImageView.widthAnchor.constraint(equalToConstant: 70),
            jsonImageView.heightAnchor.constraint(equalToConstant: 70),
            
            // title
            titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: jsonImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: 2),

            // description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: jsonImageView.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: 2),
            descriptionLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 2)
            ])
        
        
    }
}
