class GetProxiesWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'high'

  def perform
    agent = Mechanize.new
    
    Proxy.destroy_all
    
    response = agent.get("https://hidemy.name/en/proxy-list/?maxtime=1500")
    pages = response.at('div', :id => 'proxy__pagination').search('ul')[5].search('li').last.text.to_i
    
    pages.times do |i|
      n = i * 64
      response = agent.get("https://hidemy.name/en/proxy-list/?maxtime=1500&start=#{n}#list")
      table = response.at('table')
      rows = table.search('tr')
      
      rows[1..-1].each do |r|
        tds = r.search('td')
        Proxy.create(ip: tds[0].text, port: tds[1].text)
      end
    end
      
  end
end
