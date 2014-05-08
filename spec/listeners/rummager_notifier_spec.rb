require 'spec_helper'

describe RummagerNotifier do
  describe '#call(changed_best_bet)' do
    before do
      FactoryGirl.create(:best_bet, query: 'jobs', match_type: 'exact', link: '/jobs/more-jobs', position: 2)
      FactoryGirl.create(:best_bet, query: 'jobs', match_type: 'exact', link: '/jobsearch', position: 1)

      FactoryGirl.create(:best_bet, query: 'jobs', match_type: 'exact', link: '/topics/employment', position: nil)
      FactoryGirl.create(:best_bet, query: 'jobs', match_type: 'exact', link: '/people/steve-jobs', position: nil)

      FactoryGirl.create(:best_bet, query: 'jobs', match_type: 'stemmed', link: 'http://example.com/jobs', position: 3)
      FactoryGirl.create(:best_bet, query: 'visas', match_type: 'exact', link: '/something/something/visas', position: 1)
    end

    it "sends an elasticsearch doc from all related best bets" do
      RummagerNotifier.call(query: 'jobs', match_type: 'exact', link: '/jobsearch', position: 1)

      expect(SearchAdmin.services(:rummager_index)).to have_received(:add).with({
        exact_query: 'jobs',
        details: {
          best_bets: [
            {link: '/jobsearch', position: 1},
            {link: '/jobs/more-jobs', position: 2}
          ],
          worst_bets: [
            {link: '/people/steve-jobs'},
            {link: '/topics/employment'}
          ]
        }
      })
    end
  end
end
