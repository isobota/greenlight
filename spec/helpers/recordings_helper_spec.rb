# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

require "rails_helper"

describe RecordingsHelper do
  describe "#recording_date" do
    it "formats the date" do
      date = DateTime.parse("2019-03-28 19:35:15 UTC")
      expect(helper.recording_date(date)).to eql("March 28, 2019")
    end
  end

  describe "#recording_length" do
    it "returns the time if length > 60" do
      playbacks = [{ type: "test", length: 85 }]
      expect(helper.recording_length(playbacks)).to eql("1 h 25 min")
    end

    it "returns the time if length == 0" do
      playbacks = [{ type: "test", length: 0 }]
      expect(helper.recording_length(playbacks)).to eql("< 1 min")
    end

    it "returns the time if length between 0 and 60" do
      playbacks = [{ type: "test", length: 45 }]
      expect(helper.recording_length(playbacks)).to eql("45 min")
    end
  end
end
