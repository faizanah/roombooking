# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    can :read, Booking # Everyone can view bookings.
    can :read, Room # Everyone can view rooms.
    can :read, CamdramShow # Everyone can view shows imported from Camdram.
    can :read, CamdramSociety # Everyone can view societies imported from Camdram.
    can :update, CamdramShow do |camdram_show|
      # Logged in users can update shows they administer on Camdram.
      user.present? && user.camdram_shows.include?(camdram_show)
    end
    can :update, CamdramSociety do |camdram_society|
      # Logged in users can update societies they administer on Camdram.
      user.present? && user.camdram_societies.include?(camdram_society)
    end
    if user.present?  # Additional permissions for logged in users...
      if user.admin?
        can :manage, :all # Administrators can do anything!
      else
        can :create, Booking # Users can create new bookings if they are listed as a Camdram admin for the show or society.
        can :crud, Booking, user_id: user.id # Users have full CRUD control of their own bookings.
        can [:read, :update], User, id: user.id # Users have edit control of their own user account.
      end
    end
  end
end
