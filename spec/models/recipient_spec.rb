require 'spec_helper'

describe Recipient do
  it "should create Recipient" do
	  #user = create(:user)
	  recipient = create(:recipient)
	  expect(recipient.id).to eq(1)
  end
end
