module SharedContexts
  module CurrentUser
    RSpec.shared_context "with a current user" do
      let(:current_user) { create(:user) }

      before do
        Current.user = current_user
      end

      after do
        Current.reset
      end
    end
  end
end
