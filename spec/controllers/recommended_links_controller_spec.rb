describe RecommendedLinksController do
  let(:recommended_link_params) do
    {
      title: "Tax",
      link: "https://www.tax.service.gov.uk/",
      description: "Self assessment",
      keywords: "self, assessment, tax",
    }
  end

  before(:each) do
    stub_request(:put, /publishing-api\.test\.gov\.uk\/v2\/content\//).to_return(status: 200)
    stub_request(:post, /publishing-api\.test\.gov\.uk\/v2\/content\//).to_return(status: 200)
  end

  RSpec::Matchers.define :expected_link do |link|
    match { |recommended_link| recommended_link.link == link }
  end

  describe "#create" do
    context "on failure" do
      it "renders the new action" do
        post :create, params: { recommended_link: recommended_link_params.merge(title: nil) }
        expect(response).to render_template("new")
      end
    end

    context "on success" do
      it "sends the link to the publishing API" do
        expect(ExternalContentPublisher).to receive(:publish).with(
          expected_link(recommended_link_params[:link]),
        )
        post :create, params: { recommended_link: recommended_link_params }
      end

      it "notifies the user" do
        post :create, params: { recommended_link: recommended_link_params }
        expect(flash[:notice]).to include("was created")
      end

      it "redirects to the recommended link" do
        post :create, params: { recommended_link: recommended_link_params }
        expect(response).to redirect_to(recommended_link_path(RecommendedLink.last))
      end
    end
  end

  describe "#update" do
    let(:recommended_link) { create(:recommended_link) }

    def update_recommended_link(options = {})
      put :update, params: { id: recommended_link.id, recommended_link: recommended_link_params.merge(options) }
    end

    context "on failure" do
      it "renders the edit action" do
        update_recommended_link(title: nil)
        expect(response).to render_template("edit")
      end
    end

    context "on success" do
      it "notifies the user" do
        update_recommended_link
        expect(flash[:notice]).to include("was updated")
      end

      it "redirects to the recommended link" do
        update_recommended_link
        expect(response).to redirect_to(recommended_link_path(RecommendedLink.last))
      end

      it "updates the link in the publishing API" do
        new_link = "http://new-link.com"

        expect(ExternalContentPublisher).to receive(:publish).with(
          expected_link(new_link),
        )

        update_recommended_link(link: new_link)

        recommended_link.reload

        expect(recommended_link.link).to eq(new_link)
      end
    end
  end

  describe "#destroy" do
    let(:recommended_link) { create(:recommended_link) }

    def delete_recommended_link
      delete :destroy, params: { id: recommended_link.id }
    end

    context "on failure" do
      before do
        mock_recommended_link = double(:recommended_link, id: recommended_link.id, destroy: false)
        allow(RecommendedLink).to receive(:find).with(recommended_link.id.to_s).and_return(mock_recommended_link)
      end

      it "alerts the user" do
        delete_recommended_link
        expect(flash[:alert]).to include("could not delete")
      end
    end

    context "on success" do
      it "notifies the user" do
        delete_recommended_link
        expect(flash[:notice]).to include("was deleted")
      end

      it "redirects to the recommended link index" do
        delete_recommended_link
        expect(response).to redirect_to(recommended_links_path)
      end

      it "unpublishes the link in the publishing API" do
        expect(ExternalContentPublisher).to receive(:unpublish).with(
          expected_link(recommended_link_params[:link]),
        )
        delete_recommended_link
      end
    end
  end
end
