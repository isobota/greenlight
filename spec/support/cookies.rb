# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

# Allows Rspec to access excrypted, signed or permanent cookies
module ActionDispatch
  class Cookies
    class CookieJar
      def encrypted
        self
      end

      def signed
        self
      end

      def permanent
        self
      end
    end
  end
end
