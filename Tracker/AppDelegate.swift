//
//  AppDelegate.swift
//  Tracker
//
//  Created by Дарья Шишмакова on 24.04.2023.
//

import UIKit
import CoreData
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Store")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "3452aed3-8572-4c17-ac93-2718cd98baa8") else {
            return true
        }
            
        YMMYandexMetrica.activate(with: configuration)
        return true
    }
}
