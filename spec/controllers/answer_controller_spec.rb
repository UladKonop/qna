# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

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
        patch :update, params: { question_id: question, id: answer, answer: { body: 'Updated Body' } }
        answer.reload
        expect(answer.body).to eq('Updated Body')
      end

      it 'redirects to the question show view' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'Updated Body' } }
        expect(response).to redirect_to(question)
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
    let!(:answer) { create(:answer, question: question) }

    it 'deletes the answer from the DB' do
      expect { delete :destroy, params: { question_id: question, id: answer.id } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to the question show view' do
      delete :destroy, params: { question_id: question, id: answer.id }
      expect(response).to redirect_to(question)
    end
  end
end
