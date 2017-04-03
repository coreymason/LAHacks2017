var express = require('express'),
	rp = require('request-promise'),
	firebase = require("firebase"),
	PythonShell = require('python-shell'),
	json2csv = require('json2csv'),
	fs = require('fs'),
	path = require('path'),
	secrets = require("./secrets");

firebase.initializeApp(secrets.fbconfig);
var database = firebase.database();

/*launchLinodeServerTasks() {

}*/

module.exports = {
	home: function(req, res) {
		console.log("hey");
		res.sendFile(path.join(__dirname + '/index.html'));
	},

	//Checks if there are 7 days of data, if so look for suggestions and report them
	suggestions: function(req, res) {
		res.status(200).send({});
		/*console.log('sstart')
		var numPoints = 0;
		var userDB = database.ref('users').orderByChild('uid').equalTo(req.params.uid).ref;
		userDB.child('dreamLogs').once('value').then(function(snapshot) {
			numPoints = snapshot.numChildren();
			if(numPoints >= 0) {
				//Gather data for csv
				var data = {
					'index': [],
					'heat': [],
					'light': [],
					'humidity': [],
					'quality': []
				};
				var userDB = database.ref('users').orderByChild('uid').equalTo(req.params.uid).ref;
				userDB.child('dreamLogs').once('value').then(function(snapshot) { //get parent
					var tempCounter = 0;
					snapshot.forEach(function(childSnapshot) { //loop through children
						data.index.push(1+tempCounter);
						data.heat.push(childSnapshot.val().roomData.tempAvg);
						data.light.push(childSnapshot.val().roomData.lightAvg);
						data.humidity.push(childSnapshot.val().roomData.humidAvg);
						data.humidity.push(childSnapshot.val().sleepQuality);
						tempCounter++;
					});
					console.log('sdatadone');

					//Make csv
					var csv = json2csv({ data: data, fields: ['index', 'heat', 'light', 'humidity', 'quality'] });
					fs.writeFile('suggestionData.csv', csv, function(err) {
					  if(err) {
							res.status(500).send(err);
							throw err; //do we need a return here somewhere?
						}
					  console.log('file saved');

						/*
						var pyshell = new PythonShell('linear_regression_engine.py');
						var suggs = [];

						pyshell.on('message', function (message) {
							suggs.push(message);
						  // received a message sent from the Python script (a simple "print" statement)
						  //console.log(message);
						});

						// end the input stream and allow the process to exit
						pyshell.end(function (err) {
						  if (err) throw err;
						  console.log('finished');
							res.status(200).send(suggs);
						});



						//Launch python script
						/*var pyoptions = {
							mode: 'json',
						}
						console.log('just before run');
						PythonShell.run('linear_regression_engine.py', pyoptions, function(err, results) {
			  			if(err) {
								res.status(500).send(err);
								throw err; //do we need a return here somewhere?
							}
						  // results is an array consisting of messages collected during execution
							console.log('res next l');
							console.log(results);
							status(200).send(results);
							return;
						}); //pyshell
					}); //writefile
				}); //parent
			}
		}); //firstchild
		res.status(204).send({});*/
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

	pastDayStats: function(req, res) {
		var userDB = database.ref('users').orderByChild('uid').equalTo(req.params.uid).ref;
		userDB.child('dreamLogs').limitToLast(parseInt(req.params.ago)+1).once('value').then(function(snapshot) { //get parent
			snapshot.forEach(function(childSnapshot) { //loop through children
				//Calulate difference in days
				var currDate = new Date(new Date().toISOString().slice(0,10));
				var logDate = new Date(childSnapshot.val().date);
				var utc1 = Date.UTC(logDate.getFullYear(), logDate.getMonth(), logDate.getDate());
				var utc2 = Date.UTC(currDate.getFullYear(), currDate.getMonth(), currDate.getDate());
				var diffDays = Math.floor((utc2 - utc1) / 1000 / 60 / 60 / 24);
				//add to array if within last 7, including today
				if(diffDays == req.params.ago) {
					res.status(200).send(childSnapshot.val());
					return;
				}
				res.status(204).send({});
			});
		}).catch(function(err) {
			res.status(500).send(err);
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
		}).catch(function(err) {
			res.status(500).send(err);
		});
	},

	globalData: function(req, res) {
		if(!req.body) {
			//nothing sent
			res.sendStatus(400);
		} else {
			var newGlobalData = {
				moodIntensity: req.body.intensity,
				worldMood: req.body.mood,
				ratios: req.body.ratios
			};
			var userDB = database.ref('users').orderByChild('uid').equalTo(req.params.uid).ref;
			userDB.child('dreamLogs').limitToLast(1).once('value').then(function(snapshot) {
				var dreamLogObj = Object.keys(snapshot.val())[0];
				var updates = {};
				updates['dreamLogs/'+dreamLogObj+'/globalData'] = newGlobalData;
				userDB.update(updates).then(function() {
					res.sendStatus(200);
				}).catch(function(err) {
					res.status(500).send(err);
				});
			});
		}
	},

	roomData: function(req, res) {
		if(!req.body) {
			//nothing sent
			res.sendStatus(400);
		} else {
			var newRoomData = {
				tempAvg: req.body.tempAvg,
				lightAvg: req.body.lightAvg,
				humidAvg: req.body.humidAvg
			};
			var userDB = database.ref('users').orderByChild('uid').equalTo(req.params.uid).ref;
			userDB.child('dreamLogs').limitToLast(1).once('value').then(function(snapshot) {
				var dreamLogObj = Object.keys(snapshot.val())[0];
				var updates = {};
				updates['dreamLogs/'+dreamLogObj+'/roomData'] = newRoomData;
				userDB.update(updates).then(function() {
					res.sendStatus(200);
				}).catch(function(err) {
					res.status(500).send(err);
				});
			});
		}
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
						quality: ((req.body.quality == undefined) ? null : req.body.quality),
						roomData: {
							audioValues: [0, 2, 5, 7, 1, 2, 1, 3, 8],
							tempAvg: 77,
							lightAvg: 13,
							humidAvg: 55
						}
					}
					var userDB = database.ref('users').orderByChild('uid').equalTo(req.params.uid).ref;
					userDB.child('dreamLogs').push(newDreamLog).then(function() {

						//get and add world mood
						//launchLinodeServerTasks();
						/*PythonShell.run('twitterMood.py', function (err) {
						  if (err) throw err;
						  console.log('finished');
						});*/

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
