class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_user, only: [:edit, :destroy]

  expose :question
  expose :questions, ->{ Question.all }
  expose :answers, -> { question.answers.sort_by_best }

  def create
    question.user = current_user

    if question.save
      redirect_to question, notice: 'Question was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      redirect_to question, notice: 'Question was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    question.destroy

    redirect_to questions_path, notice: 'Question was successfully destroyed.'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def authorize_user
    super(question, question)
  end
end
