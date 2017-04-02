//
//  Services.swift
//  DreamWell
//
//  Created by Rohin Bhushan on 4/1/17.
//  Copyright © 2017 rohin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Services {
	static var delegate : ServicesDelegate?
	static let userID = "SwFaJKpAMIaKhIz4vS4FCnYvTj33"
	static let root = "http://projectscale.me"
	
	static func postSleepLogs(text: String, stars: Int) {
		let endpoint: String = "\(root)/dreamLog/\(userID)"
		let newTodo: [String: Any] = ["text" : text, "quality" : stars]
		Alamofire.request(endpoint, method: .post, parameters: newTodo,
                    encoding: JSONEncoding.default).responseString { response in
			guard response.result.error == nil else {
				// got an error in getting the data, need to handle it
				print("error calling POST on dreamlog")
				print(response.result.error!)
				return
			}
			print("SUCCESS SENDING SLEEP LOGS")
		}
	}
	
	static func getDailyStat(dayOffset : Int = 0) {
		let endpoint = "\(root)/pastDayStats/\(userID)/\(dayOffset)"
		Alamofire.request(endpoint).responseJSON { response in
			// check for errors
			guard response.result.error == nil else {
				// got an error in getting the data, need to handle it
				print("error calling GET on /todos/1")
				print(response.result.error!)
				return
			}
			
			guard let json = response.result.value as? [String: Any] else {
				print("didn't get todo object as JSON from API")
				print("Error: \(response.result.error)")
				return
			}
			DispatchQueue.main.async {
				delegate?.dailyStatsReceived(json: json)
			}
		}
	}
	
	static func getSuggestion() {
		
	}
	
}

protocol ServicesDelegate {
	func dailyStatsReceived(json: [String: Any])
}









