var express = require('express'),
	app = express(),
	routes = require('./routes');;

var port = process.env.PORT || 8080;

app.get('/', routes.home);

app.listen(port);
