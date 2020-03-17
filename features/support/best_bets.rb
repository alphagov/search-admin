def create_query(query: nil, match_type: nil, links: [])
  visit queries_path

  click_on "New query"

  fill_in "Query", with: query if query
  select match_type.humanize, from: "Match type" if match_type

  click_on "Save"

  links.each do |(link, is_best, position, comment)|
    fill_in "Link", with: link
    if is_best
      fill_in "Position", with: position
    else
      check "Is worst bet?"
    end
    fill_in "Comment", with: comment
    click_on "Save"
  end
end

def edit_query(query_text: nil, new_query_text: nil)
  visit queries_path

  within(".queries") do
    click_on query_text
  end

  click_on "Edit query"
  fill_in "Query", with: new_query_text
  click_on "Save"
end

def delete_query(query_text: nil)
  visit queries_path

  within(".queries") do
    click_on query_text
  end

  click_on "Delete query"
end

def check_for_query_on_index_page(query: nil, match_type: nil)
  visit queries_path

  within(".queries .govuk-table__body .govuk-table__row") do
    expect(page).to have_content(query)
    expect(page).to have_content(match_type)
  end
end

def check_for_bet_on_query_page(link: nil, is_best: nil, position: nil, query: nil, match_type: nil, comment: nil)
  query = Query.where(query: query, match_type: match_type).first
  visit query_path(query)

  bet_type = is_best ? "best" : "worst"

  within(".#{bet_type}-bets .govuk-table__body .govuk-table__row") do
    expect(page).to have_css "td", text: link
    expect(page).to have_css "td", text: comment
    expect(page).to have_css "td", text: position if is_best
  end
end

def edit_best_bet(best_bet, link)
  visit query_path(best_bet.query)
  click_on best_bet.link

  fill_in "Link", with: link
  click_on "Save"
end

def delete_best_bet(query, _best_bet)
  visit query_path(query)

  within ".best-bets .govuk-table__body .govuk-table__row:first-child" do
    click_on "Delete"
  end
end

def check_for_absence_of_query_on_index_page(query: nil, match_type: nil)
  visit queries_path

  expect(page).not_to have_content(query)
  expect(page).not_to have_content(match_type)
end

def check_absence_of_best_bet_on_query_page(query, link)
  visit query_path(query)
  expect(page).not_to have_content(link)
end

def check_for_queries_in_csv_format(queries)
  headers, *rows = *CSV.parse(page.body)

  expect(headers).to eq(["query", "match_type", "link", "best/worst", "comment"])

  queries.each do |query|
    query.bets.each do |bet|
      expect(rows).to include([query.query, query.match_type, bet.link, "best", ""])
    end
  end
end

def check_search_api_was_sent_an_exact_best_bet_document(query)
  elasticsearch_doc = build_es_doc_from_query(query)
  doc_id = "#{query.query}-#{query.match_type}"

  expect(@search_api).to have_received(:add_document).with(
    doc_id,
    elasticsearch_doc,
    "metasearch",
  )
end

def check_search_api_was_sent_a_best_bet_delete(query_es_ids)
  query_es_ids.each do |id|
    expect(@search_api).to have_received(:delete_document).with(id, "metasearch")
  end
end

def check_search_api_was_sent_a_recommended_link_delete(link:, index:)
  assert_search_api_deleted_item(link, index: index)
end

def run_best_bets_elasticsearch_exporter
  `#{Rails.root + "bin/export_best_bets_for_elasticsearch"}`
end

def confirm_best_bets_elasticsearch_format(dump, queries)
  queries.each do |query|
    es_doc_header = {
      "index" => {
        "_id" => "#{query.query}-#{query.match_type}",
        "_type" => "best_bet",
      },
    }

    es_doc = build_es_doc_from_query(query)
    expect(dump).to include("#{es_doc_header.to_json}\n#{es_doc.to_json}")
  end
end

def build_es_doc_from_query(query)
  details_json = {
    best_bets: query.best_bets.map { |bet| { link: bet.link, position: bet.position } },
    worst_bets: query.worst_bets.map { |bet| { link: bet.link } },
  }.to_json

  query_field = "#{query.match_type}_query".to_sym

  {
    query_field => query.query,
    details: details_json,
  }
end
