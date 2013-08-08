require 'spec_helper'
require "User"
describe Postum do
	it "Should test the method zistiIdPrijemcu" do
		user = create(:user)
		posta = Postum.new(:prijimatela => user.nick, :subject => "test")

		Postum.posliPostu(user.nick, user.nick, posta)
    id = Postum.zistiIdPrijemcu(user.nick)

		expect(id).to eq(1)

	end
	it "Should test the method zistiMenoOdosielatela" do
		user = create(:user)
		posta = Postum.new(:prijimatela => user.nick, :subject => "test")
		Postum.posliPostu(user.nick, user.nick, posta)
		name = Postum.zistiMenoOdosielatela(1)
		expect(name).to eq(user.nick)
	end
	it "New message should be unread" do
		user = create(:user)
		posta = Postum.new(:prijimatela => user.nick, :subject => "test")
		Postum.posliPostu(user.nick, user.nick, posta)
		expect(posta.proctena?).to eq(false)
	end
	it "Message should be read" do
		user = create(:user)
		posta = Postum.new(:prijimatela => user.nick, :subject => "test")
		Postum.posliPostu(user.nick, user.nick, posta)
		Postum.procist(posta)
		expect(posta.proctena?).to eq(true)
	end
end

