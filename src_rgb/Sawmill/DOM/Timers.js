"use strict";

exports.setTimeout = function (ms) {
  return function(handler) {
    return function() {
      return window.setTimeout(handler(), ms);
    };
  };
};

exports.setInterval = function () {
  return function(handler) {
    return function() {
      return window.setInterval(handler(), ms);
    };
  };
};

exports.clearTimeout = function (timer) {
  return function() {
    window.clearTimeout(timer);
    return {};
  };
};

exports.clearInterval = function (timer) {
  return function() {
    window.clearInterval(timer);
    return {};
  };
};
