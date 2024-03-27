//
//  WaterIntakeViewController.swift
//  HealthAppGOQii
//
//  Created by Apple on 26/03/24.
//
import UIKit
import DGCharts
import Lottie
import CoreData

enum WateraOptions{
    
    case bottle
    case glass
}
class WaterIntakeViewController: UIViewController {
    
    var enumWaterOption:WateraOptions = .glass
    @IBOutlet weak var bottleBtn: UIButton!
    @IBOutlet weak var glassBtn: UIButton!
    @IBOutlet weak var lblGraphType: UILabel!
    @IBOutlet weak var waterAnimation: LottieAnimationView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var waterTotalQuantityinMLLabel: UILabel!
    @IBOutlet weak var gradientView1: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var totalGlassesOfWaterLabel: UILabel!
    @IBOutlet weak var glassQuantityLabel: UILabel!
    @IBOutlet weak var todaysWaterQuantityLabel: UILabel!
    @IBOutlet weak var imageWaterIntake: UIImageView!
  
    var viewModel = WaterIntakeViewModel()
      
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            setupViewModel()
            setupLottieAnimation()
            fetchData()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setupBarChart()
        }
        
        override func viewWillLayoutSubviews() {
            setGradientView()
        }
        
        // MARK: - UI Setup
        private func setupUI() {
            bottleBtn.backgroundColor = .gray
            gradientView.clipsToBounds = true
            gradientView.layer.cornerRadius = 15
            gradientView1.clipsToBounds = true
            gradientView1.layer.cornerRadius = 15
        }
        
        // MARK: - ViewModel Setup
        private func setupViewModel() {
            viewModel.valObserver = { [weak self] in
                self?.setupBarChart()
            }
        }
        
        // MARK: - Data Fetching
        private func fetchData() {
            viewModel.fetchWaterEntries()
        }
        
        // MARK: - Lottie Animation
        private func setupLottieAnimation() {
            LottieHelper.playLottieAnimation(named: "water", withExtension: "json", view: waterAnimation)
        }
        
        // MARK: - Bar Chart Setup
        private func setupBarChart() {
            BarChartHelper.setupBarChart(barChartView: barChartView, dataPoints: viewModel.dataPoints, values: viewModel.values, chartTitle: "Glasses")
        }
        
        // MARK: - Gradient View Setup
        private func setGradientView() {
            mainView.applyGradientColorstoView(colourTop: UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0).cgColor, colourBottom: UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0).cgColor)
        }
        
        // MARK: - IBActions
    
    @IBAction func didTapHistoryBtn(_ sender: Any) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WaterTrackerViewController") as! WaterTrackerViewController
            vc.viewModel = self.viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        @IBAction func didTapBottleOption(_ sender: UIButton) {
            enumWaterOption = .bottle
            LottieHelper.playLottieAnimation(named: "bottle", withExtension: "json", view: waterAnimation)
            updateButtonBackgroundColors()
        }
        
        @IBAction func didTapGlassOption(_ sender: UIButton) {
            enumWaterOption = .glass
            LottieHelper.playLottieAnimation(named: "water", withExtension: "json", view: waterAnimation)
            updateButtonBackgroundColors()
        }
        
        @IBAction func quantityWaterChanged(_ sender: UIButton) {
            todaysWaterQuantityLabel.text = String(viewModel.updateWaterQuantity(isIncrement: sender.tag == 1))
        }
        
        @IBAction func backButtonTapped(_ sender: Any) {
            navigationController?.popViewController(animated: true)
        }
        
        @IBAction func submitButtonTapped(_ sender: Any) {
            guard let quantity = Int(todaysWaterQuantityLabel.text ?? ""), quantity > 0 else {
                self.view.makeToast("Please add some glasses")
                return
            }
            let glass = (enumWaterOption == .bottle) ? quantity * 4 : quantity
            viewModel.saveWaterEntry(quantity: glass)
        }
        
        // MARK: - Private Methods
        private func updateButtonBackgroundColors() {
            bottleBtn.backgroundColor = (enumWaterOption == .bottle) ? UIColor(red: 171/255, green: 124/255, blue: 159/255, alpha: 1) : .gray
            glassBtn.backgroundColor = (enumWaterOption == .glass) ? UIColor(red: 171/255, green: 124/255, blue: 159/255, alpha: 1) : .gray
        }
    }
