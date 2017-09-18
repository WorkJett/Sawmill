"use strict";
//
var rootState = {
  _data: {},
  _handlers: []
};

exports.build = function(data) {
  return function() {
    return {
      _data: data,
      _handlers: []
    };
  };
};

exports.provider = function () {
  return rootState;
};

exports.get = function(state) {
  return function() {
    return state._data;
  };
};

exports.set = function(state) {
  return function(value) {
    return function() {
      state._data = value;
      for(var eachHandlerIndex in state._handlers) {
        var handler = state._handlers[eachHandlerIndex];
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
      for(var eachHandlerIndex in state._handlers) {
        var handler = state._handlers[eachHandlerIndex];
        handler(state._data)();
      }
      return state;
    };
  };
};

exports.subscribe = function(state) {
  return function(handler) {
    return function() {
      state._handlers.push(handler);
      return state;
    }
  };
};

exports.behavior = function(state) {
  return function(handler) {
    return function() {
      state._handlers.push(handler);
      handler(state._data)();
      return state;
    }
  };
};

exports.unsubscribe = function(state) {
  return function(handler) {
    return function() {
      var index = state._handlers.indexOf(handler);
      if (index > -1) {
        state._handlers.splice(index, 1);
      }
      return state;
    };
  };
};
