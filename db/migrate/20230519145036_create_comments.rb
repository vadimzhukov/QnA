class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true
      t.belongs_to :user, foreign_key: true, unique: true
      t.text :body, null: false
      t.timestamps
    end
  end
end
