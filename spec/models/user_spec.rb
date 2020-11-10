# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

require "rails_helper"
require 'bigbluebutton_api'

describe User, type: :model do
  before do
    @user = create(:user)
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(256) }
    it { should_not allow_value("https://www.bigbluebutton.org").for(:name) }

    it { should validate_presence_of(:provider) }

    it { should validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }
    it { should validate_length_of(:email).is_at_most(256) }
    it { should allow_value("valid@email.com").for(:email) }
    it { should_not allow_value("invalid_email").for(:email) }
    it { should allow_value(true).for(:accepted_terms) }
    it { should allow_value(false).for(:accepted_terms) }

    it { should allow_value("valid.jpg").for(:image) }
    it { should allow_value("valid.png").for(:image) }
    it { should allow_value("random_file.txt").for(:image) }
    it { should allow_value("", nil).for(:image) }

    it "should convert email to downcase on save" do
      user = create(:user, email: "DOWNCASE@DOWNCASE.COM")
      expect(user.email).to eq("downcase@downcase.com")
    end

    context 'is greenlight account' do
      before { allow(subject).to receive(:greenlight_account?).and_return(true) }
      it { should validate_length_of(:password).is_at_least(6) }
    end

    context 'is not greenlight account' do
      before { allow(subject).to receive(:greenlight_account?).and_return(false) }
      it { should_not validate_presence_of(:password) }
    end
  end

  context 'associations' do
    it { should belong_to(:main_room).class_name("Room").with_foreign_key("room_id") }
    it { should have_many(:rooms) }
  end

  context '#initialize_main_room' do
    it 'creates random uid and main_room' do
      expect(@user.uid).to_not be_nil
      expect(@user.main_room).to be_a(Room)
    end
  end

  context "#to_param" do
    it "uses uid as the default identifier for routes" do
      expect(@user.to_param).to eq(@user.uid)
    end
  end

  unless Rails.configuration.omniauth_bn_launcher
    context '#from_omniauth' do
      let(:auth) do
        {
          "uid" => "123456789",
          "provider" => "twitter",
          "info" => {
            "name" => "Test Name",
            "nickname" => "username",
            "email" => "test@example.com",
            "image" => "example.png",
          },
        }
      end

      it "should create user from omniauth" do
        expect do
          user = User.from_omniauth(auth)

          expect(user.name).to eq("Test Name")
          expect(user.email).to eq("test@example.com")
          expect(user.image).to eq("example.png")
          expect(user.provider).to eq("twitter")
          expect(user.social_uid).to eq("123456789")
        end.to change { User.count }.by(1)
      end
    end
  end

  context '#name_chunk' do
    it 'properly finds the first three characters of the users name' do
      user = create(:user, name: "Example User")
      expect(user.name_chunk).to eq("exa")
    end
  end

  context '#ordered_rooms' do
    it 'correctly orders the users rooms' do
      user = create(:user)
      room1 = create(:room, owner: user)
      room2 = create(:room, owner: user)
      room3 = create(:room, owner: user)
      room4 = create(:room, owner: user)

      room4.update_attributes(sessions: 1, last_session: "2020-02-24 19:52:57")
      room3.update_attributes(sessions: 1, last_session: "2020-01-25 19:52:57")
      room2.update_attributes(sessions: 1, last_session: "2019-09-05 19:52:57")
      room1.update_attributes(sessions: 1, last_session: "2015-02-24 19:52:57")

      rooms = user.ordered_rooms
      expect(rooms[0]).to eq(user.main_room)
      expect(rooms[1]).to eq(room4)
      expect(rooms[2]).to eq(room3)
      expect(rooms[3]).to eq(room2)
      expect(rooms[4]).to eq(room1)
    end
  end

  context 'password reset' do
    it 'creates token and respective reset digest' do
      user = create(:user)

      expect(user.create_reset_digest).to be_truthy
    end

    it 'correctly verifies the token' do
      user = create(:user)
      token = user.create_reset_digest
      expect(User.exists?(reset_digest: User.hash_token(token))).to be true
    end

    it 'verifies if password reset link expired' do
      user = create(:user)
      user.create_reset_digest

      expired = user.password_reset_expired?
      expect(expired).to be_in([true, false])
    end
  end

  context '#roles' do
    it "defaults the user to a user role" do
      expect(@user.has_role?(:user)).to be true
    end

    it "does not give the user an admin role" do
      expect(@user.has_role?(:admin)).to be false
    end

    it "returns true if the user is an admin of another" do
      allow(Rails.configuration).to receive(:loadbalanced_configuration).and_return(true)
      allow_any_instance_of(User).to receive(:greenlight_account?).and_return(true)

      @admin = create(:user, provider: @user.provider)
      @admin.set_role :admin

      expect(@admin.admin_of?(@user, "can_manage_users")).to be true

      @super_admin = create(:user, provider: "test")
      @super_admin.set_role :super_admin

      expect(@super_admin.admin_of?(@user, "can_manage_users")).to be true
    end

    it "returns false if the user is NOT an admin of another" do
      @admin = create(:user)

      expect(@admin.admin_of?(@user, "can_manage_users")).to be false
    end

    it "should get the highest priority role" do
      @admin = create(:user, provider: @user.provider)
      @admin.set_role :admin

      expect(@admin.role.name).to eq("admin")
    end

    it "should add the role if the user doesn't already have the role" do
      @admin = create(:user, provider: @user.provider)
      @admin.set_role :admin

      expect(@admin.has_role?(:admin)).to eq(true)
    end

    it "has_role? should return false if the user doesn't have the role" do
      expect(@user.has_role?(:admin)).to eq(false)
    end

    it "has_role? should return true if the user has the role" do
      @admin = create(:user, provider: @user.provider)
      @admin.set_role :admin

      expect(@admin.has_role?(:admin)).to eq(true)
    end

    it "with_role should return all users with the role" do
      @admin1 = create(:user, provider: @user.provider)
      @admin2 = create(:user, provider: @user.provider)
      @admin1.set_role :admin
      @admin2.set_role :admin

      expect(User.with_role(:admin).count).to eq(2)
    end

    it "without_role should return all users without the role" do
      @admin1 = create(:user, provider: @user.provider)
      @admin2 = create(:user, provider: @user.provider)
      @admin1.set_role :admin
      @admin2.set_role :admin

      expect(User.without_role(:admin).count).to eq(1)
    end
  end

  context 'blank email' do
    it "allows a blank email if the provider is not greenlight" do
      allow_any_instance_of(User).to receive(:greenlight_account?).and_return(false)

      user = create(:user, email: "", provider: "ldap")
      expect(user.valid?).to be true
    end

    it "does not allow a blank email if the provider is greenlight" do
      expect { create(:user, email: "", provider: "greenlight") }
        .to raise_exception(ActiveRecord::RecordInvalid, "Validation failed: Email can't be blank")
    end
  end
end
