# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

class WaitingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{params[:roomuid]}_waiting_channel"
  end
end
