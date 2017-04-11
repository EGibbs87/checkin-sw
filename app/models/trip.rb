class Trip < ActiveRecord::Base
	belongs_to :user
         
  def check_in
    GetProxiesWorker.perform_async
    # allow testing
    # if DateTime.now > DateTime.new(2017,4,8,12,19)
    #   sleep(9.minutes + 50.seconds)
    # end
    
    if DateTime.now.to_date == self.depart_time.to_date - 1.day
      direction = "depart"
      flight_time = self.depart_time
    else
      direction = "return"
      flight_time = self.return_time
    end
    
    # set amount of time to sleep (to start process 20 seconds before checkin time)
    sleep_time = ((flight_time.strftime("%M").to_i - DateTime.now.strftime("%M").to_i).minutes - 20.seconds)
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
      
      # raise error if response includes "24 hours" (tried too early)
       if f_response.content.match("24 hours")
         proxy_retry = 1
         raise
       end
    rescue
      if proxy_retry == 1
        puts "Tried pulling too early; retry with same proxy"
        proxy_retry = 0
      else
        puts "Proxy index #{i} failed; retry with next proxy"
        i += 1
      end
      retry
    end
  end
end