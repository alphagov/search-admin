var combineQueryRows = function() {
  var $queriesTable = $('.queries-table')

  if ($queriesTable) {
    var rows = $queriesTable.find("tr");
    for(var i = 0; i <= rows.length; i++) {
      var $currentRow = $(rows[i])
      var currentRowQuery = $currentRow.find("td").first().text()
      var $nextRow = $(rows[i+1])
      var nextRowQuery = $nextRow.find("td").first().text()
      if (currentRowQuery.toLowerCase().trim() === nextRowQuery.toLowerCase().trim()) {
        $currentRow.addClass('govuk-table__row--group-fst')
        $nextRow.addClass('govuk-table__row--group-snd')
      }
    }
  }
};
combineQueryRows();

// this has been modified to include spaces in user query
;(function() {
  var $formElement = $('[data-module=filterable-table]');

  if ($formElement) {
    var $searchField = $('input[name=table-filter]');

    $searchField.keyup(function() {
      var $rows = $('.govuk-table__body .govuk-table__row')
      var input = $(this).val()
      $rows.hide()
      $rows.removeClass('govuk-table__row--matching')
      $rows.each(function(){
        if($(this).find('td').text().indexOf(input) > -1){
          $(this).show()
          $(this).addClass('govuk-table__row--matching')
        }
      });
      //reset back to original state when no characters in the search box
      if ($searchField.val().length === 0) {
        $rows.removeClass('govuk-table__row--hidden')
        $rows.removeClass('govuk-table__row--matching')
      }
    });
  }
})();
