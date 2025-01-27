require "gds-sso/lint/user_spec"

RSpec.describe User, type: :model do
  it_behaves_like "a gds-sso user class"

  describe "#admin?" do
    subject(:user) { build_stubbed(:user, permissions:) }

    context "when the user has the `admin` permission" do
      let(:permissions) { %w[admin and others] }

      it { is_expected.to be_admin }
    end

    context "when the user does not have the `admin` permission" do
      let(:permissions) { %w[blah] }

      it { is_expected.not_to be_admin }
    end
  end
end
