# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

class MainController < ApplicationController
  include Registrar
  # GET /
  def index
    # Store invite token
    session[:invite_token] = params[:invite_token] if params[:invite_token] && invite_registration

    redirect_to home_page if current_user
  end
end
