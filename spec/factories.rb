# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

FactoryBot.define do
  factory :user do
    password = Faker::Internet.password(min_length: 8)
    provider { %w(google twitter).sample }
    uid { rand(10**8) }
    name { Faker::Name.first_name }
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password { password }
    password_confirmation { password }
    accepted_terms { true }
    email_verified { true }
    activated_at { Time.zone.now }
    role { set_role(:user) }
  end

  factory :room do
    name { Faker::Games::Pokemon.name }
    owner { create(:user) }
  end
end
