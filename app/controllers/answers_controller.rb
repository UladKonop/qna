# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action -> { authorize_user(answer, answer.question) }, only: %i[edit destroy]
  before_action -> { authorize_user(question, question) }, only: [:mark_as_best]

  expose :question
  expose :answer, find: ->(id, scope) { scope.with_attached_files.find(id) }
  expose :comments, -> { answer.comments }

  def show
    answer.links.new
    answer.comments.new
  end

  def create
    answer = question.answers.new(answer_params)
    answer.user = current_user

    respond_to do |format|
      if answer.save
        format.html { render answer }
      else
        format.html { render partial: 'shared/errors', resource: answer }
      end
      format.js do
        @answer = answer
        publish_answer
      end
    end
  end

  def update
    respond_to do |format|
      if answer.update(answer_params)
        format.html { redirect_to question, notice: 'Answer was successfully updated.' }
      else
        format.html { render 'questions/show' }
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if answer.destroy
        format.html { redirect_to question, notice: 'Answer was successfully destroyed.' }
      else
        format.html { render 'questions/show' }
      end
      format.js
    end
  end

  def mark_as_best
    respond_to do |format|
      if answer.mark_as_best
        format.html { render 'questions/show' }
        format.js { AddRewardWorker.perform_async(answer.user.id, answer.question.id) }
      end
    end
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{question.id}_answers",
      ApplicationController.render(
        partial: 'answers/answer_simplified',
        locals: { answer: @answer, question: question }
      )
    )
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
