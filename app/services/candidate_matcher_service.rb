# frozen_string_literal: true

class CandidateMatcherService
  VECTOR_DIMENSIONS = 1536

  attr_reader :job_posting, :limit

  def initialize(job_posting, limit: 10)
    @job_posting = job_posting
    @limit = limit
  end

  # Returns array of candidate match structures:
  # [ { candidate: Candidate, match_percentage: Float, distance: Float, score: Float }, ... ]
  def call
    query_vector = generate_job_vector(job_posting)

    # Use pgvector cosine distance: embedding <=> '[v1, v2, ...]'
    if candidate_embeddings_present?
      fetch_pgvector_matches(query_vector)
    else
      fetch_ruby_similarity_matches(query_vector)
    end
  end

  private

  def fetch_pgvector_matches(query_vector)
    formatted_vector = "[#{query_vector.join(',')}]"
    
    candidates = Candidate
      .where.not(embedding: nil)
      .select("candidates.*, (embedding <=> '#{formatted_vector}') AS distance")
      .order(Arel.sql("embedding <=> '#{formatted_vector}' ASC"))
      .limit(limit)

    candidates.map do |candidate|
      distance = candidate.try(:distance)&.to_f || 0.5
      match_pct = [((1.0 - distance) * 100).round(1), 0.0].max
      
      {
        candidate: candidate,
        distance: distance.round(4),
        match_percentage: match_pct,
        top_skills: candidate.resume_text.to_s.scan(/\b(Ruby|Rails|PostgreSQL|React|Hotwire|Python|AWS|GraphQL|TypeScript|Docker)\b/i).flatten.uniq
      }
    end
  end

  def fetch_ruby_similarity_matches(query_vector)
    candidates = Candidate.all.limit(limit * 2)

    results = candidates.map do |candidate|
      cand_vector = candidate.embedding.present? ? candidate.embedding : generate_text_vector(candidate.resume_text)
      distance = cosine_distance(query_vector, cand_vector)
      match_pct = [((1.0 - distance) * 100).round(1), 0.0].max

      {
        candidate: candidate,
        distance: distance.round(4),
        match_percentage: match_pct,
        top_skills: candidate.resume_text.to_s.scan(/\b(Ruby|Rails|PostgreSQL|React|Hotwire|Python|AWS|GraphQL|TypeScript|Docker)\b/i).flatten.uniq
      }
    end

    results.sort_by { |r| -r[:match_percentage] }.take(limit)
  end

  def candidate_embeddings_present?
    Candidate.where.not(embedding: nil).exists?
  end

  # Generates a synthetic embedding vector from job title, department & skill requirements
  def generate_job_vector(posting)
    combined_text = "#{posting.title} #{posting.department} #{posting.description} " +
                    posting.skill_requirements.pluck(:name, :rubric_description).flatten.join(" ")
    generate_text_vector(combined_text)
  end

  # Fallback deterministic pseudo-embedding generator based on textual features
  def generate_text_vector(text)
    words = text.to_s.downcase.scan(/\w+/)
    vector = Array.new(VECTOR_DIMENSIONS, 0.0)

    words.each_with_index do |word, i|
      hash_val = word.sum
      idx = hash_val % VECTOR_DIMENSIONS
      vector[idx] += 1.0 / (i + 1)
    end

    # Normalize vector to unit length
    magnitude = Math.sqrt(vector.sum { |x| x * x })
    return vector if magnitude.zero?

    vector.map { |x| x / magnitude }
  end

  def cosine_distance(v1, v2)
    dot_product = v1.zip(v2).sum { |a, b| a * b }
    mag1 = Math.sqrt(v1.sum { |x| x * x })
    mag2 = Math.sqrt(v2.sum { |x| x * x })

    return 1.0 if mag1.zero? || mag2.zero?
    cosine_sim = dot_product / (mag1 * mag2)
    1.0 - cosine_sim
  end
end
