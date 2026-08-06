class CreateCandidateApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :candidate_applications do |t|
      t.references :candidate, null: false, foreign_key: { on_delete: :cascade }
      t.references :job_posting, null: false, foreign_key: { on_delete: :cascade }
      t.references :current_stage, null: false, foreign_key: { to_table: :pipeline_stages }
      t.string :status, null: false, default: "active"
      t.decimal :overall_score, precision: 4, scale: 2

      t.timestamps
    end

    add_index :candidate_applications, [:candidate_id, :job_posting_id], unique: true
    add_index :candidate_applications, :status
    add_index :candidate_applications, :overall_score
  end
end
