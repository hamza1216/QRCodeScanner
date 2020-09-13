//
//  ExtensionView.swift
//  Walli
//
//  Created by Xian Huang on 1/26/20.
//  Copyright © 2020 Xian Huang. All rights reserved.
//

import UIKit

@IBDesignable class ExtensionView: UIView {
    
    @IBInspectable var borderColor: UIColor = .black { didSet { self.layer.borderColor = self.borderColor.cgColor } }
    @IBInspectable var borderWidth: CGFloat = 0.00 { didSet { self.layer.borderWidth = self.borderWidth } }
    @IBInspectable var cornerRadius: CGFloat = 0.00 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            layoutImage()
        }
    }
    
    @IBInspectable var topCornerRadius: CGFloat = 0.00 {
        didSet {
            self.layer.cornerRadius = self.topCornerRadius
            self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            layoutImage()
        }
    }
    // ImageView Attributes
    @IBInspectable var image: UIImage? { didSet {  layoutImage() } }
    @IBInspectable var imageContentMode: UIView.ContentMode = .scaleAspectFit { didSet { layoutImage() } }
    
    // Shadow Attributes
    @IBInspectable var imageShadowColor: UIColor = .black { didSet { dropShadow() } }
    @IBInspectable var imageShadowOpacity: Float = 0.0 { didSet { dropShadow() } }
    @IBInspectable var imageShadowRadius: CGFloat = 0.0 { didSet { dropShadow() } }
    @IBInspectable var imageShadowOffset: CGSize = .zero { didSet { dropShadow() } }
    
    fileprivate var imageView = UIImageView()
    
    override func layoutSubviews() {
        layoutImage()
        dropShadow()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    fileprivate func setupView() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    fileprivate func layoutImage() {
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height)
        self.addSubview(imageView)
        imageView.image = self.image
        imageView.contentMode = self.contentMode
        imageView.layer.cornerRadius = self.layer.cornerRadius
        imageView.layer.masksToBounds = true
    }
    
    fileprivate func dropShadow() {
        self.layer.shadowColor = imageShadowColor.cgColor
        self.layer.shadowOpacity = imageShadowOpacity
        self.layer.shadowOffset = imageShadowOffset
        self.layer.shadowRadius = imageShadowRadius
        self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: cornerRadius).cgPath
    }
}
