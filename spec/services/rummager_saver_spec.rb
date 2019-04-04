require 'spec_helper'

RSpec.describe RummagerSaver do
  let(:query)          { create(:query) }
  let(:rummager_saver) { described_class.new(query) }

  describe "#destroy" do
    context "when passed an unrecognised action" do
      it "raises a custom InvalidAction Error" do
        error_message = "invalid_action not one of: :update, :create, :update_bets, : delete"

        expect { rummager_saver.destroy(action: :invalid_action) }.to raise_error(
          RummagerSaver::InvalidAction, error_message
        )
      end
    end
  end
end
