// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .
//= require charCount

  function countChar(val) {
    var max_count = 140;

    var len = val.value.length;
    if (len >= max_count) {
      val.value = val.value.substring(0, max_count);
    } else {
      $('#char_counter').text(max_count);
    }
  };

countChar($('#micropost_content').get(0));
$('#micropost_content').keyup(function() {
  countChar(this);
});
