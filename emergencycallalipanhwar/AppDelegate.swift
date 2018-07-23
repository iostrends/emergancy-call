//
//  AppDelegate.swift
//  emergencycallalipanhwar
//
//  Created by Mohammad ali panhwar on 5/21/18.
//  Copyright © 2018 Mohammad ali panhwar. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import CoreData
import FirebaseAuth
struct OnlineOfflineService {
    static func online(for uid: String, status: Bool, success: @escaping (Bool) -> Void) {
        //True == Online, False == Offline
        let onlinesRef = Database.database().reference().child("onlinePatients").child(uid).child("isOnline")
        
        onlinesRef.setValue(status) {(error, _ ) in
            
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            }
            success(true)
            
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
  
    var numberData = ""
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let uid = Auth.auth().currentUser?.uid
        let online = Database.database().reference().child("onlinePatients").child(uid!)
        let online1 = Database.database().reference().child("EmergencyRequest").child(uid!)
        let online2 = Database.database().reference().child("AcceptedRequest")

        online1.onDisconnectRemoveValue()
        online.onDisconnectRemoveValue()
        online2.onDisconnectRemoveValue()
        
        if Auth.auth().currentUser != nil {
            OnlineOfflineService.online(for: (Auth.auth().currentUser?.uid)!, status: true){ (success) in
                
                print("User ==>", success)
                
            }
        }
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyAINGiLngGoIhFlBbcFfCnR9Ck0NOC5BTs")
        GMSPlacesClient.provideAPIKey("AIzaSyAINGiLngGoIhFlBbcFfCnR9Ck0NOC5BTs")
        
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                // instantiate your desired ViewController
                let rootController = storyboard.instantiateViewController(withIdentifier: "mapView") as! MapViewController
                
                // Because self.window is an optional you should check it's value first and assign your rootViewController
                if let window = self.window {
                    window.rootViewController = rootController
                }
            }
        }
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
        if Auth.auth().currentUser != nil {
            OnlineOfflineService.online(for: (Auth.auth().currentUser?.uid)!, status: false){ (success) in
                
                print("User ==>", success)
            }
        }
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }



}

