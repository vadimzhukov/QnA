class AddCorrectToAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :correct, :boolean, null: false, default: false
  end
end
