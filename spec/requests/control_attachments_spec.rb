RSpec.describe "Control attachments", type: :request do
  include_context "with an SSO authenticated user"

  describe "non-user editable serving configs" do
    let(:serving_config) { create(:serving_config, use_case: :system) }

    it "doesn't render the edit page" do
      get edit_serving_config_control_attachments_path(serving_config)

      expect(response).to have_http_status(:not_found)
    end

    it "doesn't accept updates" do
      put serving_config_control_attachments_path(serving_config), params: {
        serving_config: { control_ids: create_list(:control, 2).map(&:id) },
      }

      expect(response).to have_http_status(:not_found)
    end
  end
end
