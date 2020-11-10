# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

require "rails_helper"

describe ApplicationHelper do
  describe "#getter functions" do
    it "returns the correct omniauth login url" do
      allow(Rails.configuration).to receive(:relative_url_root).and_return("/b")
      provider = Faker::Company.name

      expect(helper.omniauth_login_url(provider)).to eql("/b/auth/#{provider}")
    end
  end

  describe "role_colur" do
    it "should use default if the user doesn't have a role" do
      expect(helper.role_colour(Role.create(name: "test"))).to eq(Rails.configuration.primary_color_default)
    end

    it "should use role colour if provided" do
      expect(helper.role_colour(Role.create(name: "test", colour: "#1234"))).to eq("#1234")
    end
  end
end
