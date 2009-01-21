class Moves < Application
  # provides :xml, :yaml, :js

  def index
    @moves = Mof.all
    display @moves
  end

  def show(id)
    @mof = Mof.get(id)
    raise NotFound unless @mof
    display @mof
  end

  def new
    only_provides :html
    @mof = Mof.new
    display @mof
  end

  def edit(id)
    only_provides :html
    @mof = Mof.get(id)
    raise NotFound unless @mof
    display @mof
  end

  def create(mof)
    @mof = Mof.new(mof)
    if @mof.save
      redirect resource(@mof), :message => {:notice => "Mof was successfully created"}
    else
      message[:error] = "Mof failed to be created"
      render :new
    end
  end

  def update(id, mof)
    @mof = Mof.get(id)
    raise NotFound unless @mof
    if @mof.update_attributes(mof)
       redirect resource(@mof)
    else
      display @mof, :edit
    end
  end

  def destroy(id)
    @mof = Mof.get(id)
    raise NotFound unless @mof
    if @mof.destroy
      redirect resource(:moves)
    else
      raise InternalServerError
    end
  end

end # Moves
