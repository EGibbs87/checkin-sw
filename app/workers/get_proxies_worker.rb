class GetProxiesWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'high'

  def perform
    agent = Mechanize.new
    
    Proxy.destroy_all
    
    response = agent.get("https://www.us-proxy.org")
    table = response.at('table')
    rows = table.search('tr')
    
    rows[1..-2].each do |r|
      tds = r.search('td')
      Proxy.create(ip: tds[0].text, port: tds[1].text)
    end
      
  end
end
