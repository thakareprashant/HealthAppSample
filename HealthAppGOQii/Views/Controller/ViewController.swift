//
//  ViewController.swift
//  HealthAppGOQii
//
//  Created by Apple on 26/03/24.
//
import UIKit
import Lottie

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var glassesLbl: UILabel!
    @IBOutlet weak var stepsLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var stepsProgress: CircularProgressView!
    @IBOutlet weak var waterAnimation: LottieAnimationView!
    @IBOutlet weak var progressWater: CircularProgressView!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    // MARK: - Properties
    private let healthKitManager = HealthKitManager()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupLottieAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWaterGlassesLabel()
        fetchTodaysStepsAndSleep()
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        stepsProgress.backgroundColor = .clear
        progressWater.backgroundColor = .clear
    }
    
    private func setupLottieAnimations() {
        LottieHelper.playLottieAnimation(named: "AnimationHealth", withExtension: "json", view: animationView)
        LottieHelper.playLottieAnimation(named: "water2", withExtension: "json", view: waterAnimation)
       
    }
    
    // MARK: - Data Fetching
    private func fetchTodaysStepsAndSleep() {
        healthKitManager.requestAuthorization { success, error in
            if success {
                self.fetchTodaySleepAnalysis()
                self.fetchTodayStepCount()
            } else if let error = error {
                print("Authorization failed:", error)
            }
        }
    }
    
    private func fetchTodayStepCount() {
        healthKitManager.getTodayStepCount { stepCount, error in
            if let stepCount = stepCount {
                DispatchQueue.main.async {
                    self.stepsLbl.text = "\(Int(stepCount))"
                    self.stepsProgress.setProgress(Float(stepCount) / 10000, animated: true, color: .cyan)
                }
                print("Today's step count: \(stepCount)")
            } else if let error = error {
                print("Error fetching step count:", error)
            }
        }
    }
    
    private func fetchTodaySleepAnalysis() {
        healthKitManager.getTodaySleepAnalysis { sleepHours, error in
            if let sleepHours = sleepHours {
                DispatchQueue.main.async {
                    self.hoursLbl.text = "\(sleepHours)"
                    self.progressWater.setProgress(Float(sleepHours) / 8.0, animated: true, color: .systemPink)
                }
                print("Today's sleep duration: \(sleepHours) hours")
            } else if let error = error {
                print("Error fetching sleep analysis:", error)
            }
        }
    }
    
    private func updateWaterGlassesLabel() {
        let waterGlasses = UserDefaults.standard.value(forKey: "TotalGlasses") as? Int ?? 0
        self.glassesLbl.text = "\(waterGlasses)"
    }
    
    // MARK: - IBActions
    @IBAction func didTapWater(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WaterIntakeViewController") as! WaterIntakeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
   
}
