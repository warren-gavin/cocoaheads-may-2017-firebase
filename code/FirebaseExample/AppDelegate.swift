//
//  AppDelegate.swift
//  FirebaseExample
//
//  Created by Warren Gavin on 15/04/2017.
//  Copyright © 2017 Apokrupto. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BackendConfiguring {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureBackend()
        return true
    }
}

