class CreatePipelineStages < ActiveRecord::Migration[8.0]
  def change
    create_table :pipeline_stages do |t|
      t.references :job_posting, null: false, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
      t.integer :position, null: false, default: 0
      t.string :stage_type, null: false, default: "screening"
      t.text :exit_criteria

      t.timestamps
    end

    add_index :pipeline_stages, [:job_posting_id, :position]
  end
end
