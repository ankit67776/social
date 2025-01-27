class RemoveCategoriesFromLoans < ActiveRecord::Migration[8.0]
  def change
    remove_column :loans, :categories, :string
  end
end
