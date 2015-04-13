class PersonAPISearch
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def results
    @results ||= formatted_results
  end

  def self.call(query)
    new(query).results
  end

  private

  def formatted_results
    raw_results = api_results
    if raw_results.present?
      raw_results.map do |result|
        {
          id: result['uid'],
          label: result['full_name'],
          value: result['full_name']
        }
      end
    else
      []
    end
  end

  def encoded_query
    if query.present?
      URI.encode(query)
    end
  end

  def query_search_string
    if encoded_query.present?
      encoded_query + '*'
    end
  end

  def api_results
    search = query_search_string
    if search.present?
      HesburghAPI::PersonSearch.search(search)
    else
      []
    end
  end
end
