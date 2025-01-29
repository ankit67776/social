class CreateGetbuiltProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :getbuilt_properties do |t|
      t.json :data

      t.timestamps
    end
  end
end
