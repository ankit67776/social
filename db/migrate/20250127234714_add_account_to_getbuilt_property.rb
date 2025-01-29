class AddAccountToGetbuiltProperty < ActiveRecord::Migration[8.0]
  def change
    add_column :getbuilt_properties, :account, :string
    add_index :getbuilt_properties, :account, unique: true
  end
end
