"use strict";

exports.pushState = function (url) {
  return function(title) {
    return function() {
      return window.history.pushState({}, title, url);
    }
  };
};
