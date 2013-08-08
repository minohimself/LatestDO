require 'spec_helper'

describe "posta/show" do
  before(:each) do
    @postum = assign(:postum, stub_model(Postum,
      :body => "Body",
      :subject => "Subject"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Body/)
    rendered.should match(/Subject/)
  end
end
