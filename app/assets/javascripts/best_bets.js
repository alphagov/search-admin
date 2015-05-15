(function () {
  // The Bets page contains a button to refresh the iframe.
  $('#search-results-refresh').on('click', refreshSearchResults);

  function refreshSearchResults(argument) {
    var iframe = document.getElementById('search-results');
    var currentCacheBust = findParameterInUrl(iframe.src, 'cachebust');
    var newCacheBust = (new Date()).getTime();

    iframe.src = iframe.src.replace(currentCacheBust, newCacheBust);

    return false;
  }

  function findParameterInUrl(url, name) {
    var match = RegExp('[?&]' + name + '=([^&]*)').exec(url);
    return match && decodeURIComponent(match[1].replace(/\+/g, ' '));
  }
})();
