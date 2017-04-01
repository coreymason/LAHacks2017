//
//  TrendsViewController.swift
//  DreamWell
//
//  Created by Rohin Bhushan on 4/1/17.
//  Copyright © 2017 rohin. All rights reserved.
//

import UIKit
import Charts

class TrendsViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	fileprivate let reuseIdentifier = "TrendCell"
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UINib(nibName: reuseIdentifier, bundle: Bundle.main), forCellReuseIdentifier: reuseIdentifier)
		tableView.register(UINib(nibName: "KeywordCell", bundle: Bundle.main), forCellReuseIdentifier: "KeywordCell")
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
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
		return 5
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "KeywordCell") as! KeywordCell
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! TrendCell
			//cell.layer.masksToBounds = true
			var yVals = [Double]()
			for _ in 0..<(segmentedControl.selectedSegmentIndex == 2 ? 47 : segmentedControl.selectedSegmentIndex == 1 ? 30 : 7) {
				yVals.append(Double(arc4random_uniform(27) + 1))
			}
			cell.updateChart(yVals: yVals)
			return cell
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return indexPath.row == 0 ? 120 : 300.0
	}
}





