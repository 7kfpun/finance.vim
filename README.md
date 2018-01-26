## finance.vim

Checking US Stocks and Exchange Rates in Vim (Alpha Vantage).

![Screenshot](screenshot.png)

## Requirements

- [webapi-vim](https://github.com/mattn/webapi-vim)

## Usage

    :Finance
    :Finance GOOG
    :Finance FB GOOG

    :Exchange
    :Exchange USD HKD
    :Exchange BTC USD
    " It can either be a [physical currency](https://www.alphavantage.co/physical_currency_list/) or [digital/crypto currency](https://www.alphavantage.co/digital_currency_list/)

## Install

*  [Pathogen](https://github.com/tpope/vim-pathogen)
  * `git clone https://github.com/7kfpun/finance.vim.git ~/.vim/bundle/finance.vim`
*  [vim-plug](https://github.com/junegunn/vim-plug)
  * `Plug '7kfpun/finance.vim'`
*  [NeoBundle](https://github.com/Shougo/neobundle.vim)
  * `NeoBundle '7kfpun/finance.vim'`
*  [Vundle](https://github.com/gmarik/vundle)
  * `Plugin '7kfpun/finance.vim'`

## Settings

    let g:finance_watchlist = ['AAPL', 'GOOG', 'MSFT', 'AMZN', 'FB'])
    let g:finance_format = '{1. symbol}: {2. price} ({3. volume})')
    let g:finance_separator = "\n"

    let g:exchange_currencies = ['BTC', 'USD']
    let g:exchange_format = '1 {1. From_Currency Code} = {5. Exchange Rate} {3. To_Currency Code}'


## QuoteProperty

    " Finance
    1. symbol
    2. price
    3. volume
    4. timestamp

    " Exchange
    1. From_Currency Code
    2. From_Currency Name
    3. To_Currency Code
    4. To_Currency Name
    5. Exchange Rate
    6. Last Refreshed
    7. Time Zone
