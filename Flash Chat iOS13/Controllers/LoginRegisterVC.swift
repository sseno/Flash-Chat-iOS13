//
//  LoginRegisterVC.swift
//  Flash Chat iOS13
//
//  Created by Rohmat Suseno on 14/02/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit
import LBTATools
import CLTypingLabel
import FirebaseAuth

class PortalVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: K.BrandColors.blue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            switchRootViewController(rootViewController: ChatVC(), animated: true, completion: nil)
        } else {
            //no user is signed in.
            switchRootViewController(rootViewController: LoginRegisterVC(), animated: true, completion: nil)
        }
    }
    
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        //let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = UINavigationController(rootViewController: rootViewController)
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
}

class LoginRegisterVC: LBTAFormController {
    
    let logoImg = UIImageView(image: UIImage(named: "AppIcon"), contentMode: .scaleAspectFit)
    var titleLabel = CLTypingLabel(text: "", font: .boldSystemFont(ofSize: 28), textColor: .white, textAlignment: .center)
    let emailTextField = IndentedTextField(placeholder: "Email address", padding: 10, cornerRadius: 10, keyboardType: .emailAddress, backgroundColor: .white)
    let passwordTextField = IndentedTextField(placeholder: "Password", padding: 10, cornerRadius: 10, keyboardType: .emailAddress, backgroundColor: .white, isSecureTextEntry: true)
    let registerButton = UIButton(title: "Register", titleColor: .white, font: .boldSystemFont(ofSize: 18), backgroundColor: UIColor(named: K.BrandColors.purple)!, target: self, action: #selector(didTapRegister(_:)))
    let loginButton = UIButton(title: "Log In", titleColor: .black, font: .boldSystemFont(ofSize: 18), backgroundColor: .white, target: self, action: #selector(didTapLogin(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        titleLabel.text = K.appName
        
        ///animate letter text without library
//        titleLabel.text = ""
//        var charIndex = 0.0
//        let titleText = "⚡️FlashChat"
//        for letter in titleText {
//            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
//                self.titleLabel.text?.append(letter)
//            }
//            charIndex += 1
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.init(named: "BrandBlue")
        
        formContainerStackView.axis = .vertical
        formContainerStackView.spacing = 30
        formContainerStackView.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)

        formContainerStackView.addArrangedSubview(titleLabel)
        
        // setup textField
        let vsv = UIStackView(arrangedSubviews: [emailTextField.withHeight(50),
                                                 passwordTextField.withHeight(50)])
        vsv.axis = .vertical
        vsv.spacing = 15
        formContainerStackView.addArrangedSubview(vsv)
        
        // setup button
        registerButton.layer.cornerRadius = 10
        loginButton.layer.cornerRadius = 10
        let hsv = UIStackView(arrangedSubviews: [registerButton.withHeight(50),
                                                 loginButton.withHeight(50)])
        hsv.axis = .horizontal
        hsv.spacing = 10
        hsv.distribution = .fillEqually
        formContainerStackView.addArrangedSubview(hsv)
    }
    
    @objc fileprivate func didTapRegister(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    self.show(ChatVC(), sender: self)
                }
            }
        }
        else {
            print("email / password can't be empty")
        }
    }
    
    @objc fileprivate func didTapLogin(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    self.show(ChatVC(), sender: self)
                }
            }
        }
    }
}

#if DEBUG
import SwiftUI
struct LoginRegister_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice(.init(stringLiteral: "iPhone 11 Pro")).edgesIgnoringSafeArea(.all)
    }
    
    struct ContentView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<LoginRegister_Previews.ContentView>) -> UIViewController {
            return LoginRegisterVC()
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LoginRegister_Previews.ContentView>) {
            
        }
    }
}
#endif
