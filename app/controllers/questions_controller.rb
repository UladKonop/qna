class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action -> { authorize_user(question, question) }, only: [:edit, :destroy]

  expose :question, find: ->(id, scope){ scope.with_attached_files.find(id) }
  expose :questions, ->{ Question.all }
  expose :answer, ->{ question.answers.new }
  expose :answers, -> { question.answers.sort_by_best }

  def show
    answer.links.new
  end

  def new
    question.links.new
  end

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
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:id, :title, :question_title, :image, :_destroy])
  end
end
