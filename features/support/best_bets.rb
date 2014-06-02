def create_best_bet(query: nil, match_type: nil, link: nil)
  visit new_best_bet_path

  fill_in 'Query', with: query if query
  select match_type.humanize, from: 'Match type' if match_type
  fill_in 'Link', with: link if link

  click_on 'Save'
  "#{query}-#{match_type}"
end

def check_for_best_bet_on_index_page(query)
  visit best_bets_path
  expect(page).to have_content(query)
end

def edit_best_bet(best_bet, query)
  visit edit_best_bet_path(best_bet)
  fill_in 'Query', with: query
  click_on 'Save'
end

def delete_best_bet(best_bet)
  visit best_bets_path

  within "#best-bet-#{best_bet.id}" do
    click_on 'Delete'
  end
end

def check_absence_of_best_bet_on_index_page(query)
  visit best_bets_path
  expect(page).not_to have_content(query)
end

def check_for_best_bets_in_csv_format(best_bets)
  headers, *rows = *CSV.parse(page.body)

  expect(headers).to eq(['query', 'link'])

  best_bets.each do |best_bet|
    expect(rows).to include([best_bet.query, best_bet.link])
  end
end

def check_rummager_was_sent_an_exact_best_bet_document(best_bets)
  elasticsearch_doc = build_es_doc_from_matching_best_bets(best_bets, include_id_and_type_in_body: true)
  expect(SearchAdmin.services(:rummager_index)).to have_received(:add).with(elasticsearch_doc)
end

def check_rummager_was_sent_a_best_bet_delete(best_bet_ids)
  best_bet_ids.uniq.each do |id|
    expect(SearchAdmin.services(:rummager_index)).to have_received(:delete).with(id, type: "best_bet")
  end
end

def run_elasticsearch_exporter
  `#{Rails.root+'bin/export_best_bets_for_elasticsearch'}`
end

def confirm_elasticsearch_format(dump, best_bets)
  exact_bets, stemmed_bets = best_bets.partition {|bet| bet.match_type == 'exact' }

  [exact_bets].each do |bets|
    bets.group_by(&:query).each do |_, matching_bets|
      representative_bet = matching_bets.first

      es_doc_header = {
        'index' => {
          '_id' => "#{representative_bet.query}-#{representative_bet.match_type}",
          '_type' => 'best_bet'
        }
      }

      es_doc = build_es_doc_from_matching_best_bets(matching_bets)

      expect(dump).to include("#{es_doc_header.to_json}\n#{es_doc.to_json}")
    end
  end
end

def build_es_doc_from_matching_best_bets(best_bets, include_id_and_type_in_body: false)
  positive_bets, negative_bets = best_bets.partition(&:position)

  representative_bet = best_bets.first

  details_json = {
    best_bets: positive_bets.map {|bet| {link: bet.link, position: bet.position} },
    worst_bets: negative_bets.map {|bet| {link: bet.link} }
  }.to_json

  query_field = "#{representative_bet.match_type}_query".to_sym

  es_doc = {
    query_field => representative_bet.query,
    details: details_json
  }

  if include_id_and_type_in_body
    es_doc.merge(
      _id: "#{representative_bet.query}-#{representative_bet.match_type}",
      _type: 'best_bet'
    )
  else
    es_doc
  end
end
