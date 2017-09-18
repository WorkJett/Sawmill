"use strict";
//
var rootState = {
  _data: {},
  _handlers: {}
};

exports.build = function(data) {
  return function() {
    return {
      _data: data,
      _handlers: {}
    };
  };
};

exports.provider = function () {
  return rootState;
};
//
exports.get = function(state) {
  return function() {
    return state._data;
  };
};

exports.set = function(state) {
  return function(value) {
    return function() {
      state._data = value;
      for(var eachHandlerName in state._handlers) {
        var handler = state._handlers[eachHandlerName];
        handler(state._data)();
      }
      return state;
    };
  };
};

exports.update = function(state) {
  return function(redux) {
    return function() {
      var value = redux(state._data);
      state._data = value;
      for(var eachHandlerName in state._handlers) {
        var handler = state._handlers[eachHandlerName];
        handler(state._data)();
      }
      return state;
    };
  };
};

exports.subscribe = function(state) {
  return function(name) {
    return function(handler) {
      return function() {
        state._handlers[name] = handler;
        return state;
      }
    };
  };
};

exports.behavior = function(state) {
  return function(name) {
    return function(handler) {
      return function() {
        state._handlers[name] = handler;
        handler(state._data)();
        return state;
      }
    };
  };
};

exports.unsubscribe = function(state) {
  return function(name) {
    return function() {
      delete state._handlers[name];
      return state;
    };
  };
};
