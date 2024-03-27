//
//  BarChartHelper.swift
//  HealthAppGOQii
//
//  Created by Apple on 27/03/24.
//

import UIKit
import DGCharts

class BarChartHelper {
    
    static func setupBarChart(barChartView: BarChartView, dataPoints: [String], values: [Double], chartTitle: String) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: chartTitle)
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        // Customize chart appearance
        chartDataSet.colors = ChartColorTemplates.pastel()
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false // Remove right axis
        barChartView.legend.enabled = true // Remove legend
        barChartView.xAxis.drawGridLinesEnabled = false // Remove vertical grid lines
               barChartView.leftAxis.drawGridLinesEnabled = false // Remove horizontal grid lines
               barChartView.rightAxis.enabled = false // Remove right axis
        
//        barChartView.layer.cornerRadius = 15
//                barChartView.clipsToBounds = true
        // Add marker
//        let marker = XYMarkerView()
//        marker.chartView = barChartView
////        marker.minimumSize = CGSize(width: 80, height: 40)
//        barChartView.marker = marker
        
        // Animation
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        barChartView.doubleTapToZoomEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.drawValueAboveBarEnabled = true
    }
}

// Custom marker implementation
class XYMarkerView: MarkerView {
    private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        label.text = "Y: \(entry.y)"
        label.sizeToFit()
        self.frame.size = CGSize(width: label.frame.width + 16, height: label.frame.height + 16)
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        var point = point
        if #available(iOS 11.0, *) {
            if point.x - self.frame.width / 2.0 < 0 {
                point.x = self.frame.width / 2.0
            } else if point.x + self.frame.width / 2.0 > self.bounds.width {
                point.x = self.bounds.width - self.frame.width / 2.0
            }
            if point.y - self.frame.height < 0 {
                point.y += self.frame.height
            }
        }
        self.bounds.origin = CGPoint(x: point.x - self.frame.width / 2.0, y: point.y - self.frame.height - 4)
        self.layer.cornerRadius = self.frame.height / 2.0
        super.draw(context: context, point: point)
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(roundedRect: rect, cornerRadius: rect.height / 2)
        UIColor.black.withAlphaComponent(0.7).setFill()
        bezierPath.fill()
        label.center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        label.draw(rect)
    }
}
