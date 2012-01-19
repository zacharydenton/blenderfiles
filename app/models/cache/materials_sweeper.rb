class MaterialSweeper < ActionController::Caching::Sweeper
  observe Material # This sweeper is going to keep an eye on the Material model
 
  # If our sweeper detects that a Material was created call this
  def after_create(material)
    expire_cache_for(material)
  end
 
  # If our sweeper detects that a Material was updated call this
  def after_update(material)
    expire_cache_for(material)
  end
 
  # If our sweeper detects that a Material was deleted call this
  def after_destroy(material)
    expire_cache_for(material)
  end
 
  private
  def expire_cache_for(material)
    expire_page(:controller => 'materials', :action => 'index')
    expire_page(:controller => 'materials', :action => 'show', :id => material.id)
  end
end

