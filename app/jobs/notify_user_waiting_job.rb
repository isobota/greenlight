# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

class NotifyUserWaitingJob < ApplicationJob
  queue_as :default

  def perform(room)
    room.notify_waiting
  end
end
