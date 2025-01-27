require "httparty"
require "nokogiri"

class WebScrapper
  include HTTParty

  def initialize(url)
    @url = url
  end

  def fetch_data
    response = HTTParty.get(
      @url,
      headers: {
        "Cookie" => "ASP.NET_SessionId=mk1iod212vogc01b4lteaxqv; .ASPXAUTH=CADBB8FF755E838B0F24E1675F31C4F393A760141D37876280524369182C69A5B76AE1B61A0DDFB45CE11407C31C3A2C78C5DDFEB2EBC0862E03A04D7807E1F09DD38962D6AEE0A21EFCCA21170A866EA6D948DCD30526DD613C460C890F3B7510FEEEF9505EC64070297DAAB623F3425367E61A426F739C893E5E81CB7747C668DA5DC9A7B81815D8ECDF1D69B39B5F",
        "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
        "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "Accept-Encoding" => "gzip, deflate, br, zstd",
        "Accept-Language" => "en-US,en;q=0.9",
        "Cache-Control" => "no-cache",
        "Pragma" => "no-cache",
        "Referer" => "https://www.borrowersviewcentral.com/Default.aspx?ReturnUrl=%2fAcctOverview.aspx",
        "Upgrade-Insecure-Requests" => "1",
        "Sec-Ch-Ua" => '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"',
        "Sec-Ch-Ua-Mobile" => "?0",
        "Sec-Ch-Ua-Platform" => '"Windows"',
        "Sec-Fetch-Dest" => "document",
        "Sec-Fetch-Mode" => "navigate",
        "Sec-Fetch-Site" => "same-origin",
        "Sec-Fetch-User" => "?1",
        "Priority" => "u=0, i"
      },
      verify: false # Skip SSL verification (use cautiously)
    )

    if response.code == 200
      puts "Data fetched successfully!"
      parse_html(response.body)
    else
      puts "Failed to fetch data, status code: #{response.code}"
    end
  end

  def parse_html(html)
    doc = Nokogiri::HTML(html)

    doc.css("table tr").each_with_index do |row, index|
        cells = row.css("td").map(&:text).map(&:strip)
        puts "Row #{index}: #{cells.join(', ')}" unless cells.empty?
    end

    title = doc.("#AccountInfo_BorrowerName")&.text
    puts "Page Title :#{title}"
  end
end

# Example usage
scraper = WebScrapper.new("https://www.borrowersviewcentral.com/History.aspx")
scraper.fetch_data
