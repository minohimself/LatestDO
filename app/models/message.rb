class Message < ActiveRecord::Base
  attr_accessible :body, :subject, :read, :recipients, :druh
	has_many :conversations
	belongs_to :user

	validates_presence_of :recipients, :subject, :body


end
public
def zistiIdPrijemcu(komu)
			user = User.where('nick' => komu).first
			if user
				user.id
			else
				0
			end
end
def zistiMenoOdosielatela(id)
	  user = User.where('id' => id).first
		user.nick
end

def vymaz(user,odoslana)
	if odoslana
	recipients = Conversation.where('sender' => user, 'message_id' => self.id)
	recipients.each do |r|
		r.update_attributes(:deleted_by => "S")
	end
	else
		recipients = Conversation.where('recipient' => user, 'message_id' => self.id)
		recipients.each do |r|
			r.update_attributes(:deleted_by => "R")
		end
	end
end

public
def posliPostu(odosielatel, komu, posta)
	prijemci = komu.split(",")

	index = 0
	while index < prijemci.length
		prijemca = prijemci[index]

		prijemca = prijemca[1..prijemca.length] if index >0
		user = User.find(self.zistiIdPrijemcu(prijemca))
		if user
		Message.vytvor_postu(odosielatel,prijemca,posta)
		end
		index += 1
	end
end

def vytvor_postu(odosielatel, komu, posta)
	if self.zistiIdPrijemcu(komu)
	Conversation.new(
			:message_id => posta.id,
			:sender => odosielatel.id,
			:recipient => (self.zistiIdPrijemcu(komu))
	).save
	end
end

def procist(posta)
	posta.update_attribute(:read, true)
end




#scope :prijata, where(:kind => "M")
#scope :prijata, ->(recipient) { where("conversations.recipient < ?", recipient) }, :include => [:conversations]
#scope :odoslana, where(:kind => "N")
#scope :prijata, where(:kind => "M")
#scope :odoslana, where(:kind => "N")