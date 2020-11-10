# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def to_param
    uid
  end
end
