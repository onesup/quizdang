Dom7(document).on('click', '[data-behavior=sign_in]', function(e) {
  if (!gon.isAuthenticated) {
    e.preventDefault();
    App.f7.popup('.signin-popup');
  }
});

$(document).on('cocoon:before-insert', '#new_question_multiple_choice', function(e, insertedItem) {
  if ($(this).find('.option-item').length >= 4) {
    alert('답변은 최대 4개만 가능합니다.');
    insertedItem[0].innerHTML = '';
  }
});

// $(document).on('click', '.popup-link', function (e){
    // e.preventDefault();
    // $.get($(this).attr('href'), function (content){
        // App.f7.popup('<div class="popup">' + content + '</div>');
    // });
// });
