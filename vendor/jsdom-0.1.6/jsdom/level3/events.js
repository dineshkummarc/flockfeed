#!/usr/local/bin/node
// generated by npm, please don't touch!
var dep = require('path').join(__dirname, "./../../../.npm/jsdom/0.1.6/dependencies")
var depMet = require.paths.indexOf(dep) !== -1
var from = "./../../../.npm/jsdom/0.1.6/package/lib/jsdom/level3/events"

if (!depMet) require.paths.unshift(dep)
module.exports = require(from)

if (!depMet) {
  var i = require.paths.indexOf(dep)
  if (i !== -1) require.paths.splice(i, 1)
}
