require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a mof exists" do
  Mof.all.destroy!
  request(resource(:moves), :method => "POST", 
    :params => { :mof => { :id => nil }})
end

describe "resource(:moves)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:moves))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of moves" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a mof exists" do
    before(:each) do
      @response = request(resource(:moves))
    end
    
    it "has a list of moves" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Mof.all.destroy!
      @response = request(resource(:moves), :method => "POST", 
        :params => { :mof => { :id => nil }})
    end
    
    it "redirects to resource(:moves)" do
      @response.should redirect_to(resource(Mof.first), :message => {:notice => "mof was successfully created"})
    end
    
  end
end

describe "resource(@mof)" do 
  describe "a successful DELETE", :given => "a mof exists" do
     before(:each) do
       @response = request(resource(Mof.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:moves))
     end

   end
end

describe "resource(:moves, :new)" do
  before(:each) do
    @response = request(resource(:moves, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@mof, :edit)", :given => "a mof exists" do
  before(:each) do
    @response = request(resource(Mof.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@mof)", :given => "a mof exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Mof.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @mof = Mof.first
      @response = request(resource(@mof), :method => "PUT", 
        :params => { :mof => {:id => @mof.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@mof))
    end
  end
  
end

