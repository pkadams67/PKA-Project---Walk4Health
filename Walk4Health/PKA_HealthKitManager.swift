//
//  PKA_HealthKitManager.swift
//  Walk4Health
//
//  Created by Paul Kirk Adams on 3/22/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import Foundation
import HealthKit

class PKA_HealthKitManager {

    let healthKitStore: HKHealthStore = HKHealthStore()

    func authorizeHealthKit(completion: ((success: Bool, error: NSError!) -> Void)!) {
        let healthDataToRead = Set(arrayLiteral: HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!)
        let healthDataToWrite = Set(arrayLiteral: HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!)
        if !HKHealthStore.isHealthDataAvailable() {
            print("Cannot access HealthKit")
        }
        healthKitStore.requestAuthorizationToShareTypes(healthDataToWrite, readTypes: healthDataToRead) { (success, error) -> Void in
            if( completion != nil ) {
                completion(success:success, error:error)
            }
        }
    }

    func getHeight(sampleType: HKSampleType, completion: ((HKSample!, NSError!) -> Void)!) {
        let distantPastHeight = NSDate.distantPast() as NSDate
        let currentDate = NSDate()
        let lastHeightPredicate = HKQuery.predicateForSamplesWithStartDate(distantPastHeight, endDate: currentDate, options: .None)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let heightQuery = HKSampleQuery(sampleType: sampleType, predicate: lastHeightPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (sampleQuery, results, error ) -> Void in
            if let queryError = error {
                completion(nil, queryError)
                return
            }
            let lastHeight = results!.first
            if completion != nil {
                completion(lastHeight, nil)
            }
        }
        self.healthKitStore.executeQuery(heightQuery)
    }

    func saveDistance(distanceRecorded: Double, date: NSDate ) {
        let distanceType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        let distanceQuantity = HKQuantity(unit: HKUnit.mileUnit(), doubleValue: distanceRecorded)
        let distance = HKQuantitySample(type: distanceType!, quantity: distanceQuantity, startDate: date, endDate: date)
        healthKitStore.saveObject(distance, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print(error)
            } else {
                print("Distance recorded. Please verify!")
            }
        })
    }
}