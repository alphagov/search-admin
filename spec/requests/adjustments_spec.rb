RSpec.describe "Adjustments", type: :request do
  describe "GET new" do
    before do
      get new_adjustment_path, params: { kind: }
    end

    context "with a valid adjustment kind" do
      let(:kind) { "boost" }

      it "allows the user to create an adjustment" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "with an invalid adjustment kind" do
      let(:kind) { "invalid" }

      it "redirects to the adjustment path" do
        expect(response).to redirect_to(adjustments_path)
      end
    end
  end
end
