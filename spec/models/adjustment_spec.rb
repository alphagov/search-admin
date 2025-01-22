RSpec.describe Adjustment, type: :model do
  it_behaves_like "Discovery Engine syncable", DiscoveryEngine::Control do
    let(:attributes) { attributes_for(:boost_adjustment) }
  end

  describe "validations" do
    subject(:adjustment) { Adjustment.new(attributes) }

    shared_examples "any adjustment" do
      it "is valid with correct attributes" do
        expect(adjustment).to be_valid
      end

      context "without a display name" do
        let(:attributes) { super().merge(name: nil) }

        it "fails validation" do
          expect(adjustment).not_to be_valid
          expect(adjustment.errors).to be_of_kind(:name, :blank)
        end
      end

      context "without a filter expression" do
        let(:attributes) { super().merge(filter_expression: nil) }

        it "fails validation" do
          expect(adjustment).not_to be_valid
          expect(adjustment.errors).to be_of_kind(:filter_expression, :blank)
        end
      end
    end

    context "for a boost adjustment" do
      let(:attributes) { attributes_for(:boost_adjustment) }

      it_behaves_like "any adjustment"

      context "without a boost factor" do
        let(:attributes) { super().merge(boost_factor: nil) }

        it "fails validation" do
          expect(adjustment).not_to be_valid
          expect(adjustment.errors).to be_of_kind(:boost_factor, :not_a_number)
        end
      end

      context "with a boost factor outside the permissible range" do
        let(:attributes) { super().merge(boost_factor: 1.1) }

        it "fails validation" do
          expect(adjustment).not_to be_valid
          expect(adjustment.errors).to be_of_kind(:boost_factor, :in)
        end
      end

      context "with a zero boost factor" do
        let(:attributes) { super().merge(boost_factor: 0.0) }

        it "is valid" do
          expect(adjustment).not_to be_valid
          expect(adjustment.errors).to be_of_kind(:boost_factor, :other_than)
        end
      end
    end

    context "for a filter adjustment" do
      let(:attributes) { attributes_for(:filter_adjustment) }

      it_behaves_like "any adjustment"

      context "with a boost factor" do
        let(:attributes) { super().merge(boost_factor: 0.13) }

        it "fails validation" do
          expect(adjustment).not_to be_valid
          expect(adjustment.errors).to be_of_kind(:boost_factor, :present)
        end
      end
    end
  end

  describe "#control_action" do
    subject(:control_action) { adjustment.control_action }

    context "for a boost adjustment" do
      let(:adjustment) { build_stubbed(:boost_adjustment) }

      it "returns a hash with the boost action" do
        expect(control_action).to eq(
          boost_action: {
            boost: adjustment.boost_factor,
            filter: adjustment.filter_expression,
            data_store: Rails.configuration.discovery_engine_datastore,
          },
        )
      end
    end

    context "for a filter adjustment" do
      let(:adjustment) { build_stubbed(:filter_adjustment) }

      it "returns a hash with the filter action" do
        expect(control_action).to eq(
          filter_action: {
            filter: adjustment.filter_expression,
            data_store: Rails.configuration.discovery_engine_datastore,
          },
        )
      end
    end
  end
end
