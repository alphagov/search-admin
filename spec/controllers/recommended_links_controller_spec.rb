require 'spec_helper'

describe RecommendedLinksController do
  let(:recommended_link_params) do
    {
      title: 'Tax',
      link: 'https://www.tax.service.gov.uk/',
      description: 'Self assessment',
      keywords: 'self, assessment, tax'
    }
  end

  describe '#create' do
    context 'on failure' do
      it "alerts the user" do
        post :create, recommended_link: recommended_link_params.merge(title: nil)
        expect(flash[:alert]).to include('could not create')
      end

      it "renders the new action" do
        post :create, recommended_link: recommended_link_params.merge(title: nil)
        expect(response).to render_template('new')
      end
    end

    context 'on success' do
      it "notifies the user" do
        post :create, recommended_link: recommended_link_params
        expect(flash[:notice]).to include('was created')
      end

      it "redirects to the recommended link" do
        post :create, recommended_link: recommended_link_params
        expect(response).to redirect_to(recommended_link_path(RecommendedLink.last))
      end
    end

    it "displays an error if the recommended link is duplicated" do
      create(:recommended_link, recommended_link_params)
      post :create, recommended_link: recommended_link_params
      expect(flash[:alert]).to include('could not create')
    end
  end

  describe '#update' do
    let(:recommended_link) { create(:recommended_link) }

    def update_recommended_link(options = {})
      put :update, id: recommended_link.id, recommended_link: recommended_link_params.merge(options)
    end

    context 'on failure' do
      it "alerts the user" do
        update_recommended_link(title: nil)
        expect(flash[:alert]).to include('could not update')
      end

      it "renders the edit action" do
        update_recommended_link(title: nil)
        expect(response).to render_template('edit')
      end
    end

    context 'on success' do
      it "notifies the user" do
        update_recommended_link
        expect(flash[:notice]).to include('was updated')
      end

      it "redirects to the recommended link" do
        update_recommended_link
        expect(response).to redirect_to(recommended_link_path(RecommendedLink.last))
      end
    end
  end

  describe '#destroy' do
    let(:recommended_link) { create(:recommended_link) }

    def delete_recommended_link
      delete :destroy, id: recommended_link.id
    end

    context 'on failure' do
      before do
        mock_recommended_link = double(:recommended_link, id: recommended_link.id, destroy: false)
        allow(RecommendedLink).to receive(:find).with(recommended_link.id.to_s).and_return(mock_recommended_link)
      end

      it "alerts the user" do
        delete_recommended_link
        expect(flash[:alert]).to include('could not delete')
      end
    end

    context 'on success' do
      it "notifies the user" do
        delete_recommended_link
        expect(flash[:notice]).to include('was deleted')
      end

      it "redirects to the recommended link index" do
        delete_recommended_link
        expect(response).to redirect_to(recommended_links_path)
      end
    end
  end
end
