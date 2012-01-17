class AddChecksumToMaterial < ActiveRecord::Migration
  def change
    add_column :materials, :blend_fingerprint, :string
  end
end
