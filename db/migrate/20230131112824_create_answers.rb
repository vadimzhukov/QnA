class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.belongs_to :question
      t.text :body
      t.timestamps
    end
  end
end
