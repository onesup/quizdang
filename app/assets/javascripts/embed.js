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
//= require_self

// Initialize my app
var App = window.App || {};

// Initialize Framework7
App.f7 = new Framework7({
  pushState: true,
  pushStateSeparator: '',
  // pushStateRoot: 'http://localhost:3000',
  // pushStatePreventOnLoad: true,
  animateNavBackIcon: true,
  // cache: false,
  // router: false,
  // ajaxLinks: 'a.frame7',
  // material: true,
  // hideNavbarOnPageScroll: true,
  hideTabbarOnPageScroll: true,
  notificationHold: 3000,
});

// Export selectors engine
var $$ = Dom7;

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

  Dom7(document).on('change', '#new_participant input[type=radio]', function(e) {
    Dom7('a.text').click();
  });

  Dom7(document).on('ajaxError', function(e) {
    var xhr = e.detail.xhr;
    if (xhr && xhr.status === 401) {
      Dom7('a.text').click();
    }
  });

  $(document).on('ajaxError', function(e, xhr) {
    if (xhr && xhr.status === 401) {
      Dom7('a.text').click();
    }
  });

  $(document).on('click', '.question-card .share-button', function(e) {
    e.preventDefault();
    $(this).parents('.question-card').find('.more-action').click();
  });

  $(document).on('click', '.question-card .more-action', function(e) {
    e.preventDefault();
    var $dom = $(this);
    var shareButtons = [
      {
        text: '공유',
        label: true
      },
      {
        text: '페이스북',
        onClick: function() {
          var url = $dom.find('.share-action').attr('href');
          FB.ui({
            method: 'share',
            href: url,
          }, function(response) {
          });
        }
      },
      {
        text: '트위터',
        onClick: function() {
          var url = encodeURIComponent($dom.find('.share-action').attr('href'));
          var text = encodeURIComponent('');
          var top = (screen.height / 2) - (450 / 2);
          var left = (screen.width / 2) - (550 / 2);
          window.open('http://twitter.com/share?url=' + url + '&text=' + text + '&', 'twitterwindow', 'height=300, width=670, top=' + top + ', left=' + left + ', toolbar=0, location=0, menubar=0, directories=0, scrollbars=0');
        }
      },
      {
        text: '임베드',
        onClick: function() {
          var content = $dom.find('.embed-action').html();
          App.f7.alert(content, '임베드 공유');
        }
      },
    ];

    var moderaterButtons = [
      {
        text: '수정',
        onClick: function() {
          var url = $dom.find('.edit-action').attr('href');
          // ignoreCache for edit/update(bypass dom cache)
          App.mainView.router.load({ url: url, ignoreCache: true });
        }
      },

      {
        text: '삭제',
        color: 'red',
        onClick: function() {
          var url = $dom.find('.destroy-action').attr('href');
          if (confirm('삭제하시겠습니까?')) {
            $.ajax({
              url: url,
              method: 'DELETE',
              dataType: 'script',
            });
          }
        }
      },
    ];

    if ($dom.hasClass('moderater')) {
      App.f7.actions([shareButtons, moderaterButtons]);
    } else {
      App.f7.actions([shareButtons]);
    }
  });
});
