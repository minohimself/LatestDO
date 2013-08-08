class Recipient < ActiveRecord::Base
	attr_accessible :postum_id, :user_id, :prijemca
	belongs_to :postum
	belongs_to :users
end
