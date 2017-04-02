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
		chartView.holeColor = UIColor.white
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
		for i in 0..<emotions.count {
			entries.append(PieChartDataEntry(value: 14.0, label: emotions[i]))
		}
		let dataSet = PieChartDataSet(values: entries, label: nil)
		dataSet.colors = [greenColor,
		                  greenColor.withAlphaComponent(0.8),
		                  greenColor.withAlphaComponent(0.60),
		                  greenColor.withAlphaComponent(0.40),
		                  UIColor.black.withAlphaComponent(0.1),
		                  UIColor.black.withAlphaComponent(0.2),
		                  UIColor.black.withAlphaComponent(0.25)]
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
