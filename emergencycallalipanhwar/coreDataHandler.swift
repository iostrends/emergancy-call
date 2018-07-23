//
//  coreDataHandler.swift
//  emergencycallalipanhwar
//
//  Created by Mohammad ali panhwar on 6/5/18.
//  Copyright © 2018 Mohammad ali panhwar. All rights reserved.
//

import UIKit
import CoreData

class coreDataHandler: NSObject {

    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    class func saveObject(username:String,email:String) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        manageObject.setValue(username, forKey: "username")
        manageObject.setValue(email, forKey: "email")
        
        do {
            try context.save()
            return true
        }catch {
            return false
        }
    }
    class func fetchObject() -> [Users]? {
        let context = getContext()
        var user:[Users]? = nil
        
        do{
            user = try context.fetch(Users.fetchRequest())
            return user
        }catch {
            return user
        }
    }
}
