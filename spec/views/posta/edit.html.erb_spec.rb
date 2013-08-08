require 'spec_helper'

describe "posta/edit" do
  before(:each) do
    @postum = assign(:postum, stub_model(Postum,
      :body => "MyString",
      :subject => "MyString",
      :prijimatelia => "MyString"
    ))
  end

  it "renders the edit postum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", postum_path(@postum), "post" do
      assert_select "textarea#postum_body[name=?]", "postum[body]"
      assert_select "input#postum_subject[name=?]", "postum[subject]"
      assert_select "input#postum_prijimatelia[name=?]", "postum[prijimatelia]"
    end
  end
end
