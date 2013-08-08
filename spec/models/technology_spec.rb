require 'spec_helper'

describe "Technology" do

	it "At least one technology should be visible" do
		Technology.new(:name => "test", :discovered => 1).save
		technologies = Technology.all

		expect(technologies.blank?).to eq(false)
	end
	it "Should show default technology price" do
		user = create(:user)
		Technology.new(:id => 1, :name => "test", :discovered => 1, :price => 300).save
		technology = Technology.find(1)

		price = technology.cena_technology(user)

		expect(price).to eq(300)

	end
	it "Should increase technology price" do
		user = create(:user)
		Technology.new(:name => "test", :discovered => 1, :price => 300).save
		Research.new(:technology_id => 1, :user_id => 1, :lvl => 1).save
		tex = Technology.find(1)



		expect(tex.cena_technology(user)).to eq(306)
		expect(tex.vylepseno(user)).to eq(1)
		expect(tex.vylepsi(user)).to eq(true)
		expect(tex.vylepseno(user)).to eq(2)

	end

end