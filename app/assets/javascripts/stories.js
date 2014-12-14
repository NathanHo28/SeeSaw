$(document).on('ready page:load', function () {
  $('a.fancybox').fancybox({
  	padding: 0
  });
  $('search-form').submit(function(event) {
  	event.preventDefault();
  	var searchValue = $('#search').val();

  	$.getScript('/stories?search=' + searchValue);
  });
   if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination span.next').children().attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('.pagination').text("Fetching more stories...");
        return $.getScript(url);
      }
    });
  }
});

// $(document).on('ready page:load', function() {
//   if ($('.pagination').length) {
//     $(window).scroll(function() {
//       var url = $('.pagination span.next').children().attr('href');
//       if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
//         $('.pagination').text("Fetching more stories...");
//         return $.getScript(url);
//       }
//     });
//   }
// });