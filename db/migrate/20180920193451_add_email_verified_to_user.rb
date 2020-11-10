# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

class AddEmailVerifiedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_verified, :boolean, default: false
  end
end
