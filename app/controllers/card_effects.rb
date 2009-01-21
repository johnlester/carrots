class CardEffects < Application
  # provides :xml, :yaml, :js

  def index
    @card_effects = CardEffect.all
    display @card_effects
  end

  def show(id)
    @card_effect = CardEffect.get(id)
    raise NotFound unless @card_effect
    display @card_effect
  end

  def new
    only_provides :html
    @card_effect = CardEffect.new
    display @card_effect
  end

  def edit(id)
    only_provides :html
    @card_effect = CardEffect.get(id)
    raise NotFound unless @card_effect
    display @card_effect
  end

  def create(card_effect)
    @card_effect = CardEffect.new(card_effect)
    if @card_effect.save
      redirect resource(@card_effect), :message => {:notice => "CardEffect was successfully created"}
    else
      message[:error] = "CardEffect failed to be created"
      render :new
    end
  end

  def update(id, card_effect)
    @card_effect = CardEffect.get(id)
    raise NotFound unless @card_effect
    if @card_effect.update_attributes(card_effect)
       redirect resource(@card_effect)
    else
      display @card_effect, :edit
    end
  end

  def destroy(id)
    @card_effect = CardEffect.get(id)
    raise NotFound unless @card_effect
    if @card_effect.destroy
      redirect resource(:card_effects)
    else
      raise InternalServerError
    end
  end

end # CardEffects
