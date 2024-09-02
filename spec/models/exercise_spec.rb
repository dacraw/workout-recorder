require 'rails_helper'

RSpec.describe Exercise, type: :model do
  let(:exercise) { create :exercise, gemini_response: "This is **some markdown**"}

  describe "#gemini_response_html" do
    it "invokes Redcarpet to render html" do
      expect_any_instance_of(Redcarpet::Markdown).to receive(:render) { "Stubbed HTML" }

      exercise.gemini_response_html
    end
  end
end
