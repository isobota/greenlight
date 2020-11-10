# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

class AddIndexToFeatures < ActiveRecord::Migration[5.0]
  def change
    add_index :features, :name
  end
end
