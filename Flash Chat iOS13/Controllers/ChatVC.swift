//
//  ChatVC.swift
//  Flash Chat iOS13
//
//  Created by Rohmat Suseno on 14/02/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import LBTATools

class ChatVC: UIViewController {
    
    let tableView = UITableView()
    let commentInputView = UIView(backgroundColor: UIColor(named: K.BrandColors.purple)!)
    let commentTf = IndentedTextField(placeholder: "Write a message...", padding: 10, cornerRadius: 10, backgroundColor: .white)
    let sendButton = UIButton(image: UIImage(systemName: "paperplane.fill")!, target: self, action: #selector(didTapSend(_:)))
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: K.BrandColors.purple)
        setupNavBar()
        setupTableView()
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupNavBar() {
        self.navigationItem.hidesBackButton = true
        self.title = K.appName
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(didTapLogout(_:)))
    }
    
    private func setupTableView() {
        setupCommentInputView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: commentInputView.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(MessageCell.self, forCellReuseIdentifier: K.CellIdentifier.messageCell)
    }
    
    private func setupCommentInputView() {
        view.addSubview(commentInputView)
        commentInputView.translatesAutoresizingMaskIntoConstraints = false
        commentInputView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        commentInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        commentInputView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        commentInputView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        sendButton.tintColor = .white
        commentInputView.hstack(commentTf, sendButton.withWidth(30), spacing: 20)
            .withMargins(.init(top: 8, left: 20, bottom: 0, right: 20))
    }
    
    private func loadMessages() {
        db.collection(K.FStore.collectionName).getDocuments { (querySnapshot, error) in
            if let err = error {
                print("There was an issue retrieveing data from Firestore. \(err)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String, let message = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: sender, body: message)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc fileprivate func didTapSend(_ sender: UIButton) {
        if let message = commentTf.text, let sender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: sender,
                                                                      K.FStore.bodyField: message]) { (error) in
                                                                        if let err = error {
                                                                            print("There was an issue saving data to Firestore \(err.localizedDescription)")
                                                                        } else {
                                                                            print("Successfully saved data.")
                                                                        }
            }
        }
    }
    
    @objc fileprivate func didTapLogout(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            if self.navigationController?.previousViewController == nil {
                self.show(LoginRegisterVC(), sender: self)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

// MARK: - UINavigationController
extension UINavigationController {
    var previousViewController: UIViewController? {
        return viewControllers.count > 1 ? viewControllers[viewControllers.count - 2] : nil
    }
}

// MARK: - UITableViewDataSource
extension ChatVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.separatorStyle = .none
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier.messageCell, for: indexPath) as! MessageCell
        //cell.selectionStyle = .none
        cell.messageLabel.text = messages[indexPath.row].body
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChatVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

#if DEBUG
import SwiftUI
struct ChatVC_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice(.init(stringLiteral: "iPhone 11 Pro")).edgesIgnoringSafeArea(.all)
    }
    
    struct ContentView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<ChatVC_Previews.ContentView>) -> UIViewController {
            return UINavigationController(rootViewController: ChatVC())
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ChatVC_Previews.ContentView>) {
            
        }
    }
}
#endif
