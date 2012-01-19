if Rails.env.production?
  class MaterialsSweeper < ActionController::Caching::Sweeper
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
end

class MaterialsController < ApplicationController

  if Rails.env.production?
    caches_page :index, :show, :new
    cache_sweeper :materials_sweeper
  end

  # GET /materials
  # GET /materials.json
  def index
    @materials = Material.joins(:images).group("#{Material.table_name}.id").having("COUNT(#{Image.table_name}.id) > 0").order("`materials`.`blend_updated_at` DESC").paginate(:page => params[:page])

    #TODO: ability to select materials with a specific tag /materials/:tag
    #TODO: sort materials by number of downloads, rating, etc.

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @materials }
    end
  end

  # GET /materials/1
  # GET /materials/1.json
  def show
    @material = Material.find(params[:id])
    #TODO: add a route to download /materials/:id/:title_slug.blend
    #TODO: improve visual style of material.show page

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @material }
    end
  end

  # GET /materials/new
  # GET /materials/new.json
  def new
    @material = Material.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @material }
    end
  end

  # GET /materials/1/edit
  def edit
    @material = Material.find(params[:id])
  end

  # POST /materials
  # POST /materials.json
  def create
    @material = Material.new(params[:material])

    respond_to do |format|
      if @material.save
        format.html { redirect_to @material, notice: 'Material was successfully created.' }
        format.json { render json: @material, status: :created, location: @material }
      else
        format.html { render action: "new" }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /materials/1
  # PUT /materials/1.json
  def update
    @material = Material.find(params[:id])

    respond_to do |format|
      if @material.update_attributes(params[:material])
        format.html { redirect_to @material, notice: 'Material was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  def rate
    @material = Material.find(params[:id])
    @material.rate(params[:stars], current_user, params[:dimension])
    render :update do |page|
      page.replace_html @material.wrapper_dom_id(params), ratings_for(@material, params.merge(:wrap => false))
      page.visual_effect :highlight, @car.wrapper_dom_id(params)
    end
  end

  def tagged
    @materials = Material.joins(:images).group("#{Material.table_name}.id").having("COUNT(#{Image.table_name}.id) > 0").order("`materials`.`blend_updated_at` DESC").tagged_with(params[:tags]).paginate(:page => params[:page])
    render :action => 'index'
  end

  # DELETE /materials/1
  # DELETE /materials/1.json
  def destroy
    @material = Material.find(params[:id])
    @material.destroy

    respond_to do |format|
      format.html { redirect_to materials_url }
      format.json { head :ok }
    end
  end
end

