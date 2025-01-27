module SharedContexts
  module Authentication
    RSpec.shared_context "with an SSO authenticated user" do
      let(:sso_user) { create(:user) }

      before do
        GDS::SSO.test_user = sso_user
      end

      after do
        GDS::SSO.test_user = nil
      end
    end

    RSpec.shared_context "without an SSO authenticated user" do
      before do
        # Unfortunately gds-sso assumes that a nil `test_user` is undesirable, and loads the first
        # user from the database. Pretending to set this environment variable is the only way to
        # force an unauthenticated state.
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with("GDS_SSO_MOCK_INVALID").and_return("1")
      end
    end
  end
end
