class AddBorderSizeAndBorderColorToCollages < ActiveRecord::Migration[6.1]
  def change
    add_column :collages, :border_size, :integer
    add_column :collages, :border_color, :string
  end
end
