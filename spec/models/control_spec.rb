RSpec.describe Control, type: :model do
  it_behaves_like "RemoteSynchronizable", DiscoveryEngine::ControlClient

  describe "validations" do
    subject(:control) { build(:control) }

    it { is_expected.to be_valid }

    context "without a display name" do
      before do
        control.display_name = nil
      end

      it "is invalid" do
        expect(control).to be_invalid
        expect(control.errors).to be_of_kind(:display_name, :blank)
      end
    end

    context "without an action" do
      before do
        control.action = nil
      end

      it "is invalid" do
        expect(control).to be_invalid
        expect(control.errors).to be_of_kind(:action, :blank)
      end
    end
  end

  describe "Discovery Engine representation" do
    subject(:control) { build_stubbed(:control, id: 42, display_name: "My boost control", action:) }

    let(:action) { build(:control_boost_action) }

    describe "#remote_resource_id" do
      it "builds an ID from the control's database ID" do
        expect(control.remote_resource_id).to eq("search-admin-42")
      end
    end

    describe "#parent" do
      it "is the configured engine" do
        expect(control.parent).to eq(Engine.default)
      end
    end

    describe "#name" do
      it "returns the fully qualified name of the control" do
        expect(control.name).to eq("#{Engine.default.name}/controls/search-admin-42")
      end
    end

    describe "#to_discovery_engine_control" do
      it "returns a representation of the control for Discovery Engine" do
        expect(control.to_discovery_engine_control).to include(
          name: "#{Engine.default.name}/controls/search-admin-42",
          display_name: "My boost control",
          # We don't care what's in the action (that's tested elsewhere), but we do care that the
          # key is present
          boost_action: hash_including,
          solution_type: Google::Cloud::DiscoveryEngine::V1::SolutionType::SOLUTION_TYPE_SEARCH,
          use_cases: [Google::Cloud::DiscoveryEngine::V1::SearchUseCase::SEARCH_USE_CASE_SEARCH],
        )
      end
    end
  end
end
