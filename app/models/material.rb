class Material < ActiveRecord::Base
  acts_as_taggable
  ajaxful_rateable
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  has_attached_file :blend
end
