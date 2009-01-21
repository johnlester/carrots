Given /^I am not authenticated$/ do
  # yay!
end

Given /^a user exists with login "(.+)" and password "(.+)"$/ do |login, password|
  @user = User.create(:login => login, :password => password, :password_confirmation => password)
end

Given /^I am logged in as "(.+)" with password "(.+)"$/ do |login, password|
  Given("a user exists with login \"#{login}\" and password \"#{password}\"")
  Given("I go to /login")
  Given("I fill in \"login\" with \"#{login}\"")
  Given("I fill in \"password\" with \"#{password}\"")
  Given("I press \"Log In\"")
  Given("the login request should succeed")
  Given("I should see \"Characters controller, index action\"")
end
