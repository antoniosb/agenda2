class UserPolicy < Struct.new(:user, :record)
  class Scope < Struct.new(:user, :scope)
    def resolve
      
    end
  end
  
end