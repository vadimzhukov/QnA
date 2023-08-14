ThinkingSphinx::Index.define :answer, with: :real_time do
  #fields
  indexes body
  indexes user.email, as: :author, sortable: true

  #attributes
  has user_id, type: :integer
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
end
