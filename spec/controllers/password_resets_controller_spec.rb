# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

require "rails_helper"

def random_valid_user_params
  pass = Faker::Internet.password(min_length: 8)
  {
    user: {
      name: Faker::Name.first_name,
      email: Faker::Internet.email,
      password: pass,
      password_confirmation: pass,
      accepted_terms: true,
      email_verified: true,
    },
  }
end

describe PasswordResetsController, type: :controller do
  describe "POST #create" do
    context "allow mail notifications" do
      before { allow(Rails.configuration).to receive(:enable_email_verification).and_return(true) }

      it "redirects to root url if email is sent" do
        user = create(:user)

        params = {
          password_reset: {
            email: user.email,
          },
        }

        post :create, params: params
        expect(response).to redirect_to(root_path)
      end

      it "redirects to root with success flash if email does not exists" do
        params = {
          password_reset: {
            email: nil,
          },
        }

        post :create, params: params
        expect(flash[:success]).to be_present
        expect(response).to redirect_to(root_path)
      end
    end

    context "does not allow mail notifications" do
      before { allow(Rails.configuration).to receive(:enable_email_verification).and_return(false) }

      it "renders a 404 page upon if email notifications are disabled" do
        get :create
        expect(response).to redirect_to("/404")
      end
    end
  end

  describe "PATCH #update" do
    before do
      allow(Rails.configuration).to receive(:enable_email_verification).and_return(true)
      @user = create(:user, provider: "greenlight")
    end

    context "valid user" do
      it "reloads page with notice if password is empty" do
        token = @user.create_reset_digest
        allow(controller).to receive(:check_expiration).and_return(nil)

        params = {
          id: token,
          user: {
            password: nil,
          },
        }

        patch :update, params: params
        expect(response).to render_template(:edit)
      end

      it "reloads page with notice if password is confirmation doesn't match" do
        token = @user.create_reset_digest

        allow(controller).to receive(:check_expiration).and_return(nil)

        params = {
          id: token,
          user: {
            password: :password,
            password_confirmation: nil,
          },
        }

        patch :update, params: params
        expect(response).to render_template(:edit)
      end

      it "updates attributes if the password update is a success" do
        user = create(:user, provider: "greenlight")
        old_digest = user.password_digest

        allow(controller).to receive(:check_expiration).and_return(nil)

        params = {
          id: user.create_reset_digest,
          user: {
            password: :password,
            password_confirmation: :password,
          },
        }

        patch :update, params: params

        user.reload

        expect(old_digest.eql?(user.password_digest)).to be false
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
