(function () {
  // The Bets and External Links pages contain a button to refresh the iframe.
  $('#search-results-refresh').on('click', refreshSearchResults)

  function refreshSearchResults (argument) {
    var iframe = document.querySelector('.search-results__iframe')
    var currentCacheBust = findParameterInUrl(iframe.src, 'cachebust')
    var newCacheBust = (new Date()).getTime()

    iframe.src = iframe.src.replace(currentCacheBust, newCacheBust)

    return false
  }

  function findParameterInUrl (url, name) {
    var match = RegExp('[?&]' + name + '=([^&]*)').exec(url)
    return match && decodeURIComponent(match[1].replace(/\+/g, ' '))
  }
})()
