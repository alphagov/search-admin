When(/^I run recommended links ElasticSearch exporter$/) do
  @exporter_output = run_recommended_links_elasticsearch_exporter
end

Then(/^all recommended links should have been exported in the correct ElasticSearch format$/) do
  confirm_recommended_links_elasticsearch_format(@exporter_output, RecommendedLink.all)
end
