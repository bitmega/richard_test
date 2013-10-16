class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, User, :company_id => user.company_id
    else
      can :read, Company, :id => user.company_id
    end
  end
end
