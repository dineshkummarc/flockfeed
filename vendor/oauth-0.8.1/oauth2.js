#!/usr/local/bin/node
// generated by npm, please don't touch!
var dep = require('path').join(__dirname, "./../.npm/oauth/0.8.1/dependencies")
var depMet = require.paths.indexOf(dep) !== -1
var from = "./../.npm/oauth/0.8.1/package/lib/oauth2"

if (!depMet) require.paths.unshift(dep)
module.exports = require(from)

if (!depMet) {
  var i = require.paths.indexOf(dep)
  if (i !== -1) require.paths.splice(i, 1)
}
