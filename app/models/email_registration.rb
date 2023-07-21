class EmailRegistration < ApplicationRecord
  validates :email, :confirmation_token, presence: true
end
