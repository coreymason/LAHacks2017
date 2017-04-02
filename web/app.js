var express = require('express'),
	bodyParser = require('body-parser'),
	rp = require('request-promise'),
	firebase = require("firebase"),
	secrets = require("./secrets"),
	routes = require('./routes'),
	app = express();

var port = process.env.PORT || 8080;

app.use(bodyParser.json());

var jsonParser = bodyParser.json();

app.get('/', routes.home);
app.get('/suggestions/:uid', routes.suggestions);
app.get('/dayStats/:uid', routes.dayStats);
app.get('/weekStats/:uid', routes.weekStats);
app.post('/roomData/:uid', jsonParser, routes.roomData);
app.post('/dreamLog/:uid', jsonParser, routes.dreamLog);

app.listen(port);
