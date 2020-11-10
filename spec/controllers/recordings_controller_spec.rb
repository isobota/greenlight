# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

require "rails_helper"

describe RecordingsController, type: :controller do
  before do
    @user = create(:user)
    @room = @user.main_room
    @secondary_user = create(:user)
  end

  context "POST #update_recording" do
    it "updates the recordings details" do
      allow_any_instance_of(BbbServer).to receive(:update_recording).and_return(updated: true)
      @request.session[:user_id] = @user.uid

      post :update, params: { meetingID: @room.bbb_id, record_id: Faker::IDNumber.valid, state: "public" }

      expect(response).to have_http_status(302)
    end

    it "redirects to root if not the room owner" do
      @request.session[:user_id] = @secondary_user.uid

      post :update, params: { meetingID: @room.bbb_id, record_id: Faker::IDNumber.valid, state: "public" }

      expect(response).to redirect_to(root_path)
    end
  end

  context "PATCH #rename" do
    it "properly updates recording name and redirects to current page" do
      allow_any_instance_of(BbbServer).to receive(:update_recording).and_return(updated: true)

      @request.session[:user_id] = @user.id
      name = Faker::Games::Pokemon.name

      patch :rename, params: { meetingID: @room.bbb_id, record_id: Faker::IDNumber.valid, record_name: name }

      expect(response).to redirect_to(@room)
    end
  end

  context "DELETE #delete_recording" do
    it "deletes the recording" do
      allow_any_instance_of(BbbServer).to receive(:delete_recording).and_return(true)
      @request.session[:user_id] = @user.uid

      post :delete, params: { meetingID: @room.bbb_id, record_id: Faker::IDNumber.valid, state: "public" }

      expect(response).to have_http_status(302)
    end

    it "redirects to root if not the room owner" do
      @request.session[:user_id] = @secondary_user.uid

      post :delete, params: { meetingID: @room.bbb_id, record_id: Faker::IDNumber.valid, state: "public" }

      expect(response).to redirect_to(root_path)
    end
  end
end
