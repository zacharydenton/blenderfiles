require 'tempfile'
class ApplicationController < ActionController::Base
  protect_from_forgery

  def upload
    #TODO: need to ensure that materials are unique!
    if request.post?
      blend = params[:file][:blend]
      temp = Tempfile.new('blend')
      File.open(temp.path, 'wb') {|f| f.write(blend.read) }
      temp_path = temp.path
      temp.close
      materials = Material.create_from_blend(temp_path)
      redirect_to materials_url, notice: "The following materials have been extracted from your .blend: #{materials.map {|m| m.title}.join ', '}. They have been added to the rendering queue and will appear when finished."
    else
      respond_to do |format|
        format.html
      end
    end
  end
end
