//
//  GraphViewController.swift
//  seguepractice
//
//  Created by Brett on 1/7/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import UIKit
import Charts

var dataWeek: Array<Dictionary<String, String>> = []

class GraphViewController: UIViewController {
    
    var graphWeek : [String]! = []
    var graphPoundage : [Double]! = []

    @IBOutlet weak var poundageChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GraphData().dataOfWeeklyPoundage({ jsonString in
            dataWeek = jsonString
            print(dataWeek)
            dispatch_async(dispatch_get_main_queue(), {
                self.somethingAfter(dataWeek)
            })
            
        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        GraphData().dataOfWeeklyPoundage({ jsonString in
            dataWeek = jsonString
            dispatch_async(dispatch_get_main_queue(), {
                self.somethingAfter(dataWeek)
            })
            
        })

    }
    
    func somethingAfter(object: Array<Dictionary<String, String>>) {
        dataWeek = object
        
        graphWeek = []
        graphPoundage = []
        
        for i in 0..<object.count {
            graphWeek.append(dataWeek[i]["week"]!)
            graphPoundage.append(Double(dataWeek[i]["pounds"]!)!)
        }
        
        print(graphPoundage)
        print(graphWeek)
        
        for i in 0..<object.count {
            print(graphWeek[i])
            print(graphPoundage[i])
        }
        Date = graphWeek
        setLineChart(graphWeek, values: graphPoundage )

    }
    
    var Date: [String]!
    
    func setLineChart(dataPoints: [String], values: [Double]) {
        
        //barChartView.highlightPerTapEnabled = false
        poundageChartView.highlightPerDragEnabled = false
        
        poundageChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<graphWeek.count {
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
