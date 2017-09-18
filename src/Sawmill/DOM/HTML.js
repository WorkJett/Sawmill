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

exports.form = function () {
  return document.createElement("form");
};

exports.button = function () {
  return document.createElement("button");
};

exports.checkbox = function () {
  var el = document.createElement("input");
  el.setAttribute("type", "checkbox");
  return el;
};

exports.radiobutton = function () {
  var el = document.createElement("input");
  el.setAttribute("type", "radio");
  return el;
};

exports.inputtext = function () {
  var el = document.createElement("input");
  el.setAttribute("type", "text");
  return el;
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

exports.checked = function (isChecked) {
  return function(target) {
    return function() {
      target.checked = isChecked;
      return target;
    };
  };
};

exports.id = function (elId) {
  return function(target) {
    return function() {
      target.setAttribute("id", elId);
      return target;
    };
  };
};

exports.name = function (elName) {
  return function(target) {
    return function() {
      target.setAttribute("name", elName);
      return target;
    };
  };
};

exports.getValue = function (target) {
  return function() {
    return target.value;
  };
};

exports.append = function (target) {
  return function(child) {
    return function() {
      target.appendChild(child);
      return child;
    };
  };
};

exports.insert = function (target) {
  return function(child) {
    return function() {
      target.insertBefore(child, target.firstChild);
      return child;
    };
  };
};

exports.before = function (target) {
  return function(sibling) {
    return function() {
      var parent = target.parentNode;
      parent.insertBefore(sibling, target);
      return child;
    };
  };
};

exports.remove = function (target) {
  return function() {
    var parent = target.parentNode;
    if(parent != null) {
      parent.removeChild(target);
    }
    return target;
  };
};

exports.clear = function (target) {
  return function() {
    var children = target.children;
    for (var i = 0; i < children.length; i++) {
      var child = children[i];
      target.removeChild(child);
    }
    return target;
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

exports.input = function(target) {
  return function(handler) {
    return function() {
      var proxyHandler = function(event) {
        handler(event)();
      };
      handler.proxy = proxyHandler;
      target.addEventListener('input', proxyHandler);
      return target;
    };
  };
};

exports.uninput = function(target) {
  return function(handler) {
    return function() {
      var proxyHandler = handler.proxy;
      target.removeEventListener('input', proxyHandler);
      return target;
    };
  };
};

exports.focus = function(target) {
  return function(handler) {
    return function() {
      var proxyHandler = function(event) {
        handler(event)();
      };
      handler.proxy = proxyHandler;
      target.addEventListener('focus', proxyHandler);
      return target;
    };
  };
};

exports.unfocus = function(target) {
  return function(handler) {
    return function() {
      var proxyHandler = handler.proxy;
      target.removeEventListener('focus', proxyHandler);
      return target;
    };
  };
};

exports.blur = function(target) {
  return function(handler) {
    return function() {
      var proxyHandler = function(event) {
        handler(event)();
      };
      handler.proxy = proxyHandler;
      target.addEventListener('blur', proxyHandler);
      return target;
    };
  };
};

exports.unblur = function(target) {
  return function(handler) {
    return function() {
      var proxyHandler = handler.proxy;
      target.removeEventListener('blur', proxyHandler);
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

var popupHandlers = [];
document.body.addEventListener("click", function(evt) {
  var isDesc = function(popup, target) {
    if(!target.parentNode) {
      return false;
    }
    var node = target.parentNode;
    if(node == popup) {
      return true;
    }
    return isDesc(popup, node);
  };

  for(var eachPhIndex in popupHandlers) {
    var eachPh = popupHandlers[eachPhIndex];
    if(eachPh.popup != evt.target && !isDesc(eachPh.popup, evt.target)) {
      eachPh.handler(evt);
    }
  }
}, true);

exports.popupClose = function(popup) {
  return function(handler) {
    return function() {
      var proxy = function(evt) {
        handler(evt)();
      };
      popupHandlers.push({popup: popup, handler: proxy});
      return {};
    };
  };
};
