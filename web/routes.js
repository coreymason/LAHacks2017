var express = require('express'),
	rp = require('request-promise'),
	firebase = require("firebase"),
	secrets = require("./secrets"),
	app = express();

var port = process.env.PORT || 8080;

firebase.initializeApp(secrets.fbconfig);
var database = firebase.database();

module.exports = {
	home: function() {
		console.log("hey");
	},

	suggestions: function(req, res) {
	},

	//Returns the current day's stats or else empty
	dayStats: function(req, res) {
		var currDate = new Date().toISOString().slice(0,10);
		var userDB = database.ref('users').orderByChild('uid').equalTo(req.params.uid).ref;
		userDB.child('dreamLogs').limitToLast(1).once('value').then(function(snapshot) {
			var dreamLogObj = Object.keys(snapshot.val())[0];
			if(currDate == snapshot.val()[dreamLogObj].date) {
				res.status(200).send(snapshot.val()[dreamLogObj]);
			} else {
				res.status(204).send({});
			}
		});
	},

	//Returns array of 7 objects from most recent to oldest day 7; empty if no data for that day
	weekStats: function(req, res) {
		var ret = [{}, {}, {}, {}, {}, {}, {}];
		var userDB = database.ref('users').orderByChild('uid').equalTo(req.params.uid).ref;
		userDB.child('dreamLogs').limitToLast(7).once('value').then(function(snapshot) { //get parent
			snapshot.forEach(function(childSnapshot) { //loop through children
				//Calulate difference in days
				var currDate = new Date(new Date().toISOString().slice(0,10));
				var logDate = new Date(childSnapshot.val().date);
				var utc1 = Date.UTC(logDate.getFullYear(), logDate.getMonth(), logDate.getDate());
				var utc2 = Date.UTC(currDate.getFullYear(), currDate.getMonth(), currDate.getDate());
				var diffDays = Math.floor((utc2 - utc1) / 1000 / 60 / 60 / 24);
				//add to array if within last 7, including today
				if(diffDays < 7) {
					ret[diffDays] = childSnapshot.val();
				}
			});
			res.status(200).send(ret);
		});
	},

	roomData: function(req, res) {
	},

	//adds log of dream as well as keywords and sentiment analysis to database
	//Post body needs text key and value is the transcript
	dreamLog: function(req, res) {
		if(!req.body) {
			//nothing sent
			res.sendStatus(400);
		} else {
			var sentiment, keywords;
			//send to microsoft nlp
			var optionsSent = {
		    method: 'POST',
		    uri: 'https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/sentiment',
		    body: {
		        documents: [{'language': 'en', 'id': '0', 'text': req.body.text}]
		    },
				headers: {
					'Ocp-Apim-Subscription-Key': secrets.cog,
					'Content-Type': 'application/json'
				},
		    json: true
			};
			rp(optionsSent).then(function(body) {
				sentiment = body.documents[0].score;

				//Done, keywords next
				var optionsKey = {
			    method: 'POST',
			    uri: 'https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/keyPhrases',
			    body: {
			        documents: [{'language': 'en', 'id': '0', 'text': req.body.text}]
			    },
					headers: {
						'Ocp-Apim-Subscription-Key': secrets.cog,
						'Content-Type': 'application/json'
					},
			    json: true
				};
				rp(optionsKey).then(function(body) {
					keywords = body.documents[0].keyPhrases;

					//Done, now submit to db
					//send to database
					var newDreamLog = {
						date: new Date().toISOString().slice(0,10),
						dreamContent: req.body.text,
						keywords: keywords,
						sentiment: sentiment,
						sleepQuality: req.body.quality
					}
					var userDB = database.ref('users').orderByChild('uid').equalTo(req.params.uid).ref;
					userDB.child('dreamLogs').push(newDreamLog).then(function() {
						res.sendStatus(200);
					}).catch(function(err) {
						res.status(500).send(err);
					});
				}).catch(function(err) {
					res.status(500).send(err);
				});
			}).catch(function(err) {
				res.status(500).send(err);
			});
		}
	},

}
