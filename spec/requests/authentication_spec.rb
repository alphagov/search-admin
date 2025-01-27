class FakeController < ApplicationController
  def hello
    render plain: "Hello, world!"
  end
end

RSpec.describe "Authentication", type: :request do
  before(:all) do
    Rails.application.routes.draw do
      get "hello" => "fake#hello"
    end
  end

  after(:all) do
    Rails.application.reload_routes!
  end

  context "when the user is authenticated" do
    include_context "with an SSO authenticated user"

    it "allows the request to proceed" do
      get hello_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq("Hello, world!")
    end
  end

  context "when the user is unauthenticated" do
    include_context "without an SSO authenticated user"

    it "redirects to the GDS SSO page" do
      get hello_path

      expect(response).to redirect_to("http://www.example.com/auth/gds")
    end
  end
end
