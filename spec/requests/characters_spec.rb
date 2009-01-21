require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a character exists" do
  Character.all.destroy!
  request(resource(:characters), :method => "POST", 
    :params => { :character => { :id => nil }})
end

describe "resource(:characters)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:characters))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of characters" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a character exists" do
    before(:each) do
      @response = request(resource(:characters))
    end
    
    it "has a list of characters" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Character.all.destroy!
      @response = request(resource(:characters), :method => "POST", 
        :params => { :character => { :id => nil }})
    end
    
    it "redirects to resource(:characters)" do
      @response.should redirect_to(resource(Character.first), :message => {:notice => "character was successfully created"})
    end
    
  end
end

describe "resource(@character)" do 
  describe "a successful DELETE", :given => "a character exists" do
     before(:each) do
       @response = request(resource(Character.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:characters))
     end

   end
end

describe "resource(:characters, :new)" do
  before(:each) do
    @response = request(resource(:characters, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@character, :edit)", :given => "a character exists" do
  before(:each) do
    @response = request(resource(Character.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@character)", :given => "a character exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Character.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @character = Character.first
      @response = request(resource(@character), :method => "PUT", 
        :params => { :character => {:id => @character.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@character))
    end
  end
  
end

