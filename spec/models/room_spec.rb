# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

require "rails_helper"
require 'bigbluebutton_api'

describe Room, type: :model do
  before do
    @user = create(:user)
    @room = @user.main_room
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end

  context 'associations' do
    it { should belong_to(:owner).class_name("User").with_foreign_key("user_id") }
  end

  context '#setup' do
    it 'creates random uid and bbb_id' do
      expect(@room.uid).to_not be_nil
      expect(@room.bbb_id).to_not be_nil
    end
  end

  context "#to_param" do
    it "uses uid as the default identifier for routes" do
      expect(@room.to_param).to eq(@room.uid)
    end
  end

  context "#invite_path" do
    it "should have correct invite path" do
      expect(@room.invite_path).to eq("/#{@room.uid}")
    end
  end

  context "#owned_by?" do
    it "should return true for correct owner" do
      expect(@room.owned_by?(@user)).to be true
    end

    it "should return false for incorrect owner" do
      expect(@room.owned_by?(create(:user))).to be false
    end
  end
end
