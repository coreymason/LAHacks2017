//
//  StatisticsViewController.swift
//  DreamWell
//
//  Created by Rohin Bhushan on 4/1/17.
//  Copyright © 2017 rohin. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController, ServicesDelegate {

	@IBOutlet weak var chartView: LineChartView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var transcriptTextView: UITextView!
	
	var positivity : Int?
	var temp : Int?
	var humidity : Int?
	var sleepRating : Int?
	var lightAvg : Int?
	var keywords : [String]?
	
	var axisLabel : UILabel?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		Services.delegate = self
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
		chartView.leftAxis.drawLabelsEnabled = false
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
		
		Services.delegate = self
		Services.getDailyStat()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		Services.delegate = self
	}
	
	func addLeftAxisLabel(text: String) {
		axisLabel?.removeFromSuperview()
		let font = UIFont(name: "Avenir Next", size: 15.0)!
		let labelSize = (text as NSString).size(attributes: [NSFontAttributeName: font])
		axisLabel = UILabel()
		axisLabel?.text = text
		axisLabel?.font = font
		axisLabel?.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
		axisLabel?.frame = CGRect(x: chartView.frame.origin.x - 25, y: 100, width: labelSize.height, height: labelSize.width)
		axisLabel?.center.y = chartView.center.y
		self.view.addSubview(axisLabel!)
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		transcriptTextView.setContentOffset(CGPoint.zero, animated: false)
	}
	
	func dailyStatsReceived(json: [String : Any]) {
		print(json)
		positivity = Int(((json["sentiment"] as? Double) ?? 0.0) * 100)
		transcriptTextView.text = "Transcript: " + (json["dreamContent"] as! String)
		let roomData = json["roomData"] as! [String : Any]
		humidity = roomData["humidAvg"] as? Int
		lightAvg = roomData["lightAvg"] as? Int
		let yVals = roomData["audioValues"] as! NSArray as! [Double]
		temp = roomData["tempAvg"] as? Int
		keywords = json["keywords"] as? NSArray as? [String]
		sleepRating = json["quality"] as? Int
		updateChart(yVals: yVals)
		tableView.reloadData()
	}
	
	func updateChart(yVals: [Double]) {
		var entries = [ChartDataEntry]()
		for (index, val) in yVals.enumerated() {
			let entry = ChartDataEntry(x: Double(index + 2) / 2.0, y: val)
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
		chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (val, base) -> String in
			return "\(Int(val)) am"
		})
		chartView.animate(yAxisDuration: 1.0)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension StatisticsViewController : UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 25.0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
		switch indexPath.row {
		case 0:
			(cell.viewWithTag(0) as! UILabel).text = "Dream Positivity"
			(cell.viewWithTag(1) as! UILabel).text = "\(positivity ?? 0)%"
		case 1:
			(cell.viewWithTag(0) as! UILabel).text = "Temperature"
			(cell.viewWithTag(1) as! UILabel).text = "\(temp ?? 0)º"
		case 2:
			(cell.viewWithTag(0) as! UILabel).text = "Humidity"
			(cell.viewWithTag(1) as! UILabel).text = "\(humidity ?? 0)%"
		case 3:
			(cell.viewWithTag(0) as! UILabel).text = "Sleep rating"
			(cell.viewWithTag(1) as! UILabel).text = "\(sleepRating ?? 0)/10"
		case 4:
			(cell.viewWithTag(0) as! UILabel).text = "Light"
			(cell.viewWithTag(1) as! UILabel).text = "\(lightAvg ?? 0)%"
		case 5:
			(cell.viewWithTag(0) as! UILabel).text = "Keywords"
			(cell.viewWithTag(1) as! UILabel).text = (keywords ?? ["none found"]).joined(separator: ", ")
		default:
			break
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
}




