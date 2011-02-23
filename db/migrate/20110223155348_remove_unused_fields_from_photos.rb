class RemoveUnusedFieldsFromPhotos < ActiveRecord::Migration
  def self.up
    remove_column :photos, :name
    remove_column :photos, :parent_id
    remove_column :photos, :content_type
    remove_column :photos, :filename
    remove_column :photos, :thumbnail
    remove_column :photos, :size
    remove_column :photos, :width
    remove_column :photos, :height     
  end

  def self.down
    add_column :photos, :name, :string, :limit => 100, :null => false
    add_column :photos, :parent_id, :int
    add_column :photos, :content_type, :string
    add_column :photos, :filename, :string
    add_column :photos, :thumbnail, :string
    add_column :photos, :size, :int
    add_column :photos, :width, :int
    add_column :photos, :height, :int   
  end
end
