When(/^I run best bet ElasticSearch exporter$/) do
  @exporter_output = run_elasticsearch_exporter
end

Then(/^all best bets should have been exported in the correct ElasticSearch format$/) do
  confirm_elasticsearch_format(@exporter_output, Query.all)
end
