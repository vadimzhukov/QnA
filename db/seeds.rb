# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


Question.first.answers.each do |answer|
  15.times do |n|
    answer.comments.create(body: "Comment #{n} for answer #{answer.id}", user_id: 1)
  end
end
