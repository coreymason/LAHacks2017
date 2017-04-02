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
import AlamofireSwiftyJSON

struct Services {
	static let userID = "SwFaJKpAMIaKhIz4vS4FCnYvTj33"
	static let root = "localhost:8080"
	static func postSleepLogs(text: String) {
		let todosEndpoint: String = "\(root)/dreamLog/\(userID)"
		let newLog: [String: Any] = ["text": text]
		Alamofire.request(todosEndpoint, method: .post, parameters: newLog,
							encoding: JSONEncoding.default)
			.responseJSON { response in
		guard response.result.error == nil else {
			// got an error in getting the data, need to handle it
			print("error calling POST on dream logs")
			print("request", response.request)
			print(response.result.error!)
			return
		}
		// make sure we got some JSON since that's what we expect
		guard let json = response.result.value as? [String: Any] else {
			print("didn't get todo object as JSON from API")
			print("Error: \(response.result.error)")
			return
		}
		// get and print the title
		guard let todoTitle = json["title"] as? String else {
			print("Could not get todo title from JSON")
			return
		}
		print("The title is: " + todoTitle)
  }
	}
	
}










