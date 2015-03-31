" finance.vim - Check stock in vim
" Maintainer: kf <7kfpun@gmail.com>

scriptencoding utf-8


if (exists("g:loaded_finance") && g:loaded_finance) || &cp
    finish
endif
let g:loaded_finance = 1


function! s:check_defined(variable, default)
    if !exists(a:variable)
        let {a:variable} = a:default
    endif
endfunction


call s:check_defined('g:finance_watchlist', ['0005.HK', 'GOOG'])


silent! call webapi#json#decode('{}')
if !exists('*webapi#json#decode')
    echohl ErrorMsg | echomsg 'finance.vim requires webapi (https://github.com/mattn/webapi-vim)' | echohl None
    finish
endif


function! Finance(...)
    if len(a:000)
        let symbols = a:000
    else
        let symbols = g:finance_watchlist
    endif
    let joined_symbols = join(symbols, "%27,%27")

    try
        let response = webapi#http#get('http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quote%20where%20symbol%20in%20(%27' . joined_symbols . '%27)&diagnostics=true&env=store://datatables.org/alltableswithkeys&format=json')
        let objs = webapi#json#decode(response.content)['query']['results']['quote']
        if type(objs) == 3  " if it is a list
            let results = []
            for obj in objs
                let result = obj['symbol'] . ': ' . obj['LastTradePriceOnly'] . ' (' . obj['Change'] . ')'
                call add(results, result)
            endfor
            echo join(results, ' | ')
        else
            echo objs['symbol'] . ': ' . objs['LastTradePriceOnly'] . ' (' . objs['Change'] . ')'
        endif
    catch
        echoerr 'Request error.'
    endtry
endfunction


command! -nargs=* Finance call Finance(<f-args>)
