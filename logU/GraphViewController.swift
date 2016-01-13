//
//  GraphViewController.swift
//  seguepractice
//
//  Created by Brett on 1/7/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {

    @IBOutlet weak var poundageChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (week, poundage) = ViewController().dataOfWeeklyPoundage("https://loguapp.com/swift.php")!
        
        Date = week
        setLineChart(week, values: poundage )
        
    }
    
    var Date: [String]!
    
    func setLineChart(dataPoints: [String], values: [Double]) {
        
        //barChartView.highlightPerTapEnabled = false
        poundageChartView.highlightPerDragEnabled = false
        
        poundageChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Weekly Poundage")
        chartDataSet.drawCubicEnabled = true
        chartDataSet.drawFilledEnabled = true
        chartDataSet.drawCirclesEnabled = false
        
        let chartData = LineChartData(xVals: Date, dataSet: chartDataSet)
        poundageChartView.data =  chartData
    }
}
