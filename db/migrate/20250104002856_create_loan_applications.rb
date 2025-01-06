class CreateLoanApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :loan_applications do |t|
      t.references :customer, null: false, foreign_key: true
      t.date :creation_date
      t.text :application_details

      t.timestamps
    end
  end
end
