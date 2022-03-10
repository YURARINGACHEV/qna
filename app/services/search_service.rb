class SearchService
  TYPES = %w[Question Answer User Comment]

  def self.search_by(body, type = nil)
    if body.empty?
      return []
    end

    TYPES.include?(type) ? Object.const_get(type).search(body) : ThinkingSphinx.search(body)
  end
end 