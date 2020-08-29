//
//  CollectionViewCell.swift
//  BackgroundLoading
//
//  Created by Mac on 29.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit


class CollectionViewCell: UICollectionViewCell {
    private var imageView : UIImageView!
    private var usernameLabel : UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.setImageView()
        self.setUsername()
        self.usernameLabel.startLoadingAnimation()
        self.imageView.startLoadingAnimation()
    }
    private func setUsername(){
        self.usernameLabel = UILabel()
        self.usernameLabel.text = ""
        self.usernameLabel.backgroundColor = .lightGray
        self.usernameLabel.numberOfLines = 0
        
        self.usernameLabel.textAlignment = .left
        self.usernameLabel.textColor = .black
        self.usernameLabel.font = UIFont.systemFont(ofSize: 18)
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.usernameLabel)
        self.usernameLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.usernameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.usernameLabel.bottomAnchor.constraint(equalTo: self.imageView.topAnchor , constant: -5).isActive = true
        self.usernameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.usernameLabel.layoutIfNeeded()
    }
    private func setImageView(){
        self.imageView = UIImageView()
        self.imageView.backgroundColor = .lightGray
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor ,constant: -5).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor , constant: 50).isActive = true
        self.imageView.layoutIfNeeded()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setData(title : String){
        self.usernameLabel.backgroundColor = .clear
        self.usernameLabel.text = title
        self.usernameLabel.stopLoadingAnimation()
        
       // self.imageView.sd_setImage(with: URL(string: imageURL), completed: nil)
        self.imageView.image = UIImage(named: "image.jpg")
        self.imageView.stopLoadingAnimation()
    }
}
