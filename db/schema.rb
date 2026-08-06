# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_08_06_000012) do
  create_table "candidate_applications", force: :cascade do |t|
    t.integer "candidate_id", null: false
    t.integer "job_posting_id", null: false
    t.integer "current_stage_id", null: false
    t.string "status", default: "active", null: false
    t.decimal "overall_score", precision: 4, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id", "job_posting_id"], name: "idx_on_candidate_id_job_posting_id_3b05460de1", unique: true
    t.index ["candidate_id"], name: "index_candidate_applications_on_candidate_id"
    t.index ["current_stage_id"], name: "index_candidate_applications_on_current_stage_id"
    t.index ["job_posting_id"], name: "index_candidate_applications_on_job_posting_id"
    t.index ["overall_score"], name: "index_candidate_applications_on_overall_score"
    t.index ["status"], name: "index_candidate_applications_on_status"
  end

  create_table "candidate_experiences", force: :cascade do |t|
    t.integer "candidate_id", null: false
    t.string "company_name", null: false
    t.string "role_title", null: false
    t.string "duration", null: false
    t.text "description"
    t.string "skills_used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_candidate_experiences_on_candidate_id"
  end

  create_table "candidates", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "portfolio_url"
    t.text "resume_text"
    t.text "embedding"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", default: "Senior Software Engineer"
    t.string "location", default: "San Francisco, CA"
    t.text "ai_summary"
    t.string "career_trajectory", default: "Ascending Staff Engineer"
    t.integer "estimated_compensation", default: 195000
    t.decimal "fit_score", precision: 4, scale: 2, default: "92.5"
    t.string "tags", default: "rails,pgvector,hotwire,system-design"
    t.index ["email"], name: "index_candidates_on_email", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "industry", default: "Technology", null: false
    t.string "website"
    t.string "tier", default: "Enterprise", null: false
    t.decimal "hiring_velocity_score", precision: 4, scale: 2, default: "85.0"
    t.text "notes"
    t.text "ai_summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_companies_on_name", unique: true
    t.index ["tier"], name: "index_companies_on_tier"
  end

  create_table "evaluations", force: :cascade do |t|
    t.integer "candidate_application_id", null: false
    t.integer "skill_requirement_id", null: false
    t.integer "evaluator_id", null: false
    t.integer "score", null: false
    t.text "notes"
    t.datetime "evaluated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_application_id", "skill_requirement_id", "evaluator_id"], name: "index_evaluations_unique_per_evaluator_skill", unique: true
    t.index ["candidate_application_id"], name: "index_evaluations_on_candidate_application_id"
    t.index ["evaluator_id"], name: "index_evaluations_on_evaluator_id"
    t.index ["skill_requirement_id"], name: "index_evaluations_on_skill_requirement_id"
  end

  create_table "job_postings", force: :cascade do |t|
    t.string "title", null: false
    t.string "department", null: false
    t.text "description"
    t.string "status", default: "draft", null: false
    t.string "location", default: "Remote", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.integer "min_salary", default: 140000
    t.integer "max_salary", default: 220000
    t.string "currency", default: "USD"
    t.index ["company_id"], name: "index_job_postings_on_company_id"
    t.index ["department"], name: "index_job_postings_on_department"
    t.index ["status"], name: "index_job_postings_on_status"
  end

  create_table "pipeline_stages", force: :cascade do |t|
    t.integer "job_posting_id", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.string "stage_type", default: "screening", null: false
    t.text "exit_criteria"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_posting_id", "position"], name: "index_pipeline_stages_on_job_posting_id_and_position"
    t.index ["job_posting_id"], name: "index_pipeline_stages_on_job_posting_id"
  end

  create_table "skill_requirements", force: :cascade do |t|
    t.integer "job_posting_id", null: false
    t.string "name", null: false
    t.decimal "weight", precision: 5, scale: 2, default: "1.0", null: false
    t.integer "minimum_score", default: 3, null: false
    t.text "rubric_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_posting_id", "name"], name: "index_skill_requirements_on_job_posting_id_and_name", unique: true
    t.index ["job_posting_id"], name: "index_skill_requirements_on_job_posting_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "role", default: "evaluator", null: false
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "candidate_applications", "candidates", on_delete: :cascade
  add_foreign_key "candidate_applications", "job_postings", on_delete: :cascade
  add_foreign_key "candidate_applications", "pipeline_stages", column: "current_stage_id"
  add_foreign_key "candidate_experiences", "candidates", on_delete: :cascade
  add_foreign_key "evaluations", "candidate_applications", on_delete: :cascade
  add_foreign_key "evaluations", "skill_requirements", on_delete: :cascade
  add_foreign_key "evaluations", "users", column: "evaluator_id"
  add_foreign_key "job_postings", "companies", on_delete: :nullify
  add_foreign_key "pipeline_stages", "job_postings", on_delete: :cascade
  add_foreign_key "skill_requirements", "job_postings", on_delete: :cascade
end
