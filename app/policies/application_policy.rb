class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

def index?
    user.try(:admin?)
  end

  def show?
    user.try(:admin?)
  end

  def create?
    user.try(:admin?)
  end

  def new?
    user.try(:admin?)
  end

  def update?
    user.try(:admin?)
  end

  def edit?
    user.try(:admin?)
  end

  def destroy?
    user.try(:admin?)
  end

end

