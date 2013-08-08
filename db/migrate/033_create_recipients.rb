class CreateRecipients < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
	    t.integer :user_id
	    t.integer :postum_id
	    t.integer :prijemca

      t.timestamps
    end
  end
end
