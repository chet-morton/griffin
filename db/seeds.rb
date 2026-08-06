# Griffin Enterprise ATS & CRM Seed Data

puts "Seeding Griffin Enterprise ATS & CRM platform..."

# 1. Companies
company1 = Company.find_or_create_by!(name: "Acme Cloud Infrastructure") do |c|
  c.industry = "Cloud Infrastructure"
  c.website = "https://acmecloud.io"
  c.tier = "Enterprise Tier 1"
  c.hiring_velocity_score = 92.0
  c.notes = "Fast-scaling enterprise account with 20+ open engineering roles."
  c.ai_summary = "High-velocity tech enterprise focusing on high-scale distributed systems and developer tooling."
end

company2 = Company.find_or_create_by!(name: "Vortex Financial Systems") do |c|
  c.industry = "Fintech & Payments"
  c.website = "https://vortexpay.com"
  c.tier = "Strategic Partner"
  c.hiring_velocity_score = 88.5
  c.notes = "Fintech company hiring senior Rails and PostgreSQL architects."
  c.ai_summary = "Leading fintech provider building high-throughput payment settlement monoliths."
end

# 2. Evaluator Users
lead_evaluator = User.find_or_create_by!(email: "evaluator@signal.ai") do |u|
  u.name = "Elena Rostova"
  u.role = "hiring_manager"
end

recruiter = User.find_or_create_by!(email: "recruiter@signal.ai") do |u|
  u.name = "Marcus Vance"
  u.role = "recruiter"
end

# 3. Job Postings
rails_job = JobPosting.find_or_create_by!(title: "Principal Rails Architect") do |j|
  j.company = company1
  j.department = "Engineering"
  j.description = "Lead system design and performance scaling for core high-throughput Monolith architecture. Deep expertise in Ruby 3.4+, Hotwire, PostgreSQL, pgvector, and distributed systems."
  j.location = "San Francisco, CA (Hybrid)"
  j.min_salary = 180000
  j.max_salary = 240000
  j.status = "active"
end

fintech_job = JobPosting.find_or_create_by!(title: "Staff Fintech Platform Engineer") do |j|
  j.company = company2
  j.department = "Fintech Core"
  j.description = "Build secure payment engines and real-time transaction ledgers using Rails and PostgreSQL."
  j.location = "New York, NY (Remote)"
  j.min_salary = 175000
  j.max_salary = 230000
  j.status = "active"
end

# Skill Requirements for Rails Job
skills_rails = [
  { name: "Ruby on Rails 8 / Architecture", weight: 3.0, minimum_score: 4, rubric_description: "Demonstrated experience designing high-scale Rails monoliths, Hotwire Turbo Frames, and Solid Queue." },
  { name: "PostgreSQL & pgvector Performance", weight: 2.5, minimum_score: 4, rubric_description: "Query optimization, indexing strategies, vector embeddings, and zero N+1 execution." },
  { name: "System Design & Domain Modeling", weight: 2.0, minimum_score: 3, rubric_description: "Skinny controllers, service objects, clear model boundaries, and event-driven architecture." },
  { name: "Frontend Hotwire & Stimulus JS", weight: 1.5, minimum_score: 3, rubric_description: "Building responsive, zero-page-reload UIs with Turbo Streams and Stimulus JS controllers." }
]

skills_rails.each do |skill|
  rails_job.skill_requirements.find_or_create_by!(name: skill[:name]) do |s|
    s.weight = skill[:weight]
    s.minimum_score = skill[:minimum_score]
    s.rubric_description = skill[:rubric_description]
  end
end

# Pipeline Stages
stages_rails = [
  { name: "Screening", position: 0, stage_type: "screening", exit_criteria: "Recruiter call passed & resume match > 70%" },
  { name: "Technical Assessment", position: 1, stage_type: "technical_assessment", exit_criteria: "Architectural take-home code submission complete" },
  { name: "System Design Interview", position: 2, stage_type: "interview", exit_criteria: "Passed live design interview with Principal Architect" },
  { name: "Offer Extended", position: 3, stage_type: "offer", exit_criteria: "Exec approval & compensation agreement" }
]

stages_rails.each do |st|
  rails_job.pipeline_stages.find_or_create_by!(name: st[:name]) do |s|
    s.position = st[:position]
    s.stage_type = st[:stage_type]
    s.exit_criteria = st[:exit_criteria]
  end
end

# 4. Rich Candidates
candidate1 = Candidate.find_or_create_by!(email: "alex.dev@gmail.com") do |c|
  c.first_name = "Alex"
  c.last_name = "Rivers"
  c.title = "Staff Rails Architect"
  c.location = "San Francisco, CA"
  c.portfolio_url = "https://github.com/arivers-rails"
  c.resume_text = "Staff Software Engineer with 9 years of Ruby on Rails experience. Built multi-tenant platforms handling 50k RPM. Expert in PostgreSQL query optimization, pgvector similarity search, Hotwire Turbo, Solid Queue, and Stimulus JS."
  c.ai_summary = "Top 1% candidate with extensive experience scaling Rails monoliths and pgvector search engines."
  c.career_trajectory = "Ascending Staff / Principal Architect"
  c.estimated_compensation = 225000
  c.fit_score = 96.5
  c.tags = "rails,postgres,pgvector,hotwire,system-design"
end

# Add Experience Timeline
CandidateExperience.find_or_create_by!(candidate: candidate1, company_name: "Stripe", role_title: "Senior Staff Engineer") do |e|
  e.duration = "2021 - Present"
  e.description = "Led payments infrastructure core monolith scaling. Re-architected query pipelines for 99.999% availability."
  e.skills_used = "Ruby, Rails, PostgreSQL, Distributed Systems"
end

CandidateExperience.find_or_create_by!(candidate: candidate1, company_name: "GitHub", role_title: "Senior Backend Engineer") do |e|
  e.duration = "2018 - 2021"
  e.description = "Maintained core Rails codebase and search indexing infrastructure."
  e.skills_used = "Rails, C extensions, Redis, MySQL"
end

candidate2 = Candidate.find_or_create_by!(email: "sophia.chen@tech.io") do |c|
  c.first_name = "Sophia"
  c.last_name = "Chen"
  c.title = "Senior Full-Stack Engineer"
  c.location = "New York, NY"
  c.portfolio_url = "https://sophiachen.dev"
  c.resume_text = "Senior Full-Stack Engineer specializing in React, Next.js, and Ruby on Rails APIs. Strong background in microservices, GraphQL, Docker, and Redis. Passionate about slick UI/UX and high-density dashboard design."
  c.ai_summary = "Versatile full-stack engineer with strong product UI intuition and solid Rails API knowledge."
  c.career_trajectory = "Senior Product & Systems Engineer"
  c.estimated_compensation = 195000
  c.fit_score = 88.0
  c.tags = "react,rails,graphql,stimulus,docker"
end

# Applications & Evaluations
screening_stage = rails_job.pipeline_stages.find_by(name: "Screening")
interview_stage = rails_job.pipeline_stages.find_by(name: "System Design Interview")

app1 = CandidateApplication.find_or_create_by!(candidate: candidate1, job_posting: rails_job) do |a|
  a.current_stage = interview_stage
  a.status = "active"
end

app2 = CandidateApplication.find_or_create_by!(candidate: candidate2, job_posting: rails_job) do |a|
  a.current_stage = screening_stage
  a.status = "active"
end

rails_job.skill_requirements.each do |skill|
  score = case skill.name
          when /Architecture/ then 5
          when /PostgreSQL/ then 5
          when /System Design/ then 4
          else 4
          end

  e = Evaluation.find_or_initialize_by(candidate_application: app1, skill_requirement: skill, evaluator: lead_evaluator)
  e.score = score
  e.notes = "Outstanding performance during system design interview. Clear understanding of monolith scale trade-offs."
  e.save!
end

app1.recalculate_overall_score!

puts "Seeding complete! Griffin Enterprise ATS & CRM database initialized."
