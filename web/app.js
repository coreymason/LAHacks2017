var express = require('express'),
	bodyParser = require('body-parser'),
	rp = require('request-promise'),
	firebase = require("firebase"),
	secrets = require("./secrets"),
	routes = require('./routes'),
	app = express();

firebase.initializeApp(secrets.fbconfig);

var database = firebase.database;
var port = process.env.PORT || 8080;

app.use(bodyParser.json());

app.get('/', routes.home);
app.get('/suggestions/:uid', routes.suggestions);
app.get('/dayStats/:uid', routes.dayStats);
app.get('/weekStats/:uid', routes.weekStats);
//app.get('/avgSentiment/:uid', routes.avgSentiment);
app.post('/roomData/:uid', routes.roomData);
app.post('/dreamLog/:uid', routes.dreamLog);

app.listen(port);
