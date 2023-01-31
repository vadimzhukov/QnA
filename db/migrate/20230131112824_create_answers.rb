class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.belongs_to :question
      t.text :body
      t.timestamps
    end
  end
end
