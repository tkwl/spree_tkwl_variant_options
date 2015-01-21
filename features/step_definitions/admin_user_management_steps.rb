module UserSessionHelper
  class SuperAbility
    include CanCan::Ability

    def initialize(user)
      # allow anyone to perform anything on anything
      can :manage, :all
    end
  end
end

Given /^I am registered$/ do
  @registered_user = create(:user, :email => 'john@doe.com')
end

Given /^I am admin$/ do
  ability = UserSessionHelper::SuperAbility
  Spree::Ability.register_ability(ability)
end

Given(/^I am on the admin login page$/) do
  visit("/admin")
end

Given /^I am logged in as admin$/ do
  steps %Q{
    Given I am admin
    When I sign in as admin
  }
end

Given /^a user with email "([^"]*)" exists$/ do |email|
  @registered_user = create(:user,
                            :email => email,
                            :created_at => 2.days.ago,
                            :last_sign_in_at => 1.day.ago,
                            :updated_at => 5.hours.ago)
end

When(/^I sign in as admin$/) do
  sign_in_as_admin!(@registered_user)
end

def sign_in_as_admin!(user)
  visit '/admin'
end