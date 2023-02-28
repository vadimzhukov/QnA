require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: question } }

    it 'assigns a new Answer to @answer of @question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: answer, question_id: question } }

    it 'assigns the requested answer to @answer of @question' do
      expect(assigns(:answer)).to eq answer
    end
  end

  describe 'POST #create' do
    before { login(user) }
    
    context 'valid answer parameters' do
      it 'adds answer to database'  do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id }, format: :js }.to change(Answer, :count).by(1), format: :js
      end

      it 'renders create template' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id }, format: :js }.to change(Answer, :count).by(1), format: :js
        expect(response).to render_template :create
      end
    end

    context 'invalid answer parameters' do
      it 'doesnt add answer to database' do
        expect do
          post :create,
               params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js
        end.not_to change(Answer, :count)
      end

      it 'renders create template' do
        post :create,
               params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'valid parameters to update' do
      it 'assigns edited answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes attributes in DB' do
        patch :update,
              params: { id: answer, question_id: question, answer: { body: "The right answer", correct: true } }, format: :js
        answer.reload

        expect(answer.body).to eq "The right answer"
        expect(answer.correct).to eq true
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'invalid parameters to update' do
      it 'doesnt change attributes in DB' do
        initial_answer = answer
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        answer.reload
        expect(answer.body).to eq initial_answer.body
        expect(answer.correct).to eq initial_answer.correct
      end

      it 'renders update view' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    # let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }

    before { login(user) }

    it 'deletes @answer form DB' do
      expect { delete :destroy, params: { id: answer, question_id: question.id }, format: :js }.to change(Answer, :count).by(-1)
    end
  end
end
