class Trip < ActiveRecord::Base
	belongs_to :user
         
  def check_in
    agent = Mechanize.new
    
    agent.robots = false
    
    Proxy.all.each do |proxy|
      agent.user_agent_alias = (Mechanize::AGENT_ALIASES.keys - ['Mechanize']).sample
      
      agent.set_proxy proxy.ip, proxy.port
  
      ci_response = agent.post('https://www.southwest.com/flight/retrieveCheckinDoc.html', { 'confirmationNumber' => self.confirmation_number, 'firstName' => self.user.first_name, 'lastName' => self.user.last_name, 'submitButton' => 'Check In' })
    end
      
    form = ci_response.form_with(:name => "checkinOptions")
    button = form.button_with(:value => "Check In")
    
    agent.submit(form, button)
  end
end

def run
  failed = []
  worked = []
  Proxy.all.each do |proxy|
    agent = Mechanize.new
    agent.set_proxy proxy.ip, proxy.port
    begin
      agent.get('http://www.google.com')
      puts proxy.id
      puts agent.response
      worked << proxy.id
    rescue
      failed << proxy.id
    end
  end
end

def individ_run(id)
  failed = []
  worked = []
  proxy = Proxy.find(id)
  agent = Mechanize.new
  agent.set_proxy proxy.ip, proxy.port
  t = Trip.first
  ci_response = agent.post('https://www.southwest.com/flight/retrieveCheckinDoc.html', { 'confirmationNumber' => t.confirmation_number, 'firstName' => t.user.first_name, 'lastName' => t.user.last_name, 'submitButton' => 'Check In' })
  
  return response
    
end

