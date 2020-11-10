# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

require "rails_helper"

describe ErrorsController, type: :controller do
  describe "GET #not_found" do
    it "returns not_found" do
      get :not_found
      expect(response).to have_http_status(404)
    end
  end

  describe "GET #internal_error" do
    it "returns internal_error" do
      get :internal_error
      expect(response).to have_http_status(500)
    end
  end

  describe "GET #unauthorized" do
    it "returns unauthorized" do
      get :unauthorized
      expect(response).to have_http_status(401)
    end
  end
end
