//
//  AppDelegate.swift
//  Walk4Health
//
//  Created by Paul Kirk Adams on 3/22/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit
import LaunchKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        UIApplication.sharedApplication().statusBarStyle = .LightContent
        LaunchKit.launchWithToken("5BVpp5-2e7tKRD1ldaPRZK6gpJcWYaW_oWEEwvcJOqRL")

        // Uncomment for release build
                let defaults = NSUserDefaults.standardUserDefaults()
                let hasShownOnboarding = defaults.boolForKey("shownOnboardingBefore")
                if !hasShownOnboarding {
                    let lk = LaunchKit.sharedInstance()
                    lk.presentOnboardingUIOnWindow(self.window!) { _ in
                        print("Showed onboarding!")
                        defaults.setBool(true, forKey: "shownOnboardingBefore")
                    }
                }

        // Uncomment for debugging
//        let lk = LaunchKit.sharedInstance()
//        lk.presentOnboardingUIOnWindow(self.window!) { _ in
//            print("Onboarding presented!")
//        }

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