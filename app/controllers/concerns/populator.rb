# frozen_string_literal: true

#
#  Meeting Web - frontend to meeting, elearning & conference system
#

module Populator
  extend ActiveSupport::Concern

  # Returns a list of users that are in the same context of the current user
  def manage_users_list
    initial_list = case @tab
      when "active"
        User.without_role([:pending, :denied])
      when "deleted"
        User.deleted
      when "pending"
        User.with_role(:pending)
      when "denied"
        User.with_role(:denied)
      else
        User.all
    end

    initial_list = initial_list.with_role(@role.name) if @role.present?

    initial_list = initial_list.without_role(:super_admin)

    initial_list = initial_list.where(provider: @user_domain) if Rails.configuration.loadbalanced_configuration

    initial_list.where.not(id: current_user.id)
                .admins_search(@search)
                .admins_order(@order_column, @order_direction)
  end

  # Returns a list of rooms that are in the same context of the current user
  def server_rooms_list
    if Rails.configuration.loadbalanced_configuration
      Room.includes(:owner).where(users: { provider: @user_domain })
          .admins_search(@search)
          .admins_order(@order_column, @order_direction, @running_room_bbb_ids)
    else
      Room.includes(:owner).admins_search(@search).admins_order(@order_column, @order_direction, @running_room_bbb_ids)
    end
  end

  # Returns list of rooms needed to get the recordings on the server
  def rooms_list_for_recordings
    if Rails.configuration.loadbalanced_configuration
      Room.includes(:owner).where(users: { provider: @user_domain }).pluck(:bbb_id)
    else
      Room.pluck(:bbb_id)
    end
  end

  # Returns a list of users that are in the same context of the current user
  def shared_user_list
    roles_can_appear = []
    Role.where(provider: @user_domain).each do |role|
      roles_can_appear << role.name if role.get_permission("can_appear_in_share_list") && role.priority >= 0
    end

    initial_list = User.where.not(uid: current_user.uid).with_role(roles_can_appear)

    return initial_list unless Rails.configuration.loadbalanced_configuration
    initial_list.where(provider: @user_domain)
  end

  # Returns a list of users that can merged into another user
  def merge_user_list
    initial_list = User.without_role(:super_admin).where.not(uid: current_user.uid)

    return initial_list unless Rails.configuration.loadbalanced_configuration
    initial_list.where(provider: @user_domain)
  end

  # Returns a list off all current invitations
  def invited_users_list
    list = if Rails.configuration.loadbalanced_configuration
      Invitation.where(provider: @user_domain)
    else
      Invitation.all
    end

    list.admins_search(@search).order(updated_at: :desc)
  end
end
