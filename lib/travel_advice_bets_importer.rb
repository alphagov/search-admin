class TravelAdviceBetsImporter
  attr_reader :count, :data

  # @param data [Array] array of arrays eg. [[term_a, link_a],[term_b, link_b]].
  # @param user [User] search admin user.
  # @param logger [IO] stream for logging.
  #
  def initialize(data, user, logger = STDOUT)
    @count = 0
    @data = data
    @user = user
    @logger = logger
  end

  def import
    data.each do |term, link|
      next unless link =~ /^\/world\//

      query = Query.find_or_create_by!(query: term) { |q| q.match_type = "exact" }

      travel_advice_bet = create_bet(query, travel_advice_path(link), 1)
      if travel_advice_bet
        success(travel_advice_bet) if SearchApiSaver.new(travel_advice_bet).save
      end

      help_page_bet = create_bet(query, link, 2)
      if help_page_bet
        success(help_page_bet) if SearchApiSaver.new(help_page_bet).save
      end
    end
  end

private

  attr_reader :logger, :user

  def create_bet(query, link, position)
    return if Bet.find_by(link: link, query: query)

    Bet.create!(
      comment: "Created by bets importer.",
      is_best: true,
      link: link,
      query_id: query.id,
      user_id: user.id,
      position: position,
      permanent: true,
    )
  end

  def travel_advice_path(help_page_link)
    country = help_page_link.split("/").last
    "/foreign-travel-advice/#{country}"
  end

  def success(bet)
    @count += 1
    logger.puts "Saved best bet '#{bet.query.query}': '#{bet.link}' (pos: #{bet.position}) to Search-api."
  end
end
