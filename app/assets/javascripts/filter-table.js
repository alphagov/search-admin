;(function() {
  var $formElement = $('[data-module=filterable-table]');

  if ($formElement) {
    var $searchField = $('input[name=table-filter]');

    $searchField.keyup(function() {
      var $rows = $('.govuk-table__body .govuk-table__row')
      $rows.hide()
      var input = this.value.split(" ")
      $.each(input, function(i, value) {
        $rows.filter(":contains('" + value + "')").show()
      });
    });
  }
})();