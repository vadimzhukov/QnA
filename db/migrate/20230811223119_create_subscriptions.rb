class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.references :subscriptable, polymorphic: true
      t.belongs_to :user, foreign_key: true, unique: true
      t.timestamps
    end
    add_index :subscriptions, [:subscriptable_type, :subscriptable_id, :user_id], unique: true, name: "subscription_index"
  end
end
