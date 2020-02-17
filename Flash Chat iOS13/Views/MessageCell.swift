//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Rohmat Suseno on 15/02/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    let containerView = UIView()
    let messageBubble = UIView(backgroundColor: UIColor(named: K.BrandColors.purple)!)
    let messageLabel = UILabel(text: "Message body", font: .systemFont(ofSize: 17), textColor: UIColor(named: K.BrandColors.lightPurple)!, numberOfLines: 0)
    let img = UIImageView(image: UIImage(named: "MeAvatar"))
    let senderImg = UIImageView(image: UIImage(named: "YouAvatar"))
    let senderName = UILabel(text: "Username", font: .boldSystemFont(ofSize: 17), textColor: .black, numberOfLines: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.stack(containerView)
        
        containerView.hstack(senderImg.withSize(.init(width: 40, height: 40)),
                             messageBubble,
                             img.withSize(.init(width: 40, height: 40)),
                             spacing: 20,
                             alignment: .top)
            .withMargins(.allSides(10))
        
        messageBubble.stack(messageLabel)
            .withMargins(.allSides(8))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        messageBubble.layer.cornerRadius = 10 //messageBubble.frame.size.height / 5
    }
}

#if DEBUG
import SwiftUI
struct MessageCell_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 400, height: 120))
    }
    
    struct ContentView: UIViewRepresentable {
        func makeUIView(context: UIViewRepresentableContext<MessageCell_Previews.ContentView>) -> UIView {
            return MessageCell()
        }
        
        func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<MessageCell_Previews.ContentView>) {
            
        }
    }
}
#endif
