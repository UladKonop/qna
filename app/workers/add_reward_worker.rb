# frozen_string_literal: true

class AddRewardWorker
  include Sidekiq::Worker

  def perform(answer_user_id, answer_question_id)
    user = User.find(answer_user_id)
    reward = Question.find(answer_question_id).reward

    user.rewards.create!(title: reward.title, question_title: reward.question_title, image: reward.image.blob)
  end
end
