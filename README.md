# finance.vim

Simple plugin for checking your stock in Vim (Yahoo Finance).

# Requirements

- [webapi-vim][]

# Usage

    :Finance 0005.HK
    :Finance 0005.HK GOOG

    // Optional: add into .vimrc for checking automatically
    autocmd CursorHold * call Finane()
    let g:stock_watchlist = ['0005.HK', 'GOOG']

[webapi-vim]: https://github.com/mattn/webapi-vim
