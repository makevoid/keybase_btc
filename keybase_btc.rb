require 'net/http'
require 'json'

require 'mechanize'
# FUNC 1
# find other btc address
#
# KeybaseBtc.configs.username = "my_username"
#
#
# KeybaseBtc.me.find!

# FUNC 2
#
# Give him a private key with X
# everytime it will receive btc, even 0.1
# It will donate X

require 'hashie/mash'

class KeybaseBtc

  MY_KEYBASE_USERNAME = "makevoid"

  KEYBASE_HOST = "keybase.io"

  USER_URL = "https://keybase.io/_/api/1.0/user/lookup.json?usernames=%s"

  USERS = [
    "nickfarr
    mfrost503
    jt
    dwetterau
    oleganza
    leorossi
    elia
    wouldgo
    jacopo
    chris
    ",
    #.... etc
  ]

  class Me
    def self.find!
      url   = "https://#{KEYBASE_HOST}/#{username}"
      agent = Mechanize.new 
      page  = agent.get url
      puts page.body.inspect
    end
  end

  def self.me
    Me.new
  end

  def self.configs
    @@configs = Hashie::Mash.new username: nil
  end

  def configs
    @@configs
  end

  def username
    configs.username
  end

  def 
    (username)
    url  = USER_URL % username
    user = get_json url
    user
  end

  def get_json(url)
    resp = Net::HTTP.get_response URI url
    resp.body
  end

end