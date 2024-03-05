//
//  AppDelegate.swift
//  GalleryApp
//
//  Created by baps on 04/03/24.
//

import UIKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                
            } else {
                var navigationcontroller: UINavigationController?
                let photoGalleryVC = PhotoGalleryVC.instantiate(fromAppStoryboard: .Main)
                navigationcontroller = UINavigationController(rootViewController: photoGalleryVC)
                self.window?.rootViewController = navigationcontroller
                self.window?.makeKeyAndVisible()
            }
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        
        if handled {
            return true
        }
        
        return false
    }
}
