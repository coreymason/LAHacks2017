//
//  GlobalViewController.swift
//  DreamWell
//
//  Created by Rohin Bhushan on 4/1/17.
//  Copyright © 2017 rohin. All rights reserved.
//

import UIKit
import Charts

class GlobalViewController: UIViewController {

	@IBOutlet weak var matchLabel: UILabel!
	@IBOutlet weak var chartView: PieChartView!
	let emotions = [ "Joy", "Fear", "Disgust", "Sadness", "Surprise", "Love", "Anger"]
    override func viewDidLoad() {
        super.viewDidLoad()

		chartView.usePercentValuesEnabled = true
		chartView.holeRadiusPercent = 0.58
		chartView.transparentCircleRadiusPercent = 0.61
		chartView.holeColor = greenColor
		chartView.descriptionText = ""
		chartView.drawCenterTextEnabled = true
		chartView.drawHoleEnabled = true
		chartView.rotationAngle = 0.0
		chartView.rotationEnabled = true
		chartView.delegate = self
		chartView.legend.enabled = false
		let attributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 15.0)!]
		chartView.centerAttributedText = NSAttributedString(string: "Global Emotions", attributes: attributes)
		//let legendEntry = LegendEntry(label: "Happy", form: .default, formSize: 12.0, formLineWidth: 2.0, formLineDashPhase: 0.0, formLineDashLengths: nil, formColor: UIColor.red)
		//chartView.legend.entries = [legendEntry]
		
		var entries = [PieChartDataEntry]()
		entries.append(PieChartDataEntry(value: 14.0, label: emotions[0]))
		entries.append(PieChartDataEntry(value: 16.0, label: emotions[1]))
		entries.append(PieChartDataEntry(value: 10.0, label: emotions[2]))
		entries.append(PieChartDataEntry(value: 14.0, label: emotions[3]))
		entries.append(PieChartDataEntry(value: 13.0, label: emotions[4]))
		entries.append(PieChartDataEntry(value: 16.0, label: emotions[5]))
		entries.append(PieChartDataEntry(value: 17.0, label: emotions[6]))
		let dataSet = PieChartDataSet(values: entries, label: nil)
		dataSet.colors = [UIColor(hex: 0x3498db),
		                  UIColor(hex: 0xc0392b),
		                  UIColor(hex: 0x16a085),
		                  UIColor(hex: 0x7f8c8d),
		                  UIColor(hex: 0xf1c40f),
		                  UIColor(hex: 0x9b59b6),
		                  UIColor(hex: 0x2c3e50)]
		let data = PieChartData(dataSets: [dataSet])
		let formatter = DefaultValueFormatter { (val, entry, index, handle) -> String in
			return "\(Int(val))%"
		}
		data.setValueFormatter(formatter)
		
		chartView.data = data
		chartView.animate(yAxisDuration: 2.0)
    }
}

extension GlobalViewController : ChartViewDelegate {
	func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
		matchLabel.text = "You match 64% with the world's \(emotions[Int(highlight.x)])"
	}
}
