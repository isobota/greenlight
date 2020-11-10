# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

# Configure Shoulda-Matchers.
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :rails
  end
end
