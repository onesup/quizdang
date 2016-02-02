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

// Add main View
App.mainView = App.f7.addView('.view-main', {
  dynamicNavbar: true,
  domCache: true
});

App.signupView = App.f7.addView('.view-popup', {
  dynamicNavbar: true,
  // domCache: true
});

// App.f7.addView('.view-1', {
// dynamicNavbar: true,
// // domCache: true
// });

// App.f7.addView('.view-2', {
// dynamicNavbar: true,
// // domCache: true
// });

// App.f7.addView('.view-3', {
// dynamicNavbar: true,
// // domCache: true
// });

// App.f7.addView('.view-4', {
// dynamicNavbar: true,
// // domCache: true
// });

// App.f7.addView('.view-5', {
// dynamicNavbar: true,
// // domCache: true
// });

// if (App.util.isCordova()) {
// if (App.f7.device.android) {
// App.mainView.router.loadPage('http://10.0.2.2:3000/');
// } else if (App.f7.device.ios) {
// App.mainView.router.loadPage('http://localhost:3000/');
// }
// };

Dom7(document).on('pageInit', function(e) {
  App.util.trackPageView();
});

Dom7(document).on('change', '#new_participant input[type=radio]', function(e) {
  Dom7(e.target.form).trigger('submit');
});

Dom7(document).on('ajaxError', function(e) {
  var xhr = e.detail.xhr;
  if (xhr && xhr.status === 401) {
    App.f7.popup('.signin-popup');
  }
});

$(document).on('ajaxError', function(e, xhr) {
  if (xhr && xhr.status === 401) {
    App.f7.popup('.signin-popup');
  }
});

Dom7(document).on('ajaxError', function(e) {
  var xhr = e.detail.xhr;
  if (xhr && xhr.status === 403) {
    App.f7.closeNotification('.notification-item');
    App.f7.addNotification({
      title: 'alert',
      message: '허가 되지 않은 사용 범위 입니다.'
    });
  }
});

$(document).on('ajaxError', function(e, xhr) {
  if (xhr && xhr.status === 403) {
    App.f7.closeNotification('.notification-item');
    App.f7.addNotification({
      title: 'alert',
      message: '허가 되지 않은 사용 범위 입니다.'
    });
  }
});

Dom7(document).on('click', '.close-notification', function(e) {
  App.f7.closeNotification('.notification-item');
});

Dom7(document).on('click', '.tab-link', function(e) {
  e.preventDefault();

  var $elem = Dom7(this);
  var url = $elem.data('href');
  App.mainView.router.loadPage(url);
  Dom7('.tab-link').removeClass('active');
  $elem.addClass('active');
});

Dom7(document).on('click', '.open-searchbar', function(e) {
  e.preventDefault();
  var $elem = Dom7('.searchbar');
  $elem.toggleClass('searchbar-hidden');
});

Dom7(document).on('click', '.searchbar-cancel', function(e) {
  e.preventDefault();
  var $elem = Dom7('.searchbar');
  $elem.addClass('searchbar-hidden');
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

// Pull to refresh content
Dom7(document).on('refresh', '.pull-to-refresh-content', function(e) {
  App.mainView.router.load({ url: window.location.href, ignoreCache: true, reload: true });
  // Emulate 1s loading
  setTimeout(function() {
    App.f7.pullToRefreshDone();
  }, 1000);
});

// Loading flag
App.infiniteLoading = false;
Dom7(document).on('infinite', '.infinite-scroll', function(e) {
  // Exit, if loading in progress
  if (App.infiniteLoading) return;

  // Set loading flag
  App.infiniteLoading = true;

  var $dom = Dom7(this);
  var url = $dom.find('#next-page').attr('href');
  if (url) {
    $.getScript(url);
  } else {
    App.infiniteLoading = false;
    App.f7.detachInfiniteScroll($dom);
  }
});
