/*
 * 	Character Count Plugin - jQuery plugin
 * 	Dynamic character count for text areas and input fields
 *	written by Alen Grakalic	
 *	http://cssglobe.com/post/7161/jquery-plugin-simplest-twitterlike-dynamic-character-count-for-textareas
 *
 *	Copyright (c) 2009 Alen Grakalic (http://cssglobe.com)
 *	Dual licensed under the MIT (MIT-LICENSE.txt)
 *	and GPL (GPL-LICENSE.txt) licenses.
 *
 *	Built for jQuery library
 *	http://jquery.com
 *
 */
 
(function($) {
  $.fn.charCount = function(options){
    var default_count = 140;
    var count_text = '';

    function calc(obj){
      var count = $(obj).val().length;
      var available = default_count - count;
      $(obj).next().html(count_text + available);
    };

    this.each(function() {
      $(this).after('<p class="counter">' + count_text + '</p>')
      calc(this);
      $(this).keyup(function(){calc(this)});
      $(this).change(function(){calc(this)});
    });
  };
})(jQuery);
