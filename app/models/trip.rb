class Trip < ActiveRecord::Base
	belongs_to :user
         
  def check_in
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
      button = form.button_with(:value => "Check In")
      
      agent.submit(form, button)
    rescue
      puts "proxy index #{i} failed"
      i += 1
      retry
    end
  end
end

# During DST, shift is UTC -(n-1), e.g. Eastern is UTC-5 normally, UTC-4 during DST