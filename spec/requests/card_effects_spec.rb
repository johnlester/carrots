require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a card_effect exists" do
  CardEffect.all.destroy!
  request(resource(:card_effects), :method => "POST", 
    :params => { :card_effect => { :id => nil }})
end

describe "resource(:card_effects)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:card_effects))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of card_effects" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a card_effect exists" do
    before(:each) do
      @response = request(resource(:card_effects))
    end
    
    it "has a list of card_effects" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      CardEffect.all.destroy!
      @response = request(resource(:card_effects), :method => "POST", 
        :params => { :card_effect => { :id => nil }})
    end
    
    it "redirects to resource(:card_effects)" do
      @response.should redirect_to(resource(CardEffect.first), :message => {:notice => "card_effect was successfully created"})
    end
    
  end
end

describe "resource(@card_effect)" do 
  describe "a successful DELETE", :given => "a card_effect exists" do
     before(:each) do
       @response = request(resource(CardEffect.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:card_effects))
     end

   end
end

describe "resource(:card_effects, :new)" do
  before(:each) do
    @response = request(resource(:card_effects, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@card_effect, :edit)", :given => "a card_effect exists" do
  before(:each) do
    @response = request(resource(CardEffect.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@card_effect)", :given => "a card_effect exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(CardEffect.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @card_effect = CardEffect.first
      @response = request(resource(@card_effect), :method => "PUT", 
        :params => { :card_effect => {:id => @card_effect.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@card_effect))
    end
  end
  
end

