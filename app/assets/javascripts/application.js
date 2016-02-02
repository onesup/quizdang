// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// require turbolinks
//= require framework7/framework7

//= require frontend/js/vendor
//= require frontend/js/app
//= require_self

$(function() {
  // the cookie name is an MD5 hash of 'browser_fingerprint` to obscure slightly what it is
  var cookieName = '2dfaeb1bd6be147c176aeb44076c11e3';

  if (typeof $.cookie(cookieName) === 'undefined') {
    new Fingerprint2().get(function(result, components) {
      // console.log(result); //a hash, representing your device fingerprint
      // console.log(components); // an array of FP components

      $.cookie(cookieName, result, {
        path: '/'
      });
    });
  }
});
