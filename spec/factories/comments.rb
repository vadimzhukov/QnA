FactoryBot.define do
  factory :comment do
    
  end

  factory :comment_on_question, class: Comment do
    body { "this is a comment on question" }
    user
    association :commentable, factory: :question
  end

  factory :comment_on_answer, class: Comment do
    body { "this is a comment on answer" }
    user
    association :commentable, factory: :answer
  end
end
