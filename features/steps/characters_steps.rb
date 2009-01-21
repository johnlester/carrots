Given /^I have (\d+) characters$/ do |number|
  number.to_i.times do 
    @user.characters << Character.create_random
  end
  @user.save
end

Given /^I have a character named "(.*)"$/ do |name|
  @user.characters << Character.create(:name => name)
  @user.save
end
  
