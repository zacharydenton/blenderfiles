class Material < ActiveRecord::Base
  acts_as_taggable
  ajaxful_rateable

  has_attached_file :image, 
    :styles => { :medium => "300x300>", :thumb => "100x100>" },
    :path => ":rails_root/public/system/:attachment/:id/:style/:title_slug.jpg",
    :url => "/system/:attachment/:id/:style/:title_slug.jpg" 

  has_attached_file :blend,
    :path => ":rails_root/public/system/:attachment/:id/:style/:title_slug.blend",
    :url => "/system/:attachment/:id/:style/:title_slug.blend" 

  Paperclip.interpolates :title_slug do |attachment, style|
    attachment.instance.title.parameterize
  end
end
