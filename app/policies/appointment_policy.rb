class AppointmentPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @record = record
  end

  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(:user_id => user.id)
      end
    end
  end

  def index?
    true
  end

  def show?
    role_fence
  end

  def new?
    true
  end

  def create?
    role_fence
  end

  def edit?
    user.admin? && [Appointment::CONFIRMED, Appointment::PENDING].include?(record.status)
  end

  def update?
    edit?
  end

  def destroy?
    role_fence
  end

  def destroy_multiple?
    user.admin? && [Appointment::CANCELED, Appointment::CONCLUDED].include?(record.status)
  end

private 
    def role_fence
      user.admin? || user.id == record.user_id
    end

end
 