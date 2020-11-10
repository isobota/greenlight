# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

class AddLanguageToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :language, :string, default: 'default'
  end
end
