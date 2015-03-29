" stock-vim - Check stock in vim
" Maintainer: kf <7kfpun@gmail.com>

scriptencoding utf-8


if (exists("g:loaded_stock") && g:loaded_stock) || &cp
    finish
endif
let g:loaded_stock = 1


function! s:check_defined(variable, default)
    if !exists(a:variable)
        let {a:variable} = a:default
    endif
endfunction


call s:check_defined('g:stock_watchlist', ['00005:HK'])


silent! call webapi#json#decode('{}')
if !exists('*webapi#json#decode')
    echohl ErrorMsg | echomsg "stock.vim requires webapi (https://github.com/mattn/webapi-vim)" | echohl None
    finish
endif


function! Stock(...)
    if len(a:000)
        let symbols = a:000
    else
        let symbols = g:stock_watchlist
    endif

    let results = []
    for symbol in symbols
        try
            let response = webapi#http#get('https://api.investtab.com/api/quote/' . symbol . '/realtime-quote')
            let obj = webapi#json#decode(response.content)
            let result = obj['symbol'] . ': ' . string(obj['last']) . ' (' . string(obj['chg_from_prev_close_pct']) . '%)'
            call add(results, result)
        catch
            echo 'Request error.'
        endtry
    endfor
    echomsg join(results, ' | ')
endfunction


command! -nargs=* Stock call Stock(<f-args>)
