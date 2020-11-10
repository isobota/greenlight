# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

require "rails_helper"

describe ThemesController, type: :controller do
  context "GET #index" do
    before do
      @user = create(:user)
    end

    it "responds with css file" do
      @request.session[:user_id] = @user.id

      get :index, format: :css

      expect(response.content_type).to eq("text/css")
    end
  end

  context "CSS file creation" do
    before do
      @fake_color = Faker::Color.hex_color
      allow(Rails.configuration).to receive(:primary_color_default).and_return(@fake_color)
    end

    it "returns the correct color based on provider" do
      allow(Rails.configuration).to receive(:loadbalanced_configuration).and_return(true)
      allow_any_instance_of(User).to receive(:greenlight_account?).and_return(true)
      allow_any_instance_of(ApplicationController).to receive(:set_user_domain).and_return("provider1")

      color1 = Faker::Color.hex_color
      provider1 = Faker::Company.name

      controller.instance_variable_set(:@user_domain, provider1)

      Setting.create(provider: provider1).features.create(name: "Primary Color", value: color1, enabled: true)
      user1 = create(:user, provider: provider1)

      @request.session[:user_id] = user1.id

      get :index, format: :css

      expect(response.content_type).to eq("text/css")
      expect(response.body).to include(color1)
    end

    it "uses the default color option" do
      provider1 = Faker::Company.name
      user1 = create(:user, provider: provider1)

      @request.session[:user_id] = user1.id

      get :index, format: :css

      expect(response.content_type).to eq("text/css")
      expect(response.body).to include(@fake_color)
    end
  end
end
