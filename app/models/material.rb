require 'tempfile'
require 'fileutils'

class Material < ActiveRecord::Base
  acts_as_taggable
  ajaxful_rateable

  has_attached_file :blend,
    :url => "/materials/:id/:title_slug.blend" 
  validates_attachment_size :blend, :less_than => 10.megabytes

  has_many :images, :as => :imageable, :dependent => :destroy

  Paperclip.interpolates :title_slug do |attachment, style|
    attachment.instance.title.parameterize
  end

  validates_uniqueness_of :blend_fingerprint, :message => "already exists in databaase"

  def self.create_from_blend(blend_path, title="", description="", tags=[], delete_original=false)
    extract_script = Rails.root.join('lib', 'scripts', 'extract_materials.sh')

    temp = Tempfile.new('blend')
    temp_path = temp.path
    temp.close!
    FileUtils.cp blend_path, temp_path

    if delete_original
      FileUtils.rm blend_path
    end

    system("bash #{extract_script} #{temp_path}")

    materials = []
    Dir.glob("#{temp_path}-*.blend").each do |mat_blend|
      unless title
        title = mat_blend.split('-')[-1].split('.')[0] # grab the *
      end
      material = Material.create(:title => title, :description => description)
      puts "created material: #{material.title}"
      material.tag_list = tags
      material.blend = open(mat_blend)
      material.save
      if material.valid?
        material.render_images
        materials << material
      end
    end
    FileUtils.rm temp_path
    return materials
  end

  def render_images
    render_script = Rails.root.join('lib', 'scripts', 'material_preview.sh')

    temp = Tempfile.new('blend')
    temp_path = temp.path
    temp.close!
    FileUtils.cp self.blend.path, temp_path

    system("bash #{render_script} #{temp_path}")
    Dir.glob("#{temp_path}-*.jpg").each do |image_path|
      layer = image_path.split('-')[-1].split('.')[0] # grab the *
      image = self.images.create
      image.image = open(image_path)
      if layer == '2' # the rocket ship
        image.order = 0
      end
      image.save
    end

    FileUtils.rm temp_path
  end
  handle_asynchronously :render_images
  
  def image
    return self.images.order('"order"').first.image
  end
end
