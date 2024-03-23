# frozen_string_literal: true

class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "question_#{params['question_id']}_comments" if params['question_id'].present?
    stream_from "answer_#{params['answer_id']}_comments" if params['answer_id'].present?
  end
end
