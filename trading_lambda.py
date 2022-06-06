import alpaca_trade_api as tradeapi
import os

def handler(event, context):
    print("Hello world! Let's buy some stocks!")

    stocks_to_buy = ["GME"]

    print("Lets buy these stocks!")
    for x in stocks_to_buy:
        print(x)
    
    alpaca_api_key_id = os.environ['key_id']
    alpaca_api_secret_key = os.environ['secret_key']
    alpaca_api_api_version = os.environ['api_version']
    alpaca_api_base_url = os.environ['base_url']

    api = tradeapi.REST(key_id=alpaca_api_key_id, secret_key=alpaca_api_secret_key, api_version=alpaca_api_api_version,
                        base_url=alpaca_api_base_url)

    for stock in stocks_to_buy:
        api.submit_order(stock, 1, 'buy', 'limit', 'gtc', limit_price='130', stop_price=None, client_order_id=None,
                         extended_hours=None)
    