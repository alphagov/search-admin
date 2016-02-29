class LowercaseQueries < ActiveRecord::Migration
  def change
    Query.all.each do |query|
      query.update_attribute(:query, query.query.downcase)
    end

    query_groups = Query.all.group_by { |q| [q.query, q.match_type] }
    puts "Checking for duplicated queries"
    puts query_groups.select { |_, queries|
      queries.count > 1
    }
  end
end
