class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :status, default: "Active"

      t.timestamps
    end
  end
end
