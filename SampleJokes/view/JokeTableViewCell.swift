//
//  JokeTableViewCell.swift
//  SampleJokes
//
//  Created by Pran Kishore on 03/09/23.
//

import UIKit

class JokeTableViewCell: UITableViewCell {
    
    let lblTitle = UILabel()
    let lblDetail = UILabel()
    let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDetail.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        containerView.addSubview(lblTitle)
        containerView.addSubview(lblDetail)
        setupConstraints()
        setupStyle()
        setupAppearence()
        setupLabelProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            lblTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            lblTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            lblTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            lblDetail.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 10),
            lblDetail.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            lblDetail.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            lblDetail.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupAppearence() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        containerView.backgroundColor = SJColorType.darkGreen.color
        containerView.layer.cornerRadius = 5.0
        containerView.clipsToBounds = true
    }
    
    private func setupStyle() {
        lblTitle.apply(style: SJStyle.elementTitle)
        lblDetail.apply(style: SJStyle.elementDetail)
    }
    
    private func setupLabelProperties() {
        lblTitle.numberOfLines = 0
        lblDetail.numberOfLines = 1
        lblTitle.lineBreakMode = .byWordWrapping
        lblDetail.lineBreakMode = .byTruncatingTail
    }
}
