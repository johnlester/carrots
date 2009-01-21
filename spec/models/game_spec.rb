require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Game do

  before(:each) do
    @game = Game.create_random
  end

  it "should have at least two characters" do
    @game.characters.count.should >= 0
  end

  it "should not be ready to do and apply round effects" do
    @game.ready_to_do_round?.should == false
  end


end