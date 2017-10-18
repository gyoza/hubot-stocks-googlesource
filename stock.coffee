# Description:
#   Get a stock price from iextrading since google sucks, and since yahoo sucks.
#   they have officially deprecated their useful apis.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot stock [info|quote|price] [for|me] <ticker> 
#
# NOT FUNCTIONING YET [1d|5d|2w|1mon|1y] - Get a stock price
#
# Author:
#   eliperkins
#   maddox
#   johnwyles
#   new iextrading/google mods by gyoza 
#
# old url bits keeping them here cause im lazy &p=#{time}&i=250#.png

module.exports = (robot) ->
  robot.respond /stock (?:info|price|quote)?\s?(?:for|me)?\s?@?([A-Za-z0-9.-_]+)\s?(\d+\w+)?/i, (msg) ->
    ticker = escape(msg.match[1]).toUpperCase()
    time = msg.match[2] || '60d'
    msg.http({timeout: 30000}, 'https://api.iextrading.com/1.0/stock/'+ticker+'/quote')
      .get() (err, res, body) ->
        try
          result = JSON.parse(body.replace(/\/\/ /, ''))
          popen = result['open']
          if popen is null
            msg.send "Some kind of error occured! (Bad Symbol?)"
          else 
            result = JSON.parse(body.replace(/\/\/ /, ''))
            symbol = result['symbol']
            company = result['companyName']
            exchange = result["primaryExchange"]
            sector = result['sector']
            iexRealtimePrice = result['iexRealtimePrice']
            msg.send "#{time} overview - https://www.google.com/finance/getchart?q=#{ticker}#.png"
            msg.send "#{company} [#{symbol}] #{exchange} - #{sector}" 
            msg.send "Real-time price: #{iexRealtimePrice}" 
        catch e 
          msg.send "Some kind of error occured! (Bad Symbol?)" 
        