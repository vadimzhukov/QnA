require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #show' do
    before { get :show, params: { id: answer, question_id: question } }

    it 'assigns the requested answer to @answer of @question' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders the show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns a new Answer to @answer of @question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders the new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer, question_id: question } }

    it 'assigns the requested answer to @answer of @question' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders the edit view' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'valid answer parameters' do
      it 'adds answer to database' do
        expect do
          post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        end.to change(Answer, :count).by(1)
      end

      it 'redirects to @question' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'invalid answer parameters' do
      it 'doesnt add answer to database' do
        expect do
          post :create,
               params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        end.not_to change(Answer, :count)
      end

      it 'renders the new view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid parameters to update' do
      it 'assigns edited answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes attributes in DB' do
        patch :update,
              params: { id: answer, question_id: question, answer: { body: "The right answer", correct: true } }
        answer.reload

        expect(answer.body).to eq "The right answer"
        expect(answer.correct).to eq true
      end

      it 'redirects to show view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }

        expect(response).to redirect_to answer_path(id: assigns(:answer).id)
      end
    end

    context 'invalid parameters to update' do
      it 'doesnt change attributes in DB' do
        initial_answer = answer
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer, :invalid) }
        answer.reload
        expect(answer.body).to eq initial_answer.body
        expect(answer.correct).to eq initial_answer.correct
      end

      it 'redirects to edit' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer) }

    it 'deletes @answer form DB' do
      expect { delete :destroy, params: { id: answer, question_id: question.id } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to @question' do
      delete :destroy, params: { id: answer, question_id: question.id }
      expect(response).to redirect_to question_path(id: question.id)
    end
  end
end
