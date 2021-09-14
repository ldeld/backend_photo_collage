class AddOrientationToCollages < ActiveRecord::Migration[6.1]
  def change
    add_column :collages, :orientation, :string
  end
end
