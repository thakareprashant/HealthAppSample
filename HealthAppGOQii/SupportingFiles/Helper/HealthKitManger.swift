//
//  HealthKitManager.swift
//  HealthAppGOQii
//
//  Created by Apple on 27/03/24.
//
import Foundation
import HealthKit

class HealthKitManager {
    
    // MARK: - Properties
    
    let healthStore: HKHealthStore
    
    // MARK: - Initialization
    
    init() {
        healthStore = HKHealthStore()
    }
    
    // MARK: - Authorization
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let typesToRead: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .stepCount)!,
                                               HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            completion(success, error)
        }
    }
    
    // MARK: - Steps
    
    func getStepCount(forStartDate startDate: Date, endDate: Date, completion: @escaping (Double?, Error?) -> Void) {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(nil, error)
                return
            }
            let stepCount = sum.doubleValue(for: HKUnit.count())
            completion(stepCount, nil)
        }
        healthStore.execute(query)
    }
    
    // MARK: - Sleep
    
    func getSleepAnalysis(forStartDate startDate: Date, endDate: Date, completion: @escaping (Double?, Error?) -> Void) {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            guard let samples = samples as? [HKCategorySample], error == nil else {
                completion(nil, error)
                return
            }
            
            let totalSleepTime = samples.reduce(0.0) { result, sample in
                let timeInterval = sample.endDate.timeIntervalSince(sample.startDate)
                return result + timeInterval
            }
            let hours = totalSleepTime / 3600 // Convert seconds to hours
            completion(hours, nil)
        }
        healthStore.execute(query)
    }
    func getTodaySleepAnalysis(completion: @escaping (Double?, Error?) -> Void) {
            let calendar = Calendar.current
            let now = Date()
            let startOfDay = calendar.startOfDay(for: now)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
                guard let samples = samples as? [HKCategorySample], error == nil else {
                    completion(nil, error)
                    return
                }
                
                let totalSleepTime = samples.reduce(0.0) { result, sample in
                    let timeInterval = sample.endDate.timeIntervalSince(sample.startDate)
                    return result + timeInterval
                }
                let hours = totalSleepTime / 3600 // Convert seconds to hours
                completion(hours, nil)
            }
            healthStore.execute(query)
        }
    func getTodayStepCount(completion: @escaping (Double?, Error?) -> Void) {
            let calendar = Calendar.current
            let now = Date()
            let startOfDay = calendar.startOfDay(for: now)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
            let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
                guard let result = result, let sum = result.sumQuantity() else {
                    completion(nil, error)
                    return
                }
                let stepCount = sum.doubleValue(for: HKUnit.count())
                completion(stepCount, nil)
            }
            healthStore.execute(query)
        }
}
