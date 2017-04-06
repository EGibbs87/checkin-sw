class Trip < ActiveRecord::Base
	belongs_to :user
         
  def check_in
    agent = Mechanize.new
    
    agent.robots = false
    agent.user_agent_alias = (Mechanize::AGENT_ALIASES.keys - ['Mechanize']).sample 

    ci_response = agent.post('https://www.southwest.com/flight/retrieveCheckinDoc.html', { 'confirmationNumber' => self.confirmation_number, 'firstName' => self.user.first_name, 'lastName' => self.user.last_name, 'submitButton' => 'Check In' })
  end
end
