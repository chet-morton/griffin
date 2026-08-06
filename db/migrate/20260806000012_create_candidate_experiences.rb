class CreateCandidateExperiences < ActiveRecord::Migration[8.0]
  def change
    create_table :candidate_experiences do |t|
      t.references :candidate, null: false, foreign_key: { on_delete: :cascade }
      t.string :company_name, null: false
      t.string :role_title, null: false
      t.string :duration, null: false
      t.text :description
      t.string :skills_used

      t.timestamps
    end
  end
end
