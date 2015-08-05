# finance.vim

Simple plugin for checking your stock in Vim (Yahoo Finance).

# Requirements

- [webapi-vim][]

# Usage

    let g:finance_watchlist = ['0005.HK', 'GOOG']
    let g:finance_format' = '{symbol}: {LastTradePriceOnly} ({Change})'
    let g:finance_separator' = "\n"

    :Finance

    :Finance 0005.HK
    :Finance 0005.HK GOOG

[webapi-vim]: https://github.com/mattn/webapi-vim
