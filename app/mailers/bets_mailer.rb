class BetsMailer < ApplicationMailer
  def expiring_bets_list(address, bets)
    @when = bets.first.expiration_date
    @grouped_bets = bets.each_with_object({}) do |bet, grouped|
      grouped[bet.query.display_name] ||= []
      grouped[bet.query.display_name] << bet.link
    end

    view_mail(
      template_id,
      to: address,
      subject: "Best and worst bets expiring on #{@when.strftime('%d %b %Y')}",
    )
  end
end
