class Cards < Application
  # provides :xml, :yaml, :js

  def index
    @cards = Card.all
    display @cards
  end

  def show(id)
    @card = Card.get(id)
    raise NotFound unless @card
    display @card
  end

  def new
    only_provides :html
    @card = Card.new
    display @card
  end

  def edit(id)
    only_provides :html
    @card = Card.get(id)
    raise NotFound unless @card
    display @card
  end

  def create(card)
    @card = Card.new(card)
    if @card.save
      redirect resource(@card), :message => {:notice => "Card was successfully created"}
    else
      message[:error] = "Card failed to be created"
      render :new
    end
  end

  def update(id, card)
    @card = Card.get(id)
    raise NotFound unless @card
    if @card.update_attributes(card)
       redirect resource(@card)
    else
      display @card, :edit
    end
  end

  def destroy(id)
    @card = Card.get(id)
    raise NotFound unless @card
    if @card.destroy
      redirect resource(:cards)
    else
      raise InternalServerError
    end
  end

end # Cards
