admin = User.create!(name: 'admin-user', email: 'admin-user@email.com', uid: 'a123', organisation_slug: '/hmrc', permissions: ['admin'])
user = User.create!(name: 'test-user', email: 'test-user@email.com', uid: 'a123', organisation_slug: '/hmrc', permissions: ['signin'])

['tax','childcare','brexit', 'nhs', 'export'].each do |q|
  query = Query.create!(query: q, match_type: "exact")
  Bet.create!(link: "/#{q}", position: 1, comment: "test", query_id: query.id, is_best: true, expiration_date: Time.zone.today, user_id: admin.id)
end

['taxing','childcaring','brexiting', 'nhsing', 'exporting'].each do |q|
  query = Query.create!(query: q, match_type: "exact")
  Bet.create!(link: "/#{q}", position: 1, comment: " test", query_id: query.id, is_best: true, user_id: user.id)
end
