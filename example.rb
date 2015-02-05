require_relative "keybase_btc"

# FUNC 1
# find other btc address
#
# KeybaseBtc.configs.username = "my_username"
#
#
# KeybaseBtc.me.find!

KeybaseBtc.configs.username = "makevoid"
puts "users: "
puts KeybaseBtc.me.find_users!
puts "btc addresses: "
puts KeybaseBtc.me.find_btc_addresses!

# # db/usernames.hson
# USERNAMES = ["...", "...", "..."] #...

# # ADDON
# #
# # OnenameIo.search

# # FUNC 2
# #
# # Give him a private key with X
# # everytime it will receive btc, even 0.1
# # It will donate X to the selected usernames

# WalletBtc.send(%w(username1 username2))
