App.util = App.util || {};

/**
 * Determine whether the file loaded from Cordova or not
 */
App.util.isCordova = function() {
  return !!window.cordova;
};

App.util.trackPageView = function() {
  if (window.ga && typeof window.ga === 'function') {
    var loc = window.location;
    var page = loc.hash ? loc.hash.substring(1) : loc.pathname + loc.search;
    ga('send', 'pageview', page);
  }
};

App.util.scrollTo = function(selector, duration, verticalOffset) {
  var _duration = typeof (duration) !== 'undefined' ? duration : 800;
  var _verticalOffset = typeof (verticalOffset) !== 'undefined' ? verticalOffset : 0;
  var element = Dom7(selector);
  var offsetTop = element.offset().top + _verticalOffset;

  Dom7('.page-content').scrollTop(offsetTop, _duration);
};
