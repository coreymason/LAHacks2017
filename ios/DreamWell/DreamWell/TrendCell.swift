//
//  TrendCell.swift
//  DreamWell
//
//  Created by Rohin Bhushan on 4/1/17.
//  Copyright © 2017 rohin. All rights reserved.
//

import UIKit
import Charts
let greenColor = UIColor(hex: 0x71F4BC)

let veryLightGray = UIColor(hex: 0xF0F0F0)

enum TrendType : String {
	case airPressure = "Air Pressure"
	case temperature = "Temperature"
	
	
 static let trends = [TrendType.airPressure, .temperature]
	
	
}

class TrendCell: UITableViewCell {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var chartView: LineChartView!
	

    override func awakeFromNib() {
        super.awakeFromNib()
		
		// configure chart
		chartView.isUserInteractionEnabled = false
		let d = Description()
		d.enabled = false
		chartView.chartDescription = d
		chartView.drawGridBackgroundEnabled = true
		chartView.drawBordersEnabled = true
		chartView.legend.enabled = false
		chartView.leftAxis.enabled = true
		chartView.rightAxis.enabled = false
		chartView.xAxis.enabled = true
		chartView.gridBackgroundColor = UIColor.white
		chartView.borderColor = veryLightGray
		
		chartView.leftAxis.gridColor = veryLightGray
		chartView.leftAxis.axisLineColor = veryLightGray
		chartView.leftAxis.labelTextColor = UIColor.lightGray
		
		chartView.xAxis.gridColor = veryLightGray
		chartView.xAxis.axisLineColor = veryLightGray
		chartView.xAxis.labelPosition = .bottom
		chartView.xAxis.labelTextColor = UIColor.lightGray
		
		chartView.noDataText = "No data yet"
    }
	
	func updateChart(yVals: [Double]) {
		var entries = [ChartDataEntry]()
		for (index, val) in yVals.enumerated() {
			let entry = ChartDataEntry(x: Double(index), y: val)
			entries.append(entry)
		}
		
		let dataSet = LineChartDataSet(values: entries, label: nil)
		dataSet.colors = [greenColor]
		dataSet.circleColors = [UIColor.white]
		dataSet.circleHoleRadius = 4.0
		dataSet.circleHoleColor = greenColor
		dataSet.circleRadius = 7.0
		dataSet.drawValuesEnabled = false
		dataSet.drawCirclesEnabled = true
		
		let dataSets = [dataSet]
		let data = LineChartData(dataSets: dataSets)
		chartView.data = data
		chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easing: nil)
	}
    
}
