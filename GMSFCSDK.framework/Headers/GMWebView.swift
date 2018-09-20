//
//  GMWebView.swift
//  GMSFCSDK
//
//  Created by 汪高明 on 2018/6/5.
//  Copyright © 2018年 汪高明. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore
import CoreLocation

open class GMWebView: UIView,UIScrollViewDelegate,CLLocationManagerDelegate {
    
    let locationmanager = CLLocationManager()
    
    var sp: String?

    var webV: WKWebView?
    
    public init(frame: CGRect,serverPath: String) {
        super.init(frame: frame)
        self.webV = WKWebView(frame: frame)
        self.sp = serverPath
        if CLLocationManager.locationServicesEnabled(){
            print("++")
            self.locationmanager.delegate = self
            locationmanager.requestWhenInUseAuthorization()
            locationmanager.desiredAccuracy = kCLLocationAccuracyBest
            locationmanager.distanceFilter = 5
            locationmanager.startUpdatingLocation()
        }else{
            print("--")
        }

        self.webV?.scrollView.delegate = self
        self.addSubview(self.webV!)
 

    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func goBack() {
        self.webV?.goBack()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
    }

    
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationmanager.stopUpdatingLocation()
        let currentLocation = locations.last?.locationMarsFromEarth()
        
        let lat: String = String(format: "%f", (currentLocation?.coordinate.latitude)!)
        let lng: String = String(format: "%f", (currentLocation?.coordinate.longitude)!)
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let url = HostURL + "?sdkId=" + currentVersion + "&feimaAppId=" + AppId + "&serverPath=" + self.sp! + "&lat=" + lat  + "&lng=" + lng
        print(url)
        self.webV?.load(URLRequest(url: URL(string: url)!))
    }

}
