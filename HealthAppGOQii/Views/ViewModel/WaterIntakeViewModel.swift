//
//  WaterIntakeViewModel.swift
//  HealthAppGOQii
//
//  Created by Apple on 26/03/24.
//

import Foundation
import Foundation
import CoreData
import Lottie

class WaterIntakeViewModel {
    var quantity:Int16 = 0
    private var waterModel: [Water] = []
    var waterEntries = Observable<[Water]>([])
    var valObserver:(()->())?
    var dataPoints: [String] {
        return ["12-4am", "4-8am", "8-12pm", "12-4pm", "4-8pm", "8-12am"]
    }
    var values:[Double] = [0,0,0,0,0,0]
    func isDateToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let otherDate = calendar.startOfDay(for: date)
        return today == otherDate
    }
    func fetchWaterEntries() {
        
        values = [0,0,0,0,0,0]
//        CoreDataHelper.deleteAllData(forEntityName: "Water")
        waterModel = CoreDataHelper.fetchEntities(entityName: "Water")
        waterEntries.value = waterModel
        
        filterdata()
    }
    
    
    
    func deleteData(model:NSManagedObject){
        
        CoreDataHelper.delete(entity: model)
        fetchWaterEntries()
       
    }
    func updateDatamodel(value:Int16,model:NSManagedObject){
        
        model.setValue(value, forKey: "litre")
        CoreDataHelper.saveContext()
        fetchWaterEntries()
       
    }
    func updateWaterQuantity(isIncrement: Bool) -> Int16{
        
        if isIncrement {
            quantity = min(quantity + 1, 10)
        } else {
            quantity = max(quantity - 1, 0)
        }
//        waterEntries.value.first?.litre = quantity
        return quantity
    }
    
    
    func saveWaterEntry(quantity: Int) {
        let water = Water(context: CoreDataHelper.managedContext)
        water.litre = Int16(quantity)
        water.time = getCurrentDateAndTimeInIndianTimeZone()
        water.timestr = getCurrentDateAndTimeAsStringInIndianTimeZone()
        CoreDataHelper.saveContext()
fetchWaterEntries()
        print("New water entry saved successfully")
    }
    func getCurrentDateAndTimeAsStringInIndianTimeZone() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    func getCurrentDateString(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy" // Specify the desired date format
        return dateFormatter.string(from:date)
    }

    func getCurrentDateAndTimeInIndianTimeZone() -> Date {
        let timeZone = TimeZone(identifier: "Asia/Kolkata")!
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: timeZone, from: currentDate)
        let currentDateInTimeZone = calendar.date(from: components)!
        return currentDateInTimeZone
    }
    func filterdata(){
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
       var totalGlass = 0
        for item in waterModel{
            
            if isDateToday(item.time ?? Date()){
                totalGlass += Int(item.litre)
                if let val = Double(getTimeString24Hour(from: item.time ?? Date()).prefix(2)){
                    filterDataForCharts(val: val, litre: Double(item.litre))
                    
                    valObserver?()
                }
               
            }
          
//            waterEntries.value = waterModel
            
            //
        }
        UserDefaults.standard.set(totalGlass, forKey: "TotalGlasses")
    }
    func getTimeString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        
        return dateFormatter.string(from: date)
    }
    func getTimeString24Hour(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
       
        return dateFormatter.string(from: date)
    }
    func filterDataForCharts(val:Double,litre:Double){
        switch val{
            
            
        case 0..<4:
            values[0] += Double(litre)
            break
        case 4..<8:
            values[1] += Double(litre)
            break
        case 8..<12:
            values[2] += Double(litre)
            break
        case 12..<16:
            values[3] += Double(litre)
            break
        case 16..<20:
            values[4] += Double(litre)
            break
        case 20..<24:
            values[5] += Double(litre)
            break
            
        default:
            break
            
        }
    }
   
}

struct Event {
    let date: Date
    let description: String
}
class Observable<T> {
    var value: T {
        didSet {
            observer?(value)
        }
    }
    
    private var observer: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(observer: @escaping (T) -> Void) {
        self.observer = observer
        observer(value)
    }
}
