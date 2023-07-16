require 'rails_helper'

RSpec.describe EmailRegistration, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :confirmation_token } 
end
