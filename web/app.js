var express = require('express'),
	bodyParser = require('body-parser'),
	rp = require('request-promise'),
	firebase = require("firebase"),
	secrets = require("./secrets"),
	routes = require('./routes'),
 	path = require('path'),
	app = express();

var port = process.env.PORT || 8080;

app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));


var jsonParser = bodyParser.json();
var urlencodedParser = bodyParser.urlencoded({ extended: false })

app.get('/', routes.home);
app.get('/suggestions/:uid', routes.suggestions);
app.get('/dayStats/:uid', routes.dayStats);
app.get('/weekStats/:uid', routes.weekStats);
app.get('/pastDayStats/:uid/:ago', routes.pastDayStats);
app.post('/globalData/:uid', urlencodedParser, routes.globalData);
app.post('/roomData/:uid', jsonParser, routes.roomData);
app.post('/dreamLog/:uid', jsonParser, routes.dreamLog);

app.listen(port);
