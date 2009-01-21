require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a game exists" do
  Game.all.destroy!
  request(resource(:games), :method => "POST", 
    :params => { :game => { :id => nil }})
end

describe "resource(:games)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:games))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of games" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a game exists" do
    before(:each) do
      @response = request(resource(:games))
    end
    
    it "has a list of games" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Game.all.destroy!
      @response = request(resource(:games), :method => "POST", 
        :params => { :game => { :id => nil }})
    end
    
    it "redirects to resource(:games)" do
      @response.should redirect_to(resource(Game.first), :message => {:notice => "game was successfully created"})
    end
    
  end
end

describe "resource(@game)" do 
  describe "a successful DELETE", :given => "a game exists" do
     before(:each) do
       @response = request(resource(Game.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:games))
     end

   end
end

describe "resource(:games, :new)" do
  before(:each) do
    @response = request(resource(:games, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@game, :edit)", :given => "a game exists" do
  before(:each) do
    @response = request(resource(Game.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@game)", :given => "a game exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Game.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @game = Game.first
      @response = request(resource(@game), :method => "PUT", 
        :params => { :game => {:id => @game.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@game))
    end
  end
  
end

