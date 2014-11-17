class UserSearch

  def self.search(string)
    results = JSON.parse(HesburghAPI::PersonSearch.search(string + '*').to_json)
  end

end
