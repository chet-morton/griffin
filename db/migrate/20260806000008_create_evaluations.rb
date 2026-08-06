class CreateEvaluations < ActiveRecord::Migration[8.0]
  def change
    create_table :evaluations do |t|
      t.references :candidate_application, null: false, foreign_key: { on_delete: :cascade }
      t.references :skill_requirement, null: false, foreign_key: { on_delete: :cascade }
      t.references :evaluator, null: false, foreign_key: { to_table: :users }
      t.integer :score, null: false
      t.text :notes
      t.datetime :evaluated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end

    add_index :evaluations, [:candidate_application_id, :skill_requirement_id, :evaluator_id],
              unique: true, name: "index_evaluations_unique_per_evaluator_skill"
  end
end
