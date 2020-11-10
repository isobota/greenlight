# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.belongs_to :user, index: true
      t.string :name, index: true
      t.string :uid, index: true
      t.string :bbb_id, index: true
      t.integer :sessions, index: true, default: 0
      t.datetime :last_session, index: true

      t.timestamps
    end
  end
end
