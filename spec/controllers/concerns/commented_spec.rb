require "rails_helper"

shared_examples_for 'commented' do
  controller_name = described_class.controller_name.classify.constantize.name.downcase.to_sym
  let(:user_author) { create(:user) }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:commentable) { create(controller_name, user: user_author) }

  describe '#add_comment' do
    context "comment it" do
      before do
        sign_in user_author
      end

      it 'creates a comment' do
        patch :add_comment, params: { id: commentable.id, user_id: user_author.id, body: "Test comment", format: :json }
        expect(commentable.comments.count).to eq(1)
      end

      it 'returns JSON message and comment content (body, date, author)' do
        patch :add_comment, params: { id: commentable.id, user_id: user_author.id, body: "Test comment", format: :json }
        expect(response.body).to eq({ status: 200,
                                      body: {
                                        message: "Comment was successfully added to #{controller_name} with id #{commentable.id}", 
                                        comment: {
                                        body: "Test comment", 
                                        author_email: user_author.email, 
                                        comment_date_time: commentable.comments.last.created_at,
                                        }
                                      }
                                    }.to_json)
      end
    end
  end
end
