//
//  LoginVC.swift
//  GalleryApp
//
//  Created by baps on 04/03/24.
//

import UIKit
import GoogleSignIn

class LoginVC: UIViewController {
    
    // ---------------------------------------------------
    //                 MARK: - Outlet -
    // ---------------------------------------------------
    @IBOutlet weak var btnGoogleSignIn: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    
    // ---------------------------------------------------
    //                 MARK: - Property -
    // ---------------------------------------------------
    var name: String?
    
    // ---------------------------------------------------
    //                 MARK: - View Life Cycle -
    // ---------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // ---------------------------------------------------
    //                 MARK: - Action -
    // ---------------------------------------------------
    @IBAction func onBtnGoogleSignIn(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                print("Error signing in with Google: \(error!.localizedDescription)")
                return
            }

            guard let signIn = result else {
                print("Failed to get user information after signing in")
                return
            }

            let user = signIn.user

            var rootVC: UIViewController

            // Access user information
            self.name = user.profile?.name

            let photoGalleryVC = PhotoGalleryVC.instantiate(fromAppStoryboard: .Main)
            
            rootVC = photoGalleryVC
            let navigationController = UINavigationController(rootViewController: rootVC)
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                if let window = appDelegate.window {
                    // Now you have access to the window instance.
                    window.rootViewController = navigationController
                    window.makeKeyAndVisible()
                }
            }
        }
    }
}
