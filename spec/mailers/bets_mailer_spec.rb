require "spec_helper"

describe BetsMailer, type: :mailer do
  describe "expiring_bets_list" do
    let(:address) { "example@publishing.service.gov.uk" }

    let(:expires) { Time.zone.now }

    let(:bets) do
      test_stemmed = create(:query, query: "test",  match_type: "stemmed")
      test_exact   = create(:query, query: "test",  match_type: "exact")
      bread_exact  = create(:query, query: "bread", match_type: "exact")
      bet1 = create(:bet, query: test_stemmed, position: 2, link: "/foo", expiration_date: expires)
      bet2 = create(:bet, query: test_stemmed, position: 1, link: "/bar", expiration_date: expires)
      bet3 = create(:bet, query: test_exact,   position: 1, link: "/baz", expiration_date: expires)
      bet4 = create(:bet, query: bread_exact,  position: 1, link: "/bat", expiration_date: expires)

      [bet1, bet4, bet3, bet2]
    end

    let(:mail) { described_class.expiring_bets_list(address, bets) }

    it "renders the headers" do
      expect(mail.subject).to eq("Best and worst bets expiring on #{expires.strftime('%d %b %Y')}")
      expect(mail.to).to eq([address])
      expect(mail.from).to eq(["inside-government@digital.cabinet-office.gov.uk"])
    end

    it "renders the body" do
      puts mail.body.encoded
      expect(mail.body.encoded).to include("The following best and worst bets expire on #{expires.strftime('%d %b %Y')}.")
      bets.each do |bet|
        expect(mail.body.encoded).to include("- #{bet.query.display_name}: #{bet.link}")
      end
    end
  end
end
