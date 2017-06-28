# Description:
#   Get a stock price from google since yahoo sucks.
#   they have officially deprecated their API around may 2017.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot stock [info|quote|price] [for|me] <ticker> [1d|5d|2w|1mon|1y] - Get a stock price
#
# Author:
#   eliperkins
#   maddox
#   johnwyles
#   new google mods by gyoza 

module.exports = (robot) ->
  robot.respond /stock (?:info|price|quote)?\s?(?:for|me)?\s?@?([A-Za-z0-9.-_]+)\s?(\d+\w+)?/i, (msg) ->
    ticker = escape(msg.match[1]).toUpperCase()
    time = msg.match[2] || '60d'
    msg.http('http://finance.google.com/finance/info?client=ig&q=' + ticker)
      .get() (err, res, body) ->
        try
          result = JSON.parse(body.replace(/\/\/ /, ''))
          msg.send "#{time} overview - https://www.google.com/finance/getchart?q=#{ticker}&p=#{time}&i=250#.png"
          msg.send result[0].l_cur + "(#{result[0].c})"
        catch e
          msg.send "Some kind of error occured! (Bad Symbol?)"
          return