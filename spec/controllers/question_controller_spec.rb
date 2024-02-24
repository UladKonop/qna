# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before do
    login(user)
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns new answer for question' do
      expect(assigns(:exposed_answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:exposed_answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Question to question' do
      expect(assigns(:exposed_question)).to be_a_new(Question)
    end

    it 'assigns a new Question to question' do
      expect(assigns(:exposed_question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    it 'renders show edit' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new question to the DB' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.not_to change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the question in the DB' do
        patch :update, params: { id: question, question: { title: 'New Title' } }
        question.reload
        expect(question.title).to eq('New Title')
      end

      it 'redirects to show view' do
        patch :update, params: { id: question, question: { title: 'New Title' } }
        expect(response).to redirect_to(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not update the question in the DB' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }
        question.reload
        expect(question.title).not_to be_nil
      end

      it 're-renders edit view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    context 'when the user is the author of the question' do
      before { sign_in(question.user) }

      it 'deletes the question from the DB' do
        expect do
          delete :destroy, params: { id: question.id }
        end.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to(questions_path)
      end
    end

    context 'when the user is not the author of the question' do
      let(:other_user) { create(:user) }

      before { sign_in(other_user) }

      it "doesn't delete the question from the DB" do
        expect do
          delete :destroy, params: { id: question.id }
        end.not_to change(Question, :count)
      end

      it 'redirects to question view' do
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to(question_path(question.id))
      end
    end
  end
end
