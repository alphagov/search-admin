require "gds_api/test_helpers/publishing_api"

class FakeContentItemable
  include ActiveModel::Model

  attr_accessor :content_id, :foo

  def to_publishing_api_content_item
    { foo: foo }
  end
end

RSpec.describe PublishingApi::ContentItemClient, type: :client do
  include GdsApi::TestHelpers::PublishingApi

  subject(:client) { described_class.new }

  let(:content_itemable) { FakeContentItemable.new(content_id: "f00", foo: "bar") }

  before do
    stub_any_publishing_api_put_content
    stub_any_publishing_api_publish
    stub_any_publishing_api_unpublish
  end

  describe "#create" do
    it "puts and publishes the recommended link on Publishing API" do
      client.create(content_itemable) # rubocop:disable Rails/SaveBang (not an ActiveRecord model)

      assert_publishing_api_put_content("f00", { foo: "bar" })
      assert_publishing_api_publish("f00")
    end

    context "when the operation raises an arbitrary error" do
      before do
        stub_publishing_api_isnt_available
      end

      it "raises a ClientError and adds a base validation error" do
        expect { client.create(content_itemable) }.to raise_error(ClientError)

        expect(content_itemable.errors).to be_of_kind(:base, :remote_error)
      end
    end
  end

  describe "#update" do
    it "puts and publishes the recommended link on Publishing API" do
      client.update(content_itemable) # rubocop:disable Rails/SaveBang (not an ActiveRecord model)

      assert_publishing_api_put_content("f00", { foo: "bar" })
      assert_publishing_api_publish("f00")
    end

    context "when the operation raises an arbitrary error" do
      before do
        stub_publishing_api_isnt_available
      end

      it "raises a ClientError and adds a base validation error" do
        expect { client.update(content_itemable) }.to raise_error(ClientError)

        expect(content_itemable.errors).to be_of_kind(:base, :remote_error)
      end
    end
  end

  describe "#delete" do
    it "unpublishes the recommended link on Publishing API" do
      client.delete(content_itemable)

      assert_publishing_api_unpublish("f00", type: "gone")
    end

    context "when the operation raises an arbitrary error" do
      before do
        stub_publishing_api_isnt_available
      end

      it "raises a ClientError and adds a base validation error" do
        expect { client.delete(content_itemable) }.to raise_error(ClientError)

        expect(content_itemable.errors).to be_of_kind(:base, :remote_error)
      end
    end
  end
end
