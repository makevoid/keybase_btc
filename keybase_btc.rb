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


class BTCBalance
  BLOCKCHAIN_INFO_BALANCE = "https://blockchain.info/q/addressbalance/%s"

  # current BTC balance
  def self.get(address)
    url = BLOCKCHAIN_INFO_BALANCE % address
    resp = Net::HTTP.get_response URI url
    resp.body.strip
  end
end

class KeybaseBtc

  MY_KEYBASE_USERNAME = "makevoid"

  KEYBASE_HOST = "keybase.io"

  USER_URL = "https://keybase.io/_/api/1.0/user/lookup.json?usernames=%s"

  class Me

    USERS = %w(
      2bithacker
      allanjude
      andymatuschak
      arrdem
      barrysilbert
      ben0xa
      bl1nk
      brianleroux
      cabel
      chadilaksono
      chris
      claco
      daniellindsley
      darrenkitchen
      drewcosten
      duncan
      dwetterau
      elia
      eliw
      ernie
      fallenpegasus
      freebsdgirl
      gattaca
      georgestarcher
      gesa
      ginatrapani
      gpgtools
      hergertme
      ircmaxell
      jacopo
      jadedsecurity
      jeresig
      jodal
      jorge
      jt
      kaepora
      kend
      kitsunet
      kriztw
      leolaporte
      leongersing
      leorossi
      lindsey
      ljharb
      lordvan
      lukestokes
      mathowie
      mclovin
      merrin
      mfrost503
      mieleton
      mikispag
      minter
      moeffju
      mpapis
      naval
      nickfarr
      oleganza
      oleks
      paulirish
      pc
      pento
      ranterle
      sanitybit
      savagejen
      securitymoey
      seldo
      selenamarie
      slexaxton
      spierenburg
      tenderlove
      timbray
      ttscoff
      winnie
      wouldgo
      yaakovsloman
      you
      zaux
    )

    BTC_ADDRESSES = [
      # { username: "jacopo", btc_address: "a890sduasoihdaoisd" },
      {:username=>"2bithacker", :btc_address=>"1F7Ra5oAVkNyzzHvHRPfG1oaJiSTUfT4AX"},
      {:username=>"andymatuschak", :btc_address=>"13A5d82zV1SYxkQvC5KzaYzdE9Xmfbzt6A"},
      {:username=>"bl1nk", :btc_address=>"1MqAzUrRSsgxM8Wkz2aSfbTzozXxaX8wxz"},
      {:username=>"brianleroux", :btc_address=>"17VdEgQ1CmvgfVAbNTwfaHYD3W1n6ZruhC"},
      {:username=>"chris", :btc_address=>"1MPt9BuAVM6YphzyBCNUXkh5dprThwSvbD"},
      {:username=>"claco", :btc_address=>"1PpsStGPTicDMx36iSCQkeb6KiGPYurPoo"},
      {:username=>"drewcosten", :btc_address=>"18PEaDvRm7asbR834kgcGwyhxybdURb7UY"},
      {:username=>"dwetterau", :btc_address=>"1NSQXEaV7jjhAk2nDJpRKKvGuZC5GQAC3p"},
      {:username=>"elia", :btc_address=>"147kK1kFdmJCxkQm1gJiRxAe4jre5HxZqC"},
      {:username=>"georgestarcher", :btc_address=>"1FcVweJwUWo9LsPKEuo8xbcqB6hXoo7sSn"},
      {:username=>"gesa", :btc_address=>"17ULaKqAYYQtrE1e6P2HBDjYyXieWizQ6V"},
      {:username=>"ginatrapani", :btc_address=>"16LnbBqRzmYbr15L1K2cQPrbhKrmLacvsH"},
      {:username=>"jacopo", :btc_address=>"12YRm2ihZ4QJm8QKunbwESF8Q4TCriwyg9"},
      {:username=>"ljharb", :btc_address=>"14UiBqcTcQ357ea6inKS9Jpc6QPR1JxmWL"},
      {:username=>"mikispag", :btc_address=>"1MikiSPbrhCFk7S4wzZP7gQqhwWH866DCb"},
      {:username=>"moeffju", :btc_address=>"1CVnD1dd9UP8EGnUaKRGoyHnYbuTSQQxCD"},
      {:username=>"paulirish", :btc_address=>"1Fgk8THhgN1Zpbnr3vP6xFnhmk5zt8qpHh"},
      {:username=>"slexaxton", :btc_address=>"1B6zNKtSyUbFmHE84K6R7iE6GaqcfTHhSn"},
      {:username=>"yaakovsloman", :btc_address=>"17kfeDHdgrHLGRz71LzmLM9MTrSjGKJ1qR"},
    ]

    attr_reader :username

    def initialize(username: username)
      @username = username
    end

    def find_users!
      url   = "https://#{KEYBASE_HOST}/#{username}"
      agent = Mechanize.new
      # 20.times do |num|
      20.times do |num|
        page  = agent.get url
        links = page.search(".td-follower-info a:first")
        links.each do |link|
          USERS << link.text
        end
      end
      USERS.sort!
      USERS.uniq!
      USERS
    end

    def find_btc_addresses!
      find_users!

      agent = Mechanize.new
      USERS.each do |username|
        url   = "https://#{KEYBASE_HOST}/#{username}"
        page  = agent.get url
        btc_address = page.search(".currency-address").inner_text
        BTC_ADDRESSES << {
          username: username,
          btc_address: btc_address,
        } if btc_address && !btc_address.empty?
      end
      BTC_ADDRESSES
    end

    def find_btc_addresses_w_balance!
      find_btc_addresses!
      BTC_ADDRESSES.each do |btc_addr|
        btc_addr["balance"] = BTCBalance.get(btc_addr["btc_address"])
      end
      BTC_ADDRESSES
    end
  end

  def self.me
    Me.new username: configs.username
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

  def test(username)
    url  = USER_URL % username
    user = get_json url
    user
  end

  def get_json(url)
    resp = Net::HTTP.get_response URI url
    resp.body
  end

end
