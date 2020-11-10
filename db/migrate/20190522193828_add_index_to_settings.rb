# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

class AddIndexToSettings < ActiveRecord::Migration[5.0]
  def change
    add_index :settings, :provider
  end
end
