class CreateLoanHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :loan_histories do |t|
      t.timestamps
    end
  end
end
