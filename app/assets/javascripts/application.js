//= require jquery
//= require jquery_ujs

// The Bets page contains a button to refresh the iframe.
$('#search-results-refresh').on('click', function () {
  var iframe = document.getElementById('search-results');
  iframe.src = iframe.src;
  return false;
});
