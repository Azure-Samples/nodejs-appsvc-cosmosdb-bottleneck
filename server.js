'use strict';
var http = require('http');
var jsdom = require('jsdom');
var { JSDOM } = jsdom;
var fs = require('fs');
var port = process.env.PORT || 8092;
var dbOperations = require('./databaseOperations.js');
var utils = require('./utils.js');
var config = JSON.parse(fs.readFileSync('config.json', 'utf8'));


var lastTimestamp = 0;
var writeToDbEveryNRecords = 100;
var currentCount = 0;

var server = http.createServer(function (req, res) {
    var reqUrl = req.url.replace(/^\/+|\/+$/g, '');
    var method = req.method.toLowerCase();
    
    if(config.enableSecretsFeature) {
        console.log(req.headers['x-secret']);
        console.log(process.env.HEADER_VALUE);
        if(req.headers['x-secret'] != process.env.HEADER_VALUE) {
            res.writeHead(401, "Unauthorized");
            res.end();
            return;
        }
    }
    if(!reqUrl || (!!reqUrl && (reqUrl == "" || reqUrl.toLowerCase() == "index.html"))){
        var data = fs.readFileSync('index.html');
        
        dbOperations.queryCount(function (visitCount){
            visitCount++;
            var dom = new JSDOM(`${data}`);
            var visitCountElement = dom.window.document.getElementById("visitCount");
            if(!!visitCountElement){
                visitCountElement.innerHTML = "Total visits: " + visitCount;
            }
            var lastVisitElement = dom.window.document.getElementById("lastTimestamp");
            if(!!lastVisitElement) {
                lastVisitElement.innerHTML = "Time since last visit (in milliseconds): " + (lastTimestamp == 0 ? "Never visited" : (Date.now() - lastTimestamp));
            }
            lastTimestamp = Date.now();
            data = dom.serialize();
            utils.writeResponse(res, data);
            currentCount++;
            if(currentCount >= writeToDbEveryNRecords) {
                dbOperations.addRecord("index", currentCount, function(){
                    currentCount = 0;
                }, function(error){
                    // utils.writeResponse(res, data);
                });
            }
        }, function(error){ 
            utils.writeError(res, error);
        });
    }
    else if(!!reqUrl && reqUrl.toLowerCase() == "get" && method == "get") {
        dbOperations.queryCount(function (visitCount){
            // total = visitCount + 1;
            utils.writeResponse(res, writeToDbEveryNRecords*visitCount + currentCount);
        }, function(error){
            utils.writeError(res, error);
        });
    }
    else if(!!reqUrl && reqUrl.toLowerCase() == "add" && method == "post") {
        let body = "";
        let entries = 0;
        req.on('data', chunk => {
            body += chunk;
        })
        req.on('end', () => {
            console.log("add request body: " + body)
            entries = parseInt(body) // 'Buy the milk'
            
            currentCount += entries;
            if(currentCount >= writeToDbEveryNRecords) {
                dbOperations.addRecord("index", currentCount, function(){
                    lastTimestamp = Date.now();
                    utils.writeResponse(res, "added " + success + " entries")
                    currentCount = 0;
                }, function(error){
                    utils.writeError(res, "could not add " + success + " entries")
                });
            } else {
                utils.writeResponse(res, "added " + success + " entries")
            }
        }) 
    }
    else if(reqUrl.toLowerCase() == "lasttimestamp" && method == "get"){
        utils.writeResponse(res, lastTimestamp);
    }
    else {
        utils.writeResponse(res, "not found");
    }
});

exports.listen = function () {
    server.listen.apply(server, arguments);
};
  
exports.close = function (callback) {
    server.close(callback);
};

server.listen(port);
