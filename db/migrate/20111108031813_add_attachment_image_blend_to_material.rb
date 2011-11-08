class AddAttachmentImageBlendToMaterial < ActiveRecord::Migration
  def self.up
    add_column :materials, :image_file_name, :string
    add_column :materials, :image_content_type, :string
    add_column :materials, :image_file_size, :integer
    add_column :materials, :image_updated_at, :datetime
    add_column :materials, :blend_file_name, :string
    add_column :materials, :blend_content_type, :string
    add_column :materials, :blend_file_size, :integer
    add_column :materials, :blend_updated_at, :datetime
  end

  def self.down
    remove_column :materials, :image_file_name
    remove_column :materials, :image_content_type
    remove_column :materials, :image_file_size
    remove_column :materials, :image_updated_at
    remove_column :materials, :blend_file_name
    remove_column :materials, :blend_content_type
    remove_column :materials, :blend_file_size
    remove_column :materials, :blend_updated_at
  end
end
