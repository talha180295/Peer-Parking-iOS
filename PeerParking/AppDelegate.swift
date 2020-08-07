//
//  AppDelegate.swift
//  PeerParking
//
//  Created by Munzareen Atique on 28/08/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import SideMenuController
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import CoreLocation
import Stripe
import FirebaseAnalytics
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate ,MessagingDelegate {
    
    
    
    let gcmMessageIDKey = "gcm.message_id"
    var window: UIWindow?
    var locationManager:CLLocationManager!
    var currentLocation:CLLocation?
    var currentLocationAddress:String?
    var camera:GMSCameraPosition!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupLocationManager()
        
        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = false
        setSideMenu()
        
        GMSServices.provideAPIKey(Key.Google.placesKey)
        
        GMSPlacesClient.provideAPIKey(Key.Google.placesKey)
        
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        //Just add this line to get it done.
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)], for: UIControl.State.normal)
        
        
        //Stripe
        //         Stripe.setDefaultPublishableKey("pk_test_RXoa7kPDBX5WbbFUwobIagRn00bNqh0qyQ")
        STPPaymentConfiguration.shared().publishableKey = "pk_test_RXoa7kPDBX5WbbFUwobIagRn00bNqh0qyQ"
        
        //Added push notification
        
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
        
        Messaging.messaging().isAutoInitEnabled = true
        
        
        
        // Override point for customization after application launch.
        return true
    }
    
    func setSideMenu()
    {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "icon_menu")
        SideMenuController.preferences.drawing.sidePanelPosition = .underCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 300
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .horizontalPan
        SideMenuController.preferences.animating.transitionAnimator = FadeAnimator.self
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
    
    
    
    //Push Notifications
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                //  self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            }
        }
        //        if let messageID = userInfo {
        //            print("Message ID: \(messageID)")
        //        }
        //
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    //Foreground Recive notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //        let userInfo = notification.request.content.userInfo
        //
        //        // With swizzling disabled you must let Messaging know about the message, for Analytics
        //        // Messaging.messaging().appDidReceiveMessage(userInfo)
        //        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        //
        //
        //
        //        let jsonStringifiedString = userInfo["extra_payload"] as! String
        //        let jsonStringifiedData = jsonStringifiedString.data(using: .utf8) as! Data
        //        let jsonDict = try! JSONSerialization.jsonObject(with: jsonStringifiedData, options: []) as! [String: Any]
        //        print(jsonDict["action_type"] as! String)
        //        //        print(jsonDict["action_type"])
        //        print(userInfo)
        
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        let jsonStringifiedString = userInfo["extra_payload"] as! String
        let jsonStringifiedData = jsonStringifiedString.data(using: .utf8)!
        let jsonDict = try! JSONSerialization.jsonObject(with: jsonStringifiedData, options: []) as! [String: Any]
        print(jsonDict["action_type"] as! String)
        let actionType = jsonDict["action_type"] as! String

        var refId:String!
        
        if let refIdval = jsonDict["ref_id"] as? String{
            refId = refIdval
        }
        else if let refIdval = jsonDict["ref_id"] as? Int{
            refId = String(refIdval)
        }
        
//        if(actionType == APP_CONSTANT.BUYER_REACHED){
//            getParkingOpenDetailScreen(parkingId: String(refId),openDetailScreen: false)
//        }
        
        showNotificationsOnForeground(actionType: actionType, refId: refId)
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .sound])
    }
    
    // Tap Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        let jsonStringifiedString = userInfo["extra_payload"] as! String
        let jsonStringifiedData = jsonStringifiedString.data(using: .utf8)!
        let jsonDict = try! JSONSerialization.jsonObject(with: jsonStringifiedData, options: []) as! [String: Any]
        print(jsonDict["action_type"] as! String)
        let actionType = jsonDict["action_type"] as! String
        
        var refId:String!
        
        if let refIdval = jsonDict["ref_id"] as? String{
            refId = refIdval
        }
        else if let refIdval = jsonDict["ref_id"] as? Int{
            refId = String(refIdval)
        }
        
        
 
//        if(actionType == APP_CONSTANT.BUYER_REACHED){
//            getParkingOpenDetailScreen(parkingId: String(refId),openDetailScreen: false)
//        }
        
        self.onNotificationPressed(actionType: actionType, refId: refId)
        
        
        //        let alert = userInfo["aps"] as! NSDictionary
        //        let alertbody = alert["alert"] as! NSDictionary
        //        let alert1 = alertbody["body"] as! String
        
        
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
    
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        
        
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
        UserDefaults.standard.synchronize()
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
//    func messaging(_ messaging: Messaging, did remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
//    }
//    // [END refresh_token]
//    // [START ios_10_data_message]
//    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
//    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
//    }
//
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data
        
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        
        
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
        UserDefaults.standard.synchronize()
    }
    //
    //    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    //        locationManager.startMonitoringSignificantLocationChanges()
    //    }
    
    func resetApp() {
        Messaging.messaging().delegate = self
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let newRoot = storyboard.instantiateInitialViewController() else {
            return // This shouldn't happen
        }
        self.window?.rootViewController = newRoot
    }
    
}

extension AppDelegate:CLLocationManagerDelegate{
    
    
    func setupLocationManager(){
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
        
    }
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation == nil {
            currentLocation = locations.last
            locationManager?.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            
            print("locations = \(locationValue)")
            
            //location.
            
            self.camera = GMSCameraPosition.camera(withLatitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!, zoom: 14.0)
            //
            //            let geoCoder = CLGeocoder()
            //
            //            geoCoder.reverseGeocodeLocation(currentLocation!, completionHandler:
            //                {
            //                    placemarks, error in
            //
            //                    guard let placemark = placemarks?.first else {
            //                        let errorString = error?.localizedDescription ?? "Unexpected Error"
            //                        print("Unable to reverse geocode the given location. Error: \(errorString)")
            //                        return
            //                    }
            //
            //                    let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            //                    print("LOC=:\(reversedGeoLocation.formattedAddress)")
            //                    self.currentLocationAddress = reversedGeoLocation.formattedAddressName
            //                    // Apple Inc.,
            //                    // 1 Infinite Loop,
            //                    // Cupertino, CA 95014
            //                    // United States
            //            })
            
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(camera.target) { (response, error) in
                guard error == nil else {
                    return
                }
                
                if let result = response?.firstResult() {
                    
                    let address = result.lines?.first ?? ""
                    print("result=\(address)")
                    self.currentLocationAddress = address
                    
                }
            }
            locationManager?.stopUpdatingLocation()
        }
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    
    
}

extension AppDelegate{
    
    func showNotificationsOnForeground(actionType:String, refId:String){
        
        if(actionType == (APP_CONSTANT.BARGAINING_ACCEPTED_BY_SELLER) ||
            actionType == (APP_CONSTANT.PARKING_BOOKED) ||
            actionType == (APP_CONSTANT.BUYER_IS_NAVIGATING) ||
            actionType == (APP_CONSTANT.BUYER_REACHED)){
            
            getParkingOpenDetailScreen(parkingId: refId ,openDetailScreen: false)
        }else if(actionType == (APP_CONSTANT.PARKING_CANCELED_BY_BUYER)){
            getParkingOpenDetailScreen(parkingId: refId,openDetailScreen: true)
        }else if(actionType == (APP_CONSTANT.PARKING_CANCELED_BY_SELLER) ){// && (baseFragment instanceof FragmentNavigateUpdated || baseFragment instanceof BookingDetailFragment)){
            
            //            popStackTill(1);
            //            Helper().presentOnMainScreens(controller: self.window?.rootViewController ?? UIViewController(), index: 1)
        }
    }
    
    
    func onNotificationPressed(actionType:String, refId:String) {
        
        
        if(actionType == (APP_CONSTANT.BARGAINING_COUNTER_OFFER_BY_BUYER) ||
            actionType == (APP_CONSTANT.BARGAINING_ACCEPTED_BY_BUYER) ||
            actionType == (APP_CONSTANT.BARGAINING_COUNTER_OFFER_BY_SELLER) ||
            actionType == (APP_CONSTANT.BARGAINING_REJECTED_BY_SELLER) ||
            actionType == (APP_CONSTANT.BARGAINING_MESSAGE_FROM_BUYER) ||
            actionType == (APP_CONSTANT.BARGAINING_MESSAGE_FROM_SELLER) ||
            actionType == (APP_CONSTANT.ACTION_PARKING_REQUEST)){
            
            getParkingOpenChatActivity(chatRoomId:refId)
            
        }else if(actionType == (APP_CONSTANT.BARGAINING_ACCEPTED_BY_SELLER) ||
            actionType == (APP_CONSTANT.PARKING_BOOKED) ||
            actionType == (APP_CONSTANT.BUYER_IS_NAVIGATING) ||
            actionType == (APP_CONSTANT.BUYER_REACHED) ||
            actionType == (APP_CONSTANT.BUYER_TO_REACH_IN_ONE_MINUTE) ){
            
            getParkingOpenDetailScreen(parkingId: refId,openDetailScreen: false)
            
        }else if(actionType == (APP_CONSTANT.PARKING_CANCELED_BY_BUYER)){
            
            getParkingOpenDetailScreen(parkingId: refId ,openDetailScreen: true)
            
        }
        
    }
    
    func getParkingOpenDetailScreen( parkingId:String, openDetailScreen:Bool) {
        if(parkingId.isEmpty){
            return;
        }
        let request = APIRouter.getParkingsById(id: Int(parkingId) ?? -1)
        //        Helper().showSpinner(view: self.view)
        APIClient.serverRequest(url: request, path: request.getPath(), dec:
        ResponseData<Parking>.self) { (response,error) in
            
            if(response != nil){
                if (response?.success) != nil {
                    //Helper().showToast(message: "Succes=\(success)", controller: self)
                    if let val = response?.data {
                        
                       
                        //                       ParkingModel1 model1 = GsonFactory.getSimpleGson()
                        //                        .fromJson(GsonFactory.getSimpleGson().toJson(webResponse.result)
                        //                        , ParkingModel1.class);
                        
                        if(openDetailScreen){
                            let vc = MySpotParkingDetailVC.instantiate(fromPeerParkingStoryboard: .ParkingDetails)
                            
                            if val.parkingType == ParkingType.PARKING_TYPE_PRIVATE{
                                vc.isPublicParking = false
                               vc.setParingModel(parkingModel: val)
                            }
                            else{
                                vc.isPublicParking = true
                                vc.setParingModel(parkingModel: val)
                            }
                            
                            //                            vc.delegate = self
                            vc.modalPresentationStyle = .fullScreen
                            self.window?.rootViewController?.present(vc, animated: true,completion: nil)
                            //                        addDockableFragment(PublicParkingDetailFragment.newInstance(model1), false);
                        }else{
                            
                            let vc = ParkingBookingDetailsVC.instantiate(fromPeerParkingStoryboard: .ParkingDetails)
                            vc.parkingModel = val
//                            vc.setParingModel(parkingModel: val)
                            vc.modalPresentationStyle = .fullScreen
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            guard let newRoot = storyboard.instantiateInitialViewController() else {
                                return // This shouldn't happen
                            }
                            UIApplication.shared.delegate?.window??.rootViewController = newRoot
                            UIApplication.shared.delegate?.window??.rootViewController?.present(vc, animated: true,completion: nil)
//                            self.window?.rootViewController?.present(vc, animated: true,completion: nil)
                            
                        }
                    }
                    
                }
            }
            else{
                //                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                //
                //                    Helper().hideSpinner(view: self.view)
                
            }
        }
    }
    
    func getParkingOpenChatActivity(chatRoomId:String) {
        if(chatRoomId.isEmpty){
            return;
        }
        
        let ids = chatRoomId.components(separatedBy: "-")
        let parkingId = ids[0];
        let buyerId = Int(ids[1])

//        popStackTill(1);
        

        let request = APIRouter.getParkingsById(id: Int(parkingId) ?? -1)
        APIClient.serverRequest(url:request,path:request.getPath(), dec: ResponseData<Parking>.self) { (response, error) in
            
//            Helper().hideSpinner(view: self.view)
            if(response != nil){
                if (response?.success) != nil {
//                    Helper().showToast(message: response?.message ?? "-", controller: self)
                    if let val = response?.data {
                        var model = Parking.init(dictionary: val.dictionary ?? [:])
                        if(model?.buyerID == 0)||(model?.buyerID == nil){
                            model?.buyerID = buyerId
                        }
//                        let vc = ChatVC.instantiate(fromPeerParkingStoryboard: .Chat)
//
//                        vc.modalPresentationStyle = .fullScreen
//
//                        vc.parking_details = model
//
//                        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
//
                        
                        let vc = ChatVC.instantiate(fromPeerParkingStoryboard: .Chat)
                        vc.parking_details = model
                        vc.modalPresentationStyle = .fullScreen
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        guard let newRoot = storyboard.instantiateInitialViewController() else {
                            return // This shouldn't happen
                        }
                        UIApplication.shared.delegate?.window??.rootViewController = newRoot
                        UIApplication.shared.delegate?.window??.rootViewController?.present(vc, animated: true,completion: nil)
//                        Intent i = new Intent(HomeActivity.this, ChatActivity.class);
//                        String parkingJson= gson.toJson(model);
//                        i.putExtra("parkingModel", parkingJson);
//                        startActivity(i);
                    }
                }
                else{
//                    Helper().showToast(message: "Server Message=\(response?.message ?? "-" )", controller: self)
                }
            }
            else if(error != nil){
//                Helper().showToast(message: "Error=\(error?.localizedDescription ?? "" )", controller: self)
            }
            else{
//                Helper().showToast(message: "Nor Response and Error!!", controller: self)
            }
        }
    }
    
    
}
