module.exports = {
	home: function() {
		// body...
	},

	suggestions: function(req, res) {
	},

	roomData: function(req, res) {
	},

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
			date: new Date(),
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
