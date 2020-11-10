# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

class AddIndexToUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :email
    add_index :users, :provider
    add_index :users, :created_at
  end
end
