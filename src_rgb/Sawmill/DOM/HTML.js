"use strict";

var Maybe = PS["Data.Maybe"];

exports.body = function () {
  return document.body;
};

exports.one = function (query) {
  return function() {
    var result = document.body.querySelector(query);
    if(result == null) {
      return new Maybe.Nothing();
    } else {
      return new Maybe.Just(result);
    }
  };
};

exports.many = function (query) {
  return function() {
    return Array.prototype.slice.call(document.body.querySelectorAll(query));
  };
};

exports.div = function () {
  return document.createElement("div");
};

exports.button = function () {
  return document.createElement("button");
};

exports.klass = function (className) {
  return function(target) {
    return function() {
      target.className = className;
      return target;
    };
  };
};

exports.text = function (content) {
  return function(target) {
    return function() {
      target.innerHTML = content;
      return target;
    };
  };
};

exports.append = function (target) {
  return function(child) {
    return function() {
      target.appendChild(child);
      return target;
    };
  };
};

exports.insert = function (target) {
  return function(child) {
    return function() {
      target.insertBefore(child, target.firstChild);
      return target;
    };
  };
};

exports.before = function (target) {
  return function(sibling) {
    return function() {
      var parent = target.parentNode;
      parent.insertBefore(sibling, target);
      return target;
    };
  };
};

exports.remove = function (target) {
  return function() {
    var parent = target.parentNode;
    parent.removeChild(target);
    return parent;
  };
};

exports.click = function(target) {
  return function(handler) {
    return function() {
      var proxyHandler = function(event) {
        handler(event)();
      };
      handler.proxy = proxyHandler;
      target.addEventListener('click', proxyHandler);
      return target;
    };
  };
};

exports.unclick = function(target) {
  return function(handler) {
    return function() {
      var proxyHandler = handler.proxy;
      target.removeEventListener('click', proxyHandler);
      return target;
    };
  };
};

exports.stopPropagation = function(event) {
  return function() {
    event.stopPropagation();
    return {};
  };
};

exports.preventDefault = function(event) {
  return function() {
    event.preventDefault();
    return {};
  };
};
