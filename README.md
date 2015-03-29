# stock.vim

Simple plugin for checking your stock in Vim.

# Requirements

- [webapi-vim][]

# Usage

    :Stock 00005:HK
    :Stock 00005:HK 02800:HK

    // Optional: add into .vimrc for checking automatically
    autocmd CursorHold * call Stock()
    let g:stock_watchlist = ['00005:HK', '02800:HK']

[webapi-vim]: https://github.com/mattn/webapi-vim
