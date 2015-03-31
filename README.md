# finance.vim

Simple plugin for checking your stock in Vim (Yahoo Finance).

# Requirements

- [webapi-vim][]

# Usage

    let g:finance_watchlist = ['0005.HK', 'GOOG']

    :Finance

    :Finance 0005.HK
    :Finance 0005.HK GOOG

    // Optional: add into .vimrc for checking automatically
    autocmd FocusLost * call Finance()

[webapi-vim]: https://github.com/mattn/webapi-vim
