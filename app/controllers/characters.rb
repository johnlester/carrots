class Characters < Application
  # provides :xml, :yaml, :js

  def index
    @characters = session.user.characters
    display @characters
  end

  def show(id)
    @character = Character.get(id)
    raise NotFound unless @character
    display @character
  end

  def new
    only_provides :html
    @character = Character.new
    display @character
  end

  def edit(id)
    only_provides :html
    @character = Character.get(id)
    raise NotFound unless @character
    display @character
  end

  def create(character)
    @character = Character.new(character)
    if @character.save
      session.user.characters << @character
      session.user.save
      redirect resource(@character), :message => {:notice => "Character was successfully created"}
    else
      message[:error] = "Character failed to be created"
      render :new
    end
  end

  def update(id, character)
    @character = Character.get(id)
    raise NotFound unless @character
    if @character.update_attributes(character)
       redirect resource(@character)
    else
      display @character, :edit
    end
  end

  def destroy(id)
    @character = Character.get(id)
    raise NotFound unless @character
    if @character.destroy
      redirect resource(:characters)
    else
      raise InternalServerError
    end
  end

end # Characters
