class Trip < ActiveRecord::Base
	belongs_to :user
         
  def check_in
    agent = Mechanize.new
    
    agent.robots = false
    agent.user_agent_alias = (Mechanize::AGENT_ALIASES.keys - ['Mechanize']).sample
    
    #agent.set_proxy {ip}, {port}

    ci_response = agent.post('https://www.southwest.com/flight/retrieveCheckinDoc.html', { 'confirmationNumber' => self.confirmation_number, 'firstName' => self.user.first_name, 'lastName' => self.user.last_name, 'submitButton' => 'Check In' })
    
    form = ci_response.form_with(:name => "checkinOptions")
    button = form.button_with(:value => "Check In")
    
    agent.submit(form, button)
  end
end

# curl -H "Content-Type: application/json" -X POST -d '{"username":"xyz","password":"xyz"}' http://localhost:3000/api/login
