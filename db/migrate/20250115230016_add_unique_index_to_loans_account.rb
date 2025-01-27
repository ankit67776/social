class AddUniqueIndexToLoansAccount < ActiveRecord::Migration[8.0]
  def change
    add_index :loans, :account, unique: true
  end
end
