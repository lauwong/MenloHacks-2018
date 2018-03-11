//
//  SignInViewController.swift
//  FamilyCheckIn
//
//  Created by Lauren Wong on 3/11/18.
//  Copyright © 2018 MenloHacks. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func viewWillAppear() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
}
