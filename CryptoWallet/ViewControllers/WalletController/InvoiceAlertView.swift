//
//  InvoiceAlertView.swift
//  CryptoWallet
//
//  Created by AI on 22/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit
import Foundation

protocol InvoiceAlertViewDelegate {
    func didAccept()
}

class InvoiceAlertView: UIView, Modal {
    
    var delegate: InvoiceAlertViewDelegate?
    
    var backgroundView = UIView()
    var dialogView = UIView()
    
    convenience init(title:String,image:UIImage) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title, image: image)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initialize(title:String, image:UIImage){
        dialogView.clipsToBounds = true
        
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        addSubview(backgroundView)
        
        let dialogViewWidth = frame.width-64
        
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 8, width: dialogViewWidth-16, height: 40))
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        dialogView.addSubview(titleLabel)
        
        let separatorLineView = UIView()
        separatorLineView.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + 8)
        separatorLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView.backgroundColor = UIColor.groupTableViewBackground
        dialogView.addSubview(separatorLineView)
        
        let imageView = UIImageView()
        imageView.frame.origin = CGPoint(x: 8, y: separatorLineView.frame.height + separatorLineView.frame.origin.y + 8)
        imageView.frame.size = CGSize(width: dialogViewWidth - 16 , height: dialogViewWidth - 16)
        imageView.image = image
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        dialogView.addSubview(imageView)
        
        let separatorLineView2 = UIView()
        separatorLineView2.frame.origin = CGPoint(x: 0, y: imageView.frame.origin.y + imageView.frame.height + 8)
        separatorLineView2.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView2.backgroundColor = UIColor.groupTableViewBackground
        dialogView.addSubview(separatorLineView2)
        
        let declineButton = UIButton()
        declineButton.setTitle("Decline", for: .normal)
        declineButton.setTitleColor(.red, for: .normal)
        declineButton.addTarget(self, action: #selector(tapDecline), for: .touchUpInside)
        let acceptButton = UIButton()
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setTitleColor(UIColor.mainBlue(), for: .normal)
        acceptButton.addTarget(self, action: #selector(tapAccept), for: .touchUpInside)
        let stackView = UIStackView(arrangedSubviews: [declineButton, acceptButton])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.frame = CGRect(x: 8, y: separatorLineView2.frame.height + separatorLineView2.frame.origin.y, width: dialogViewWidth - 16, height: 50)
        dialogView.addSubview(stackView)
        
        let dialogViewHeight = titleLabel.frame.height + 8 + separatorLineView.frame.height + 8 + imageView.frame.height + 8 + separatorLineView2.frame.height + stackView.frame.height
        
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        addSubview(dialogView)
        
    }
    
    @objc func tapAccept() {
        delegate?.didAccept()
        dismiss(animated: true)
    }
    
    @objc func tapDecline() {
        dismiss(animated: true)
    }
    
}
