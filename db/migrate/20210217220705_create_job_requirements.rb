class CreateJobRequirements < ActiveRecord::Migration[6.1]
  def change
    create_table :job_requirements do |t|
      t.references :job, null: false, foreign_key: true
      t.references :requirement, null: false, foreign_key: true

      t.timestamps
    end
  end
end
