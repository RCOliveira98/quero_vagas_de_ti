class CreateDeclineApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :decline_applications do |t|
      t.references :application, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.text :justification, null: false

      t.timestamps
    end
  end
end
