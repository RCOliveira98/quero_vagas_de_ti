class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.references :company, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.decimal :lowest_salary
      t.decimal :highest_salary
      t.integer :level
      t.integer :quantity
      t.datetime :deadline_for_registration

      t.timestamps
    end
  end
end
