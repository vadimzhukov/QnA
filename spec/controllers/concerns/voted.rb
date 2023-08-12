require "rails_helper"

shared_examples_for 'voted' do
  let(:user_author) { create(:user) }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:votable) { create(described_class.controller_name.classify.constantize.name.downcase.to_sym, user: user_author) }

  describe '#like' do
    context 'when user has not voted yet' do
      before do
        sign_in user
      end

      it 'creates a vote' do
        patch :like, params: { id: votable.id, format: :json }
        expect(votable.votes_sum).to eq(1)
      end

      it 'returns JSON with the votable ID, votes sum, votes sum by current user 1' do
        patch :like, params: { id: votable.id, format: :json }
        expect(response.body).to eq({ id: votable.id, votes_sum: 1, votes_sum_by_user: 1
                                      }.to_json)
      end
    end

    context 'when user has already voted' do
      before do
        sign_in user
        patch :like, params: { id: votable.id, format: :json }
      end

      it 'does not create a new vote' do
        patch :like, params: { id: votable.id, format: :json }
        expect(votable.votes_sum).to eq(1)
      end
    end
  end

  describe '#dislike' do
    context 'when user has not voted yet' do
      before do
        sign_in user
      end

      it 'creates a vote' do
        patch :dislike, params: { id: votable.id, format: :json }
        expect(votable.votes_sum).to eq(-1)
      end

      it 'returns JSON with the votable ID, votes sum, votes sum by current user -1' do
        patch :dislike, params: { id: votable.id, format: :json }
        expect(response.body).to eq({ id: votable.id, votes_sum: -1, votes_sum_by_user: -1 }.to_json)
      end
    end

    context 'when user has already voted' do
      before do
        sign_in user
        patch :dislike, params: { id: votable.id, format: :json }
      end

      it 'does not create a new vote' do
        patch :dislike, params: { id: votable.id, format: :json }
        expect(votable.votes_sum).to eq(-1)
      end
    end
  end

  describe '#reset_vote' do
    context 'when user has not voted yet' do
      before do
        sign_in user
      end

      it 'try to reset a vote' do
        patch :reset_vote, params: { id: votable.id, format: :json }
        expect(votable.votes_sum).to eq(0)
      end
    end

    context 'when user has already voted' do
      before do
        sign_in user
        patch :like, params: { id: votable.id, format: :json }
      end

      it 'resets the vote' do
        patch :reset_vote, params: { id: votable.id, format: :json }
        expect(votable.votes_sum).to eq(0)
      end

      it 'return JSON with the votable ID, votes sum, votes sum by current user 0' do
        patch :reset_vote, params: { id: votable.id, format: :json }
        expect(response.body).to eq({ id: votable.id, votes_sum: 0, votes_sum_by_user: 0 }.to_json)
      end
    end
  end
end
