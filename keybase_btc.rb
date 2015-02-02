require 'net/http'
require 'json'


USER_URL = "https://keybase.io/_/api/1.0/user/lookup.json?usernames=%s"

def btc_address(username)
  url = USER_URL % username
  user = get_json url
  user
end

def get_json(url)
	resp = Net::HTTP.get_response URI url
	resp.body
end