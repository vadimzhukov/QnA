require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) {Ability.new(user)}

  describe 'for guest' do
    let(:user) { nil }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }
    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :add_comment, Question }
    it { should be_able_to :add_comment, Answer }

    # same user
    it { should be_able_to :edit, create(:question, user: user), user: user }
    it { should be_able_to :edit, create(:answer, user: user), user: user }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should be_able_to :update, create(:answer, user: user), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should be_able_to :destroy, create(:answer, user: user), user: user }

    it { should be_able_to :delete_file, create(:question, user: user), user: user }
    it { should be_able_to :delete_file, create(:answer, user: user), user: user }

    it { should_not be_able_to :like, create(:question, user: user), user: user }
    it { should_not be_able_to :like, create(:answer, user: user), user: user }
    
    it { should_not be_able_to :dislike, create(:question, user: user), user: user }
    it { should_not be_able_to :dislike, create(:answer, user: user), user: user }
    
    it { should_not be_able_to :reset_vote, create(:question, user: user), user: user }
    it { should_not be_able_to :reset_vote, create(:answer, user: user), user: user }

    it { should be_able_to :mark_as_best, create(:answer, question: question, user: other_user), user: user }

    # another user
    it { should_not be_able_to :edit, create(:question, user: other_user), user: user }
    it { should_not be_able_to :edit, create(:answer, user: other_user), user: user }

    it { should_not be_able_to :update, create(:question, user: other_user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other_user), user: user }

    it { should_not be_able_to :destroy, create(:question, user: other_user), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other_user), user: user }

    it { should_not be_able_to :delete_file, create(:question, user: other_user), user: user }
    it { should_not be_able_to :delete_file, create(:answer, user: other_user), user: user }

    it { should be_able_to :like, create(:question, user: other_user), user: user }
    it { should be_able_to :like, create(:answer, user: other_user), user: user }
    
    it { should be_able_to :dislike, create(:question, user: other_user), user: user }
    it { should be_able_to :dislike, create(:answer, user: other_user), user: user }
    
    it { should be_able_to :reset_vote, create(:question, user: other_user), user: user }
    it { should be_able_to :reset_vote, create(:answer, user: other_user), user: user }

    it { should_not be_able_to :mark_as_best, create(:answer, user: other_user), user: user }
  end
end
