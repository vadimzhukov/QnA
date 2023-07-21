class CreateEmailRegistrations < ActiveRecord::Migration[6.1]
  def change
    create_table :email_registrations do |t|
      t.string :email
      t.string :oauth_provider
      t.string :oauth_uid
      t.boolean :confirmed, null:false, default: false
      t.string :confirmation_token, null:false, unique: true
      t.datetime :confirmed_at

      t.timestamps
    end
    add_index :email_registrations, :email, unique: true
  end
end
