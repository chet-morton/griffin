class AddRichProfileFieldsToCandidates < ActiveRecord::Migration[8.0]
  def change
    add_column :candidates, :title, :string, default: "Senior Software Engineer"
    add_column :candidates, :location, :string, default: "San Francisco, CA"
    add_column :candidates, :ai_summary, :text
    add_column :candidates, :career_trajectory, :string, default: "Ascending Staff Engineer"
    add_column :candidates, :estimated_compensation, :integer, default: 195000
    add_column :candidates, :fit_score, :decimal, precision: 4, scale: 2, default: 92.5
    add_column :candidates, :tags, :string, default: "rails,pgvector,hotwire,system-design"
  end
end
