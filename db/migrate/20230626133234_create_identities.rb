class CreateIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :identities do |t|
      t.string :provider
      t.string :uid
      t.belongs_to :user

      t.timestamps
    end
  end
end
