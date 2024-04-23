RSpec.describe "Recommended links" do
  before do
    # TODO: Refactor me out into a support file (once we have more system specs and old
    # controller specs are gone that this might conflict with)
    GDS::SSO.test_user = create(:user)
  end
end
