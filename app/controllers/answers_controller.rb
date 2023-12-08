class AnswersController < ApplicationController
    expose :question
    expose :answer

    def create
      if answer.save
        redirect_to question, notice: 'Answer was successfully created.'
      else
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
      params.require(:answer).permit(:body).merge(question_params)
    end
    
    def question_params
      params.permit(:question_id)
    end
  end
