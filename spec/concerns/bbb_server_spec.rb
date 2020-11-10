# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

require "rails_helper"
require 'bigbluebutton_api'

describe BbbServer do
  include BbbServer

  let(:bbb_server) { BigBlueButton::BigBlueButtonApi.new("http://bbb.example.com/bigbluebutton/api", "secret", "0.8") }

  before do
    @user = create(:user)
    @room = @user.main_room
  end

  context "#running?" do
    it "should return false when not running" do
      expect(room_running?(@room.bbb_id)).to be false
    end

    it "should return true when running" do
      allow_any_instance_of(BigBlueButton::BigBlueButtonApi).to receive(:is_meeting_running?).and_return(true)
      expect(room_running?(@room.bbb_id)).to be true
    end
  end

  context "#start_session" do
    it "should update latest session info" do
      allow_any_instance_of(BigBlueButton::BigBlueButtonApi).to receive(:create_meeting).and_return(
        messageKey: ""
      )

      expect do
        start_session(@room)
      end.to change { @room.sessions }.by(1)

      expect(@room.last_session).not_to be nil
    end
  end

  context "#join_path" do
    it "should return correct join URL for user" do
      allow_any_instance_of(BigBlueButton::BigBlueButtonApi).to receive(:get_meeting_info).and_return(
        attendeePW: @room.attendee_pw
      )

      endpoint = Rails.configuration.bigbluebutton_endpoint
      secret = Rails.configuration.bigbluebutton_secret
      fullname = "fullName=Example"
      join_via_html5 = "&join_via_html5=true"
      meeting_id = "&meetingID=#{@room.bbb_id}"
      password = "&password=#{@room.attendee_pw}"

      query = fullname + join_via_html5 + meeting_id + password
      checksum_string = "join#{query + secret}"

      checksum = OpenSSL::Digest.digest('sha1', checksum_string).unpack1("H*")
      expect(join_path(@room, "Example")).to eql("#{endpoint}join?#{query}&checksum=#{checksum}")
    end
  end

  context "#recordings" do
    it "deletes the recording" do
      allow_any_instance_of(BigBlueButton::BigBlueButtonApi).to receive(:delete_recordings).and_return(
        returncode: true, deleted: true
      )

      expect(delete_recording(Faker::IDNumber.valid))
        .to contain_exactly([:returncode, true], [:deleted, true])
    end
  end
end
