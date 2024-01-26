class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action -> { authorize_user(answer, answer.question) }, only: [:edit, :destroy]
  before_action -> { authorize_user(question, question) }, only: [:mark_as_best]

  expose :question
  expose :answer, find: ->(id, scope){ scope.with_attached_files.find(id) }

  def create
    answer = question.answers.build(answer_params)
    answer.user = current_user

    respond_to do |format|
      if answer.save
        format.html { redirect_to question, notice: 'Answer was successfully created.' }
        format.js { @new_answer = answer }
      else
        format.html { render 'questions/show' }
        format.js { @new_answer = answer }
      end
    end
  end

  def update
    respond_to do |format|
      if answer.update(answer_params)
        format.html { redirect_to question, notice: 'Answer was successfully updated.' }
        format.js
      else
        format.html { render 'questions/show' }
        format.js
      end
    end
  end

  def destroy
    respond_to do |format|
      if answer.destroy
        format.html { redirect_to question, notice: 'Answer was successfully destroyed.' }
        format.js
      else
        format.html { render 'questions/show' }
        format.js
      end
    end
  end

  def mark_as_best
    respond_to do |format|
      if answer.mark_as_best
        format.html { render 'questions/show' }
        format.js
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
