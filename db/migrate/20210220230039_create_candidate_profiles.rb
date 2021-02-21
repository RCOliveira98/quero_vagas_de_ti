class CreateCandidateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :candidate_profiles do |t|
      t.references :candidate, null: false, foreign_key: true
      t.string :name
      t.string :cpf
      t.string :phone
      t.text :biography
      t.string :country
      t.string :state
      t.string :city
      t.string :zip_code
      t.string :neighborhood
      t.string :logradouro

      t.timestamps
    end
  end
end
