//
//  AppDelegate.swift
//  Todoey
//
//  Created by Arman morshed on 13/3/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import UIKit

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        
        do{
            _ = try Realm()
            
        }catch{
            print("Error Installing new realm \(error)")
        }
    
        
        return true
    }



}

