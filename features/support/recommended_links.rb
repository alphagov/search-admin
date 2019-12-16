def create_recommended_link(title: nil, link: nil, description: nil, keywords: nil)
  stub_any_publishing_api_put_content
  stub_any_publishing_api_publish

  visit recommended_links_path

  click_on "New external link"

  fill_in "Link", with: link if link
  fill_in "Title", with: title if title
  fill_in "Description", with: description if description
  fill_in "Keywords", with: keywords if keywords

  click_on "Save"
end

def edit_recommended_link(old_title: nil, old_link: nil, title: nil, description: nil, keywords: nil, comment: nil)
  stub_any_publishing_api_put_content
  stub_any_publishing_api_publish

  visit recommended_links_path

  recommended_link = RecommendedLink.where(link: old_link).last

  within("#recommended-link-#{recommended_link.id}") do
    click_on old_title
  end

  click_on "Edit external link"
  fill_in "Title", with: title if title
  fill_in "Description", with: description if description
  fill_in "Keywords", with: keywords if keywords
  fill_in "Comment", with: comment if comment
  click_on "Save"
end

def delete_recommended_link(title: nil, link: nil)
  stub_any_publishing_api_unpublish

  visit recommended_links_path

  recommended_link = RecommendedLink.where(link: link).last

  within("#recommended-link-#{recommended_link.id}") do
    click_on title
  end

  click_on "Delete external link"
end

def check_for_recommended_link_on_index_page(title: nil)
  visit recommended_links_path

  within(".recommended-links-list") do
    expect(page).to have_content(title)
  end
end

def check_for_absence_of_recommended_link_on_index_page(title: nil)
  visit recommended_links_path

  expect(page).not_to have_content(title)
end

def check_for_recommended_links_in_csv_format(recommended_links)
  headers, *rows = *CSV.parse(page.body)

  expect(headers).to eq(%w(title link description keywords comment))

  recommended_links.each do |recommended_link|
    expect(rows).to include([
      recommended_link.title,
      recommended_link.link,
      recommended_link.description,
      recommended_link.keywords,
      "",
    ])
  end
end

def check_search_api_was_sent_an_exact_recommended_link_document(recommended_link:, index:)
  elasticsearch_doc = build_doc_from_recommended_link(recommended_link)
  assert_search_api_posted_item(
    elasticsearch_doc.merge(
      "_type" => "edition",
      "link" => recommended_link.link,
      "_id" => recommended_link.link,
    ),
    index: index,
  )
end

def check_search_api_was_sent_a_recommended_link_delete(link:, index:)
  assert_search_api_deleted_item(link, index: index)
end

def check_recommended_link_was_published(recommended_link, publishing_count)
  assert_publishing_api_put_content(
    recommended_link.content_id,
    request_json_includes(title: recommended_link.title),
  )

  expected_request_body = nil
  assert_publishing_api_publish(recommended_link.content_id, expected_request_body, publishing_count)
end

def check_recommended_link_was_unpublished(content_id)
  assert_publishing_api_unpublish(content_id)
end

def run_recommended_links_elasticsearch_exporter
  `#{Rails.root + "bin/export_recommended_links_for_elasticsearch"}`
end

def confirm_recommended_links_elasticsearch_format(dump, recommended_links)
  recommended_links.each do |recommended_link|
    es_doc_header = {
      "index" => {
        "_id" => recommended_link.link,
        "_type" => recommended_link.format,
      },
    }

    es_doc = build_doc_from_recommended_link(recommended_link, include_es_data: true)
    expect(dump).to include("#{es_doc_header.to_json}\n#{es_doc.to_json}")
  end
end

def build_doc_from_recommended_link(recommended_link, include_es_data: false)
  details = {
    title: recommended_link.title,
    link: recommended_link.link,
    description: recommended_link.description,
    format: recommended_link.format,
    indexable_content: recommended_link.keywords,
  }

  if include_es_data
    {
      link: recommended_link.link,
      details: details.to_json,
    }
  else
    details
  end
end
