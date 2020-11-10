# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

require "rails_helper"

describe Role, type: :model do
    it "should return duplicate if role name is in reserved role names" do
        expect(Role.duplicate_name("admin", "greenlight")).to eq(true)
    end

    it "should return duplicate if role name matched another" do
        Role.create(name: "test", provider: "greenlight")
        expect(Role.duplicate_name("test", "greenlight")).to eq(true)
    end

    it "should return false role name doesn't exist" do
        Role.create(name: "test", provider: "greenlight")
        expect(Role.duplicate_name("test1", "greenlight")).to eq(false)
    end
end
