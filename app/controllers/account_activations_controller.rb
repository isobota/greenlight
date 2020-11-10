# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

class AccountActivationsController < ApplicationController
  include Emailer

  before_action :ensure_unauthenticated
  before_action :find_user

  # GET /account_activations
  def show
  end

  # GET /account_activations/edit
  def edit
    # If the user exists and is not verified and provided the correct token
    if @user && !@user.activated?
      # Verify user
      @user.activate

      # Redirect user to root with account pending flash if account is still pending
      return redirect_to root_path,
        flash: { success: I18n.t("registration.approval.signup") } if @user.has_role?(:pending)

      # Redirect user to sign in path with success flash
      redirect_to signin_path, flash: { success: I18n.t("verify.activated") + " " + I18n.t("verify.signin") }
    else
      redirect_to root_path, flash: { alert: I18n.t("verify.invalid") }
    end
  end

  # POST /account_activations/resend
  def resend
    if @user.activated?
      # User is already verified
      flash[:alert] = I18n.t("verify.already_verified")
    else
      # Resend
      send_activation_email(@user, @user.create_activation_token)
    end

    redirect_to root_path
  end

  private

  def find_user
    digest = if params[:token].present?
      User.hash_token(params[:token])
    elsif params[:digest].present?
      params[:digest]
    else
      raise "Missing token/digest params"
    end

    @user = User.find_by!(activation_digest: digest, provider: @user_domain)
  end

  def ensure_unauthenticated
    redirect_to current_user.main_room if current_user
  end
end
