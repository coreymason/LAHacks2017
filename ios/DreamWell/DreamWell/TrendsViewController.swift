//
//  TrendsViewController.swift
//  DreamWell
//
//  Created by Rohin Bhushan on 4/1/17.
//  Copyright © 2017 rohin. All rights reserved.
//

import UIKit
import Charts

enum TrendType : String {
	case airPressure	= "Air Pressure"
	case temperature	= "Temperature"
	case humidity		= "Humidity"
	
	
 static let trends = [airPressure, temperature, humidity]
	
	
}
class TrendsViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	var suggestion = ""
	fileprivate let reuseIdentifier = "TrendCell"
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UINib(nibName: reuseIdentifier, bundle: Bundle.main), forCellReuseIdentifier: reuseIdentifier)
		tableView.register(UINib(nibName: "KeywordCell", bundle: Bundle.main), forCellReuseIdentifier: "KeywordCell")
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func segmentChanged(_ sender: UISegmentedControl) {
		print("segmentChanged yo")
		tableView.reloadData()
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension TrendsViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// one for keywords, then two for each trend type, becuase one for dream quality and one for sentiment
		if segmentedControl.selectedSegmentIndex == 0 {
			return  1
		}
		return 1 + (2 * TrendType.trends.count)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 2.50
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if segmentedControl.selectedSegmentIndex == 0 {
			if indexPath.section == 0 {
				let cell = tableView.dequeueReusableCell(withIdentifier: "KeywordCell") as! KeywordCell
				cell.firstLabel.text = "It seems like you could improve your sleep quality by following a few suggestions:\n uiuh\n heelllo\n last one"
				cell.firstHeightConstraint.constant = 160
				cell.layoutIfNeeded()
				cell.secondLabel.text = ""
				return cell
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: "KeywordCell") as! KeywordCell
				cell.layer.borderColor = greenColor.cgColor
				cell.layer.borderWidth = 1.0
				cell.firstLabel.textColor = greenColor
				cell.secondLabel.textColor = greenColor
				cell.contentView.backgroundColor = UIColor.white
				return cell
			}
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! TrendCell
			cell.isQuality = indexPath.row % 2 != 0
			cell.type = TrendType.trends[(indexPath.row) / 2]
			var yVals = [Double]()
			for _ in 0..<(segmentedControl.selectedSegmentIndex == 2 ? 30 : segmentedControl.selectedSegmentIndex == 1 ? 7 : 1) {
				yVals.append(Double(arc4random_uniform(27) + 1))
			}
			cell.updateChart(yVals: yVals)
			return cell
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		if segmentedControl.selectedSegmentIndex == 0 {
			return 2
		}
		return 1
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return segmentedControl.selectedSegmentIndex == 0 ? indexPath.section == 0 ? 205 : 120 : 300.0
	}
}





