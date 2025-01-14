require "httparty"

class FetchAllLoans
  def self.fetch_all_loans
    api_url = "https://absws.com/TmoAPI/v1/LSS.svc/GetLoans"

    response = HTTParty.get(api_url)

    if response.success?
      JSON.parse(response.body)["Data"]
    else
      puts "Error fetching loans : #{response.code}"
      []
    end
  end
end
