require 'rails_helper'

RSpec.describe Workout, type: :model do
  let(:workout) { build(:workout, user: build(:user))}

  it "successfully saves" do
    expect(workout.save).to be_truthy
  end
  
  it "requires a user" do
    workout = build(:workout, user: nil)

    expect(workout.save).to eq false
  end
  
  it "sets the date if none is present" do
    expect(workout.date).to be_nil
    workout.save
    expect(workout.date).to be_present
  end

  context "#gemini_response_html" do
    let(:workout) { create(:workout, user: build(:user), gemini_response: "**hey**: _what's up_")}

    it "renders html" do
      expect(workout.gemini_response_html).to eq "<p><strong>hey</strong>: <em>what&#39;s up</em></p>\n"
    end
  end
end
