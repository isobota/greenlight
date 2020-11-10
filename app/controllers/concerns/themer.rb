# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

module Themer
  extend ActiveSupport::Concern

  # Lightens a color by 40%
  def color_lighten(color)
    # Uses the built in Sass Engine to lighten the color
    generate_sass("lighten", color, "40%")
  end

  # Darkens a color by 10%
  def color_darken(color)
    # Uses the built in Sass Engine to darken the color
    generate_sass("darken", color, "10%")
  end

  private

  def generate_sass(action, color, percentage)
    dummy_scss = "h1 { color: $#{action}; }"
    compiled = SassC::Engine.new("$#{action}:#{action}(#{color}, #{percentage});" + dummy_scss, syntax: :scss).render

    string_locater = 'color: '
    color_start = compiled.index(string_locater) + string_locater.length

    compiled[color_start..color_start + 6]
  end
end
