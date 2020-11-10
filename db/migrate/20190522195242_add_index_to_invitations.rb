# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

class AddIndexToInvitations < ActiveRecord::Migration[5.0]
  def change
    add_index :invitations, :invite_token
    add_index :invitations, :provider
  end
end
