class CreateCollageElements < ActiveRecord::Migration[6.1]
  def change
    create_table :collage_elements do |t|
      t.references :collage, null: false, foreign_key: true

      t.timestamps
    end
  end
end
