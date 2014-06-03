class AppointmentPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
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
    user
  end

  def show?
    role_fence
  end

  def new?
    index?
  end

  def create?
    role_fence
  end

  def edit?
    (user.admin? && [Appointment::CONFIRMED, Appointment::PENDING].include?(record.status)) ||
    (!user.admin? && record.status == Appointment::PENDING)
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

  def set_users_and_services?
    user
  end

private 
    def role_fence
      user.admin? || user.id == record.user_id
    end

end
 