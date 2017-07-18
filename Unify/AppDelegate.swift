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
        
        
        let config: CountlyConfig = CountlyConfig()
        config.appKey = "02e21c191641f26f18c393b4b1f5a210be5bda15"
        config.host = "http://45.55.197.96/"
        //You can specify optional features you want here
        config.features = [CLYPushNotifications, CLYCrashReporting, CLYAutoViewTracking]
        
        Countly.sharedInstance().start(with: config)
        
        
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
        
        
        if let user = UDWrapper.getDictionary("user"){
            // Assign current user to manager object
            //
            
            print("USER DICTIONARY")
            print(user)
            
            print("User has profile!")
            ContactManager.sharedManager.currentUser = User(withDefaultsSnapshot:user)
            
            print("CURRENT USER FROM APP DELEGATE")
            ContactManager.sharedManager.currentUser.printUser()
            
            // Send to home screen 
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabView") as!
            TabBarViewController
            window!.rootViewController = homeViewController
            
        }else{
            print("User has no profile")
            
        }
 
      
        
        
        // iOS 10 support
        
        if #available(iOS 10, *) {
            
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            
            application.registerForRemoteNotifications()
            
        }
            
            // iOS 9 support
            
        else if #available(iOS 9, *) {
            
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            
            UIApplication.shared.registerForRemoteNotifications()
            
        }
            
            // iOS 8 support
            
        else if #available(iOS 8, *) {
            
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            
            UIApplication.shared.registerForRemoteNotifications()
            
        }
            
            // iOS 7 support
            
        else {
            
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
            
        }

        
        
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceTokendeviceToken: Data) {
        
        // Convert token to string
        
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        
        
        // Print it to console
        
        print("APNs device token: \(token)")
        
        
        
        
    }
    
    
    // Called when APNs failed to register the device for push notifications
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        // Print the error to console (you should alert the user that registration failed)
        
        print("APNs registration failed: \(error)")
        
    }
    
    
    // Push notification received
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        
        // Print notification payload data
        
        print("Push notification received: \(data)")
        
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

