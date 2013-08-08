class Conversation < ActiveRecord::Base
	attr_accessible :message_id, :sender, :recipient, :deleted_by
	belongs_to :message

end
