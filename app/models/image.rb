class Image < ActiveRecord::Base
  has_attached_file :image, 
    :styles => { :main => "400", :medium => "256x256>", :thumb => "100x100>" }

  belongs_to :imageable, :polymorphic => true

  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes
end
