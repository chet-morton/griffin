namespace :export do
  desc "Export Rails pages to static HTML for GitHub Pages"
  task static: :environment do
    require "fileutils"

    Rails.application.config.hosts.clear

    out_dir = Rails.root.join("out")
    FileUtils.mkdir_p(out_dir)

    session = ActionDispatch::Integration::Session.new(Rails.application)
    session.host = "localhost"

    routes_to_export = [
      { path: "/", file: "index.html" },
      { path: "/job_postings/new", file: "job_postings/new/index.html" },
      { path: "/job_postings/1/pipeline", file: "job_postings/1/pipeline/index.html" },
      { path: "/candidate_applications/4", file: "candidate_applications/4/index.html" },
      { path: "/candidate_applications/5", file: "candidate_applications/5/index.html" },
      { path: "/job_postings/1/candidate_matches", file: "job_postings/1/candidate_matches/index.html" },
      { path: "/companies", file: "companies/index.html" },
      { path: "/companies/1", file: "companies/1/index.html" },
      { path: "/companies/new", file: "companies/new/index.html" },
      { path: "/candidates", file: "candidates/index.html" },
      { path: "/candidates/1", file: "candidates/1/index.html" },
      { path: "/analytics", file: "analytics/index.html" }
    ]

    routes_to_export.each do |route|
      session.get(route[:path])
      if session.response.successful?
        target_file = out_dir.join(route[:file])
        FileUtils.mkdir_p(target_file.dirname)
        
        File.write(target_file, session.response.body)
        puts "Exported #{route[:path]} -> #{target_file}"
      else
        puts "Failed to export #{route[:path]}: status #{session.response.status}"
      end
    end

    # Copy index.html to 404.html for SPA fallback routing
    if File.exist?(out_dir.join("index.html"))
      FileUtils.cp(out_dir.join("index.html"), out_dir.join("404.html"))
    end

    # Create .nojekyll file for GitHub Pages
    File.write(out_dir.join(".nojekyll"), "")
    puts "Static export complete in ./out directory."
  end
end
