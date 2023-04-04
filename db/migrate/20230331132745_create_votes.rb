class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true
      t.belongs_to :user, foreign_key: true, unique: true
      t.boolean :direction, null: false
      t.timestamps
    end
  end
end
