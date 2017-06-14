//
//  AppDelegate.swift
//  Unify
//
//  Created by Ryan Hickman on 4/2/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Reachability
import UIKit
import Firebase
import Fabric
import Crashlytics


var global_uuid: String?
var global_phone: String?
var global_image: UIImage?
var global_givenName: String?
var global_email: String?


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let colorForLocalOrigin = UIColor(red: 0.9, green: 0.97, blue: 1.0, alpha: 1.0)

    var reachability: Reachability!

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        
        // Crash reporting with fabric 
        Fabric.with([Crashlytics.self])
        
        // Listen for network reachability changes.
        self.reachability = Reachability.forInternetConnection()
        self.reachability.reachableBlock = {
            (reachability: Reachability?) -> Void in
            // Nothing to do
        }
        self.reachability.unreachableBlock = {
            (reachability: Reachability?) -> Void in
            // Nothing to do
        }
        self.reachability.startNotifier()
        
        // Set up an on-disk URL cache.
        let urlCache = URLCache(memoryCapacity: 0, diskCapacity:50 * 1024 * 1024, diskPath:nil)
        URLCache.shared = urlCache
        
        
        // Managing stored user sessions
        
        let storedUUID = UserDefaults.standard.string(forKey: "uuid")
        
        if ((storedUUID) != nil)
        {
            global_uuid = storedUUID
        }
        
        // Check if user logged in, if not kick back to home vc
        
       /* let userLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if (userLoggedIn && (storedUUID != nil)){
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabView") as!
            TabBarViewController
            window!.rootViewController = homeViewController
        }
        */
        
      
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

