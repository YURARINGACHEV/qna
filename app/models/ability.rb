# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer, Comment], { user_id: @user.id }

    can :mark_as_best, Answer, question: { user_id: user.id }
    can :destroy, Link, linkable: { user_id: user.id }
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author?(attachment.record)
    end

    can [:vote_up, :vote_down, :unvote], [Question, Answer] do |vote|
      !user.author?(vote)
    end
  end

  def guest_abilities
    can :read, :all
  end
end