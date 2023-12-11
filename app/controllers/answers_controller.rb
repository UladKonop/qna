class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_user, only: [:edit, :destroy]

  expose :question
  expose :answer

  def create
    answer = question.answers.build(answer_params)
    answer.user = current_user

    if answer.save
      redirect_to question, notice: 'Answer was successfully created.'
    else
      @new_answer = answer
      render 'questions/show'
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to question, notice: 'Answer was successfully updated.'
    else
      render 'questions/show'
    end
  end

  def destroy
    answer.destroy
    redirect_to question, notice: 'Answer was successfully destroyed.'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def authorize_user
    super(answer, answer.question)
  end
end
