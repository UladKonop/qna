# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }
  
  before do
    login(user)
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns new link for answer' do
      expect(assigns(:exposed_answer).links.first).to be_a_new(Link)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'redirects to the question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to(question)
      end      
    end

    context 'with invalid attributes' do
      it 'does not save a new answer to the DB' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        end.to_not change(Answer, :count)
      end

      it 're-renders the question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template('questions/show')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the answer in the DB' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'Updated Body' } }, format: :js
        answer.reload
        expect(answer.body).to eq('Updated Body')
      end

      it 'redirects to the question show view' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'Updated Body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not update the answer in the DB' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }
        answer.reload
        expect(answer.body).not_to be_nil
      end

      it 're-renders the question show view' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template('questions/show')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'when the user is the author of the answer' do
      before { sign_in(user) }

      it 'deletes the answer from the DB' do
        expect { delete :destroy, params: { question_id: question, id: answer.id } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to the question show view' do
        delete :destroy, params: { question_id: question, id: answer.id }
        expect(response).to redirect_to(question)
      end
    end

    context 'when the user is not the author of the answer' do
      let(:other_user) { create(:user) }
      before { sign_in(other_user) }

      it "doesn't delete the answer from the DB" do
        expect { delete :destroy, params: { question_id: question, id: answer.id } }.not_to change(Answer, :count)
      end

      it "redirects to the question show view" do
        delete :destroy, params: { question_id: question, id: answer.id }
        expect(response).to redirect_to(question)
      end
    end
  end

  describe 'POST #mark_as_best' do
    context 'when the user is the author of the question' do
      before { sign_in(user) }

      it 'marks the answer as the best' do
        post :mark_as_best, params: { question_id: question, id: answer.id }, format: :js

        answer.reload
        expect(answer.best?).to be true
      end

      it 'renders the mark_as_best template' do
        post :mark_as_best, params: { question_id: question, id: answer.id }, format: :js
        expect(response).to render_template :mark_as_best
      end
    end

    context 'when the user is not the author of the question' do
      let(:other_user) { create(:user) }
      before { sign_in(other_user) }

      it 'does not mark the answer as the best' do
        post :mark_as_best, params: { question_id: question, id: answer.id }, format: :js

        answer.reload
        expect(answer.best?).to be false
      end
    end
  end
end
