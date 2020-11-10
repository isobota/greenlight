# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

require "rails_helper"

describe MainController, type: :controller do
  describe "GET #index" do
    it "returns success" do
      get :index
      expect(response).to be_successful
    end

    it "redirects signed in user to their home page" do
      user = create(:user)
      @request.session[:user_id] = user.id

      get :index

      expect(response).to redirect_to(user.main_room)
    end
  end
end
