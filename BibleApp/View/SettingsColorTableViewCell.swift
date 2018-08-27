//
//  SettingsColorTableViewCell.swift
//  BibleApp
//
//  Created by Min Kim on 8/25/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class SettingsColorTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(containerView)
        containerView.addSubview(colorStackView)
        layoutViews()
        setupColorViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func layoutViews() {
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        colorStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        colorStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        colorStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        colorStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 3/4).isActive = true
    }
    
    let colors = [MainColor.redOrange, MainColor.blue, MainColor.green, MainColor.purple, MainColor.lightBlue]
    
    var sendColor: ((UIColor?) -> ())?
    
    func setupColorViews() {
        colors.forEach { (color) in
            let view = UIView()
            view.layer.cornerRadius = 20
            view.layer.masksToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = color
            view.heightAnchor.constraint(equalToConstant: 40).isActive = true
            view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressColor)))
            colorStackView.addArrangedSubview(view)
        }
        
    }
    
    @objc func didPressColor(sender: UITapGestureRecognizer) {
        guard let color = sender.view?.backgroundColor else {return}
        sendColor?(color)
    }
    
    
    let containerView: UIView = {
       let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let colorStackView: UIStackView = {
       let cs = UIStackView()
        cs.axis = .horizontal
        cs.distribution = .equalSpacing
        cs.translatesAutoresizingMaskIntoConstraints = false
        cs.spacing = 8
        return cs
    }()
    
    
    

}
