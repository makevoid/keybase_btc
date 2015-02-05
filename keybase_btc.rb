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
      { username: "jacopo", btc_address: "a890sduasoihdaoisd" },
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
