module.exports = {
	home: function() {
		// body...
	},

	suggestions: function(req, res) {
	},

	//Returns the current day's stats or else empty
	dayStats: function(req, res) {
		var currDate = new Date().toISOString().slice(0,10);
		var recentDayPost = database.ref('users/' + req.params.uid).child('dreamLogs').limitToLast(1).once('value').then(function(snapshot) {
			if(currDate == snapshot.val().date) {
				res.status(200).send(snapshot.val());
			} else {
				res.status(204).send({});
			}
		});
	},

	//Returns array of 7 objects from most recent to oldest day 7; empty if no data for that day
	weekStats: function(req, res) {
		var ret = [{}, {}, {}, {}, {}, {}, {}];
		var recentWeekPosts = database.ref('users/' + req.params.uid).child('dreamLogs').limitToLast(7).once('value').then(function(snapshot) { //get parent
			snapshot.forEach(function(childSnapshot) { //loop through children
				//Calulate difference in days
				var currDate = new Date();
				var logDate = new Date(childSnapshot.date.val());
				var utc1 = Date.UTC(logDate.getFullYear(), logDate.getMonth(), logDate.getDate());
				var utc2 = Date.UTC(currDate.getFullYear(), currDate.getMonth(), currDate.getDate());
				var diffDays = Math.floor((utc2 - utc1) / 100 / 60 / 60 / 24);
				//add to array if within last 7, including today
				if(diffDays < 7) {
					ret[diffDays] = childSnapshot.val();
				}
			});
		});
		res.status(200).send(ret);
	},

	roomData: function(req, res) {
	},

	//adds log of dream as well as keywords and sentiment analysis to database
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
		        data: {'documents': [{'language': 'en', 'id': '0', 'text': req.body.text}]}
		    },
				headers: {
					'Ocp-Apim-Subscription-Key': secrets.cog
				},
		    json: true
			};
			rp(optionsSent).then(function(body) {
				sentiment = body.documents.score;
			}).catch(function(err) {
				res.status(500).send(err);
			});

			var optionsKey = {
		    method: 'POST',
		    uri: 'https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/keyPhrases',
		    body: {
		        data: {'documents': [{'language': 'en', 'id': '0', 'text': req.body.text}]}
		    },
				headers: {
					'Ocp-Apim-Subscription-Key': secrets.cog
				},
		    json: true
			};
			rp(optionsKey).then(function(body) {
				keywords = body.documents.keyPhrases;
			}).catch(function(err) {
				res.status(500).send(err);
			});
		}

		//send to database
		var newDreamLog = {
			date: new Date().toISOString().slice(0,10),
			dreamContent: req.body.text,
			keywords: kewords,
			sentiment: sentiment
		}
		database.ref('users/' + req.params.uid).child('dreamLogs').push(newDreamLog).then(function() {
			res.sendStatus(200);
		}).catch(function(err) {
			res.status(500).send(err);
		});
	},

}
