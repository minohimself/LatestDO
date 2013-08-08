class Postum < ActiveRecord::Base
  attr_accessible :body, :subject, :proctena, :prijimatelia
	has_many :recipients, dependent: :destroy
	has_many :users, :through => :recipients

	validates_presence_of :prijimatelia, :subject, :body


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

public
def posliPostu(odosielatel, komu, posta)
	prijemci = komu.split(",")

	index = 0
	while index < prijemci.length - 1
		prijemca = prijemci[index]

			prijemca = prijemca[1..prijemca.length] if index >0

		Postum.vytvor_postu(odosielatel,prijemca,posta)
		index += 1
	end
end

def vytvor_postu(odosielatel, komu, posta)
	if self.zistiIdPrijemcu(komu)
	Recipient.new(
			:postum_id => posta.id,
			:user_id => odosielatel.id,
			:prijemca => (self.zistiIdPrijemcu(komu))
	).save
	end
end

def procist(posta)
	posta.update_attribute(:proctena, true)
end


