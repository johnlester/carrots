require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a card exists" do
  Card.all.destroy!
  request(resource(:cards), :method => "POST", 
    :params => { :card => { :id => nil }})
end

describe "resource(:cards)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:cards))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of cards" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a card exists" do
    before(:each) do
      @response = request(resource(:cards))
    end
    
    it "has a list of cards" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Card.all.destroy!
      @response = request(resource(:cards), :method => "POST", 
        :params => { :card => { :id => nil }})
    end
    
    it "redirects to resource(:cards)" do
      @response.should redirect_to(resource(Card.first), :message => {:notice => "card was successfully created"})
    end
    
  end
end

describe "resource(@card)" do 
  describe "a successful DELETE", :given => "a card exists" do
     before(:each) do
       @response = request(resource(Card.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:cards))
     end

   end
end

describe "resource(:cards, :new)" do
  before(:each) do
    @response = request(resource(:cards, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@card, :edit)", :given => "a card exists" do
  before(:each) do
    @response = request(resource(Card.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@card)", :given => "a card exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Card.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @card = Card.first
      @response = request(resource(@card), :method => "PUT", 
        :params => { :card => {:id => @card.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@card))
    end
  end
  
end

