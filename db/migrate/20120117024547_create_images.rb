class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :order, :default => 1
      t.references :imageable, :polymorphic => true
      t.timestamps
    end
  end
end
