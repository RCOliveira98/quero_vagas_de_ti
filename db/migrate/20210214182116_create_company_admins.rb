class CreateCompanyAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table :company_admins do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
