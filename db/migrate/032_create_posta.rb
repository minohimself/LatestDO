class CreatePosta < ActiveRecord::Migration
  def change
    create_table :posta do |t|
      t.string :body
      t.string :subject
      t.string :prijimatelia
      t.boolean :proctena

      t.timestamps
    end
  end
end
