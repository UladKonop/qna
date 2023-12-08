class QuestionsController < ApplicationController
  expose :questions, ->{ Question.all }
  expose :question

  def create
    if question.save
      redirect_to questions_url, notice: 'Question was successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    question.destroy
    redirect_to questions_url, notice: 'Question was successfully destroyed.'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
