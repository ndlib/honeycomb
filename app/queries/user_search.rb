class UserSearch

  def self.search(string)
    results = HesburghAPI::PersonSearch.search(URI::encode(string) + '*')
    if !results.blank?
      JSON.parse(results.to_json)
    else
      nil
    end
  end

end
