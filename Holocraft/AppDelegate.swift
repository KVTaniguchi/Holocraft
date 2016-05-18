//
//  AppDelegate.swift
//  Holocraft
//
//  Created by Kevin Taniguchi on 5/2/16.
//  Copyright © 2016 Taniguchi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let tabBarController = UITabBarController()
    
    let hcCreateVC = HCCreateViewController()
    let hcViewHologramsVC = HCViewHologramsViewController()
    let hcLearnVC = HCLearnViewController()
    let hcBuyVC = HCBuyViewController()
    
    let createNav = UINavigationController()
    let viewNav = UINavigationController()
    let learnNav = UINavigationController()
    let buyNav = UINavigationController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        createNav.pushViewController(hcCreateVC, animated: false)
        viewNav.pushViewController(hcViewHologramsVC, animated: false)
        learnNav.pushViewController(hcLearnVC, animated: false)
        buyNav.pushViewController(hcBuyVC, animated: false)
        
        createNav.tabBarItem.title = "Create"
        viewNav.tabBarItem.title = "View"
        learnNav.tabBarItem.title = "Learn"
        buyNav.tabBarItem.title = "Buy"
        
        createNav.tabBarItem.image = UIImage(named: "old_time_camera-32")
        viewNav.tabBarItem.image = UIImage(named: "stack_of_photos-32")
        learnNav.tabBarItem.image = UIImage(named: "bookmark-32")
        buyNav.tabBarItem.image = UIImage(named: "price_tag-32")
        
        let controllers = [viewNav, createNav, learnNav, buyNav]
        tabBarController.viewControllers = controllers
        tabBarController.tabBar.translucent = false
        tabBarController.tabBar.tintColor = UIColor.blackColor()
        
        if let items = tabBarController.tabBar.items {
            for item in items {
                item.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir", size: 14)!, NSForegroundColorAttributeName: UIColor.blackColor()], forState: .Normal)
            }
        }
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}

