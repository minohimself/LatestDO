require 'spec_helper'

describe "posta/new" do
  before(:each) do
    assign(:postum, stub_model(Postum,
      :body => "MyString",
      :subject => "MyString",
      :prijimatelia => "MyString"
    ).as_new_record)
  end

  it "renders new postum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", posta_path, "post" do
      assert_select "textarea#postum_body[name=?]", "postum[body]"
      assert_select "input#postum_subject[name=?]", "postum[subject]"
      assert_select "input#postum_prijimatelia[name=?]", "postum[prijimatelia]"
    end
  end
end
