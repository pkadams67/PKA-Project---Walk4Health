//
//  PKA_TimerViewController.swift
//  Walk4Health
//
//  Created by Paul Kirk Adams on 3/22/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit
import LaunchKit

class PKA_TimerViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!

    var zeroTime = NSTimeInterval()
    var timer: NSTimer = NSTimer()

    let locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var distanceTraveled = 0.0

    let healthManager: PKA_HealthKitManager = PKA_HealthKitManager()
    var height: HKQuantitySample?

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        LaunchKit.sharedInstance().presentAppReleaseNotesIfNeededFromViewController(self) { (didPresent: Bool) -> Void in
            if didPresent {
                print("Presented Release Notes.")
            }
        }
        // Uncomment for debugging
//        LaunchKit.sharedInstance().debugAlwaysPresentAppReleaseNotes = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("Please enable location.")
        }
        getHealthKitPermission()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getHealthKitPermission() {
        healthManager.authorizeHealthKit { (authorized, error) -> Void in
            if authorized {
                self.setHeight()
            } else {
                if error != nil {
                    print(error)
                }
                print("Permission denied.")
            }
        }
    }

    @IBAction func startTimer(sender: AnyObject) {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(PKA_TimerViewController.updateTime), userInfo: nil, repeats: true)
        zeroTime = NSDate.timeIntervalSinceReferenceDate()
        distanceTraveled = 0.0
        startLocation = nil
        lastLocation = nil
        locationManager.startUpdatingLocation()
    }

    @IBAction func stopTimer(sender: AnyObject) {
        timer.invalidate()
        locationManager.stopUpdatingLocation()
    }

    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var timePassed: NSTimeInterval = currentTime - zeroTime
        let minutes = UInt8(timePassed / 60.0)
        timePassed -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(timePassed)
        timePassed -= NSTimeInterval(seconds)
        let millisecondsX10 = UInt8(timePassed * 100)
        let stringMinutes = String(format: "%02d", minutes)
        let stringSeconds = String(format: "%02d", seconds)
        let stringMillisecondsX10 = String(format: "%02d", millisecondsX10)
        timerLabel.text = "\(stringMinutes):\(stringSeconds):\(stringMillisecondsX10)"
//        if timerLabel.text == "60:00:00" {
//            timer.invalidate()
//            locationManager.stopUpdatingLocation()
//        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first as CLLocation!
        } else {
            let lastDistance = lastLocation.distanceFromLocation(locations.last as CLLocation!)
            distanceTraveled += lastDistance * 0.000621371
            let trimmedDistance = String(format: "%.2f", distanceTraveled)
            milesLabel.text = "\(trimmedDistance) miles"
        }
        lastLocation = locations.last as CLLocation!
    }

    func setHeight() {
        let heightSample = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        self.healthManager.getHeight(heightSample!, completion: { (userHeight, error) -> Void in
            if (error != nil) {
                print("Error: \(error.localizedDescription)")
                return
            }
            var heightString = ""
            self.height = userHeight as? HKQuantitySample
            if let meters = self.height?.quantity.doubleValueForUnit(HKUnit.meterUnit()) {
                let formatHeight = NSLengthFormatter()
                formatHeight.forPersonHeightUse = true
                heightString = formatHeight.stringFromMeters(meters)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.heightLabel.text = heightString
            })
        })
    }

    @IBAction func share(sender: AnyObject) {
        healthManager.saveDistance(distanceTraveled, date: NSDate())
    }
}