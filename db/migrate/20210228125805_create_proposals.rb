class CreateProposals < ActiveRecord::Migration[6.1]
  def change
    create_table :proposals do |t|
      t.references :application, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.text :message, null: false
      t.decimal :salary_proposal, null: false
      t.datetime :start_date, null: false

      t.timestamps
    end
  end
end
