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
	static let userID = "SwFaJKpAMIaKhIz4vS4FCnYvTj33"
	static let root = "http://projectscale.me"
	static func postSleepLogs(text: String, stars: Int) {
		let todoEndpoint: String = "\(root)/dreamLog/\(userID)"
		let newTodo: [String: Any] = ["text" : text, "quality" : stars]
		Alamofire.request(todoEndpoint, method: .post, parameters: newTodo,
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
}









