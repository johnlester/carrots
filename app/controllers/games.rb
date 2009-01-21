class Games < Application
  # provides :xml, :yaml, :js

  def index
    @games = Game.all
    display @games
  end

  def show(id)
    @game = Game.get(id)
    raise NotFound unless @game
    display @game
  end

  def available(character)
    @games = Game.all(:active => false)
    display @games
  end

  def join
    @game = Game.get(params[:game])
    @character = Character.get(params[:character])
    @game.characters << @character
    @game.save
    display @game
  end

  # def new(character)
  #   only_provides :html
  #   @game = Game.new(character)
  #   display @game
  # end

  # def edit(id)
  #   only_provides :html
  #   @game = Game.get(id)
  #   raise NotFound unless @game
  #   display @game
  # end

  def create(character)
    @game = Game.new(character)
    if @game.save
      redirect "/characters", :message => {:notice => "Game was successfully created"}
    else
      message[:error] = "Game failed to be created"
      render :new
    end
  end

  # def update(id, game)
  #   @game = Game.get(id)
  #   raise NotFound unless @game
  #   if @game.update_attributes(game)
  #      redirect resource(@game)
  #   else
  #     display @game, :edit
  #   end
  # end

  def destroy(id)
    @game = Game.get(id)
    raise NotFound unless @game
    if @game.destroy
      redirect resource(:games)
    else
      raise InternalServerError
    end
  end

end # Games
