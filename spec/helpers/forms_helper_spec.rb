class FakeModel
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :name

  validates :name, presence: true
end

RSpec.describe FormsHelper, type: :helper do
  describe "#error_items" do
    subject(:error_items) { helper.error_items(record, :name) }

    let(:record) { FakeModel.new(name:) }

    before do
      # This is necessary to trigger the validations and populate the errors
      record.valid?
    end

    context "when there are no errors" do
      let(:name) { "Jane Doe" }

      it { is_expected.to be_nil }
    end

    context "when there are errors" do
      let(:name) { "" }

      it "returns an array of error items" do
        expect(error_items).to eq([{ text: "Name can't be blank" }])
      end
    end
  end

  describe "#error_summary_items" do
    subject(:error_summary_items) { helper.error_summary_items(record) }

    let(:record) { FakeModel.new(name:) }

    before do
      # This is necessary to trigger the validations and populate the errors
      record.valid?
    end

    context "when there are no errors" do
      let(:name) { "Jane Doe" }

      it { is_expected.to be_empty }
    end

    context "when there are errors" do
      let(:name) { "" }

      it "returns an array of error summary items" do
        expect(error_summary_items).to eq([{ text: "Name can't be blank", href: "#fake_model_name" }])
      end
    end
  end
end
