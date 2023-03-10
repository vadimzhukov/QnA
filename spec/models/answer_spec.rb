require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should have_many :links }
  it { should accept_nested_attributes_for(:links).allow_destroy(true) }
  
  it { should validate_presence_of :body }

  it "Has attached many files" do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
