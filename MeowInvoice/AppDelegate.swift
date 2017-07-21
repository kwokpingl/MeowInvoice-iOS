//
//  AppDelegate.swift
//  MeowInvoice
//
//  Created by David on 2017/5/29.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GoogleMobileAds
import Firebase
import UserNotifications
import SwiftyUserDefaults

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    // Crashlytics
    Crashlytics.start(withAPIKey: SecretKey.fabricAPIKey)
    
    // Firebase
    FirebaseApp.configure()
    
    // ADMob
    GADMobileAds.configure(withApplicationID: SecretKey.admobAPIKey)
    
    // Analytics
    AnalyticsHelper.instance().initialize()
    if !Defaults[.didLaunchOnce] {
      AnalyticsHelper.instance().setInitialUserProperties()
      Defaults[.didLaunchOnce] = true
    }
    AnalyticsHelper.instance().logAppLaunchEvent()
    
    // Remote notification
    let notificationStore = DefaultNotificationSettingStoreService()
    if !notificationStore.isReceiveOpenLotteryNotificationDetermined {
      registerRemoteNotification(application: application)
      notificationStore.set(receiveOpenLotteryNotification: true)
    }
    
    let mainModule = MeowNavigationDefaultBuilder().buildMeowNavigationModule()
    //    let mainModule = InvoiceQRCodeScannerDefaultBuilder().buildInvoiceQRCodeModule()
    //    let mainModule = ViewController()
    //    let mainModule = PreviewInvoiceViewController()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .white
    window?.rootViewController = mainModule
    window?.makeKeyAndVisible()
    
    return true
  }
  
  private func registerRemoteNotification(application: UIApplication) {
    if #available(iOS 10.0, *) {
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    let token = Messaging.messaging().fcmToken
    print("FCM token: \(token ?? "")")
  }
  
  func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
    let root = window?.rootViewController as? MeowNavigationController
    root?.updateNavigationController(with: newStatusBarFrame)
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

extension AppDelegate : UNUserNotificationCenterDelegate {
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    Messaging.messaging().appDidReceiveMessage(userInfo)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    Messaging.messaging().appDidReceiveMessage(userInfo)
  }
  
}
