require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe "#author_of?" do
    let!(:author) { create(:user) }
    let!(:not_author) { create(:user) }

    let!(:question) { create(:question, user: author) }
    let!(:answer) { create(:answer, user: author) }

    it "author of record" do
      expect(author.author_of?(question)).to be true
      expect(author.author_of?(answer)).to be true
    end

    it "not author of record" do
      expect(not_author.author_of?(question)).to be false
      expect(not_author.author_of?(answer)).to be false
    end
  end

  describe "#reward_user" do
    let!(:author_of_question) { create(:user) }
    let!(:author_of_answer) { create(:user) }

    let(:reward) { create(:reward) }
    let!(:question) { create(:question, user: author_of_question, reward:) }
    let!(:answer) { create(:answer, user: author_of_answer) }

    it "reward author of best answer" do
      expect { author_of_answer.reward_user(question.reward) }.to change(author_of_answer.rewards, :count).by(1)
    end
  end

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    

    context "user exists" do
      context "identity exists" do
        let(:identity) { create(:identity, user: user) }
        let(:auth) { OmniAuth::AuthHash.new(provider: 'gihub', uid: '123', info: { email: 'user@a.com' }) }

        it 'find identity' do
          user.identities.create(provider: auth.provider, uid: auth.uid)
          expect(User.find_for_oauth(auth)).to eq user
        end

        it "creates identity" do 
          
        end
      end
    end

  end
end
