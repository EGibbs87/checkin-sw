class Trip < ActiveRecord::Base
	belongs_to :user
         
  def check_in
    GetProxiesWorker.perform_async
    # allow testing
    if DateTime.now > DateTime.new(2017,4,8,12,19)
      sleep(9.minutes + 50.seconds)
    end
    agent = Mechanize.new
    
    agent.robots = false
    i = 0
    proxies = Proxy.all
    begin
      puts "trying proxy index #{i}"
      proxy = proxies[i]
      agent.user_agent_alias = (Mechanize::AGENT_ALIASES.keys - ['Mechanize']).sample
      
      agent.set_proxy proxy.ip, proxy.port
  
      ci_response = agent.post('https://www.southwest.com/flight/retrieveCheckinDoc.html', { 'confirmationNumber' => self.confirmation_number, 'firstName' => self.user.first_name, 'lastName' => self.user.last_name, 'submitButton' => 'Check In' })
        
      form = ci_response.form_with(:name => "checkinOptions")
      if form.nil?
        form = ci_response.form_with(:name => "retrieveItinerary")
      end
      button = form.button_with(:value => "Check In")
      
      
      f_response = agent.submit(form, button)
      
      # force a random error if response includes "24 hours" (tried too early)
       if f_response.content.match("24 hours")
         puts "Too early, trying again"
         a = nil
         a.strftime("%Y-%m")
       end
    rescue
      puts "proxy index #{i} failed"
      i += 1
      retry
    end
  end
end