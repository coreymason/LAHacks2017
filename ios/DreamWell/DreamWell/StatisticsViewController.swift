//
//  StatisticsViewController.swift
//  DreamWell
//
//  Created by Rohin Bhushan on 4/1/17.
//  Copyright © 2017 rohin. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {

	@IBOutlet weak var chartView: LineChartView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var transcriptTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = UIColor.clear
		tableView.separatorStyle = .none
		self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
		
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
		
		chartView.leftAxis.drawGridLinesEnabled = false
		chartView.leftAxis.axisLineColor = veryLightGray
		chartView.leftAxis.labelTextColor = UIColor.lightGray
		
		chartView.xAxis.gridColor = veryLightGray
		chartView.xAxis.axisLineColor = veryLightGray
		chartView.xAxis.labelPosition = .bottom
		chartView.xAxis.labelTextColor = UIColor.lightGray
		
		chartView.noDataText = "No data yet"
		
		updateChart(yVals: [2, 6, 5, 8, 7, 3, 4, 9, 4, 2, 2, 15, 6, 8])
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		transcriptTextView.setContentOffset(CGPoint.zero, animated: false)
	}
	
	func updateChart(yVals: [Double]) {
		var entries = [ChartDataEntry]()
		for (index, val) in yVals.enumerated() {
			let entry = ChartDataEntry(x: Double(index), y: val)
			entries.append(entry)
		}
		
		let dataSet = LineChartDataSet(values: entries, label: nil)
		dataSet.colors = [greenColor]
		dataSet.mode = .cubicBezier
		dataSet.drawFilledEnabled = true
		dataSet.drawValuesEnabled = false
		dataSet.drawCirclesEnabled = false
		dataSet.fillColor = greenColor
		dataSet.fillAlpha = 0.4
		
		let dataSets = [dataSet]
		let data = LineChartData(dataSets: dataSets)
		chartView.data = data
		chartView.animate(yAxisDuration: 1.0)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}

}

extension StatisticsViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 25.0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
}
