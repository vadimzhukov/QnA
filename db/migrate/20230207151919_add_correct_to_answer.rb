class AddCorrectToAnswer < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :correct, :boolean, null: false, default: false
  end
end
