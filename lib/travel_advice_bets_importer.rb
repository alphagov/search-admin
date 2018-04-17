class TravelAdviceBetsImporter
  attr_reader :data, :logger

  # @param data [Array] array of arrays.
  # @param user [User] search admin user.
  #
  def initialize(data, user, logger = STDOUT)
    @data = data
    @user = user
    @logger = logger
  end

  def import
    count = 0

    data.each do |term, link|
      next unless link =~ /^\/world\//

      query = Query.find_or_create_by(query: term) { |q| q.match_type = "exact" }

      travel_advice_bet = create_travel_advice_bet(query, link)
      if travel_advice_bet
        RummagerSaver.new(travel_advice_bet).save
        count += 1
        logger.puts "Saved best bet '#{term}' : '#{travel_advice_bet.link}' to Rummager."
      end

      help_page_bet = create_travel_advice_help_page_bet(query, link)
      if help_page_bet
        RummagerSaver.new(help_page_bet).save
        count += 1
        logger.puts "Saved best bet '#{term}' : '#{help_page_bet.link}' to Rummager."
      end
    end

    count
  end

private

  attr_reader :user

  def create_travel_advice_bet(query, link)
    ta_path = travel_advice_path(link)
    return if Bet.find_by(link: ta_path)

    Bet.create(
      comment: "Created by bets importer.",
      is_best: true,
      link: ta_path,
      query_id: query.id,
      user_id: user.id,
      position: 1,
    )
  end

  def create_travel_advice_help_page_bet(query, link)
    return if Bet.find_by(link: link)

    Bet.create(
      comment: "Created by bets importer.",
      is_best: true,
      link: link,
      query_id: query.id,
      user_id: user.id,
      position: 2,
    )
  end

  def travel_advice_path(help_page_link)
    country = help_page_link.split("/").last
    "/foreign-travel-advice/#{country}"
  end
end
