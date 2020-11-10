# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

class PasswordResetsController < ApplicationController
  include Emailer

  before_action :disable_password_reset, unless: -> { Rails.configuration.enable_email_verification }
  before_action :find_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  # POST /password_resets/new
  def new
  end

  # POST /password_resets
  def create
    begin
      # Check if user exists and throw an error if he doesn't
      @user = User.find_by!(email: params[:password_reset][:email].downcase, provider: @user_domain)

      send_password_reset_email(@user, @user.create_reset_digest)
      redirect_to root_path
    rescue
      # User doesn't exist
      redirect_to root_path, flash: { success: I18n.t("email_sent", email_type: t("reset_password.subtitle")) }
    end
  end

  # GET /password_resets/:id/edit
  def edit
  end

  # PATCH /password_resets/:id
  def update
    # Check if password is valid
    if params[:user][:password].empty?
      flash.now[:alert] = I18n.t("password_empty_notice")
    elsif params[:user][:password] != params[:user][:password_confirmation]
      # Password does not match password confirmation
      flash.now[:alert] = I18n.t("password_different_notice")
    elsif @user.update_attributes(user_params)
      # Clear the user's social uid if they are switching from a social to a local account
      @user.update_attribute(:social_uid, nil) if @user.social_uid.present?
      # Successfully reset password
      return redirect_to root_path, flash: { success: I18n.t("password_reset_success") }
    end

    render 'edit'
  end

  private

  def find_user
    @user = User.find_by(reset_digest: User.hash_token(params[:id]), provider: @user_domain)

    return redirect_to new_password_reset_url, alert: I18n.t("reset_password.invalid_token") unless @user
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Checks expiration of reset token.
  def check_expiration
    redirect_to new_password_reset_url, alert: I18n.t("expired_reset_token") if @user.password_reset_expired?
  end

  # Redirects to 404 if emails are not enabled
  def disable_password_reset
    redirect_to '/404'
  end
end
