RSpec.describe DocumentControl do
  describe "validations" do
    it "requires a link" do
      document_control = DocumentControl.new
      expect(document_control).not_to be_valid
      expect(document_control.errors.messages[:link]).to include("can't be blank")
    end
  end
end
