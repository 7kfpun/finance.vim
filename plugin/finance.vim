" finance.vim - Check Stocks and Exchange Rates in Vim
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


call s:check_defined('g:finance_watchlist', ['AAPL', 'GOOG', 'MSFT', 'AMZN', 'FB'])
call s:check_defined('g:finance_format', '{1. symbol}: {2. price} ({3. volume})')
call s:check_defined('g:finance_cn_format', '{name}: {price} ({updown}/{percent}%)')
call s:check_defined('g:finance_separator', "\n")  " have to be double quotes

call s:check_defined('g:exchange_currency', ['BTC', 'USD'])
call s:check_defined('g:exchange_format', '1 {1. From_Currency Code} = {5. Exchange Rate} {3. To_Currency Code}')

silent! call webapi#json#decode('{}')
if !exists('*webapi#json#decode')
    echohl ErrorMsg | echomsg 'finance.vim requires webapi (https://github.com/mattn/webapi-vim)' | echohl None
    finish
endif

function! finance#format(format_string, object)
    let result = a:format_string
    while matchstr(result, '{[^}]*}') != ''
        let exp = matchstr(result, '{[^}]*}')
        if exp != ''
            let key = substitute(exp, '[{}]', '', 'g')
            if type(get(a:object, key, '')) != 1
                let result = substitute(result, exp, string(get(a:object, key, '')), '')
            else
                let result = substitute(result, exp, get(a:object, key, ''), '')
            endif
        endif
    endwhile
    return result
endfunction

function! Finance(...)
    if len(a:000)
        let symbols = a:000
    else
        let symbols = g:finance_watchlist
    endif
    let joined_symbols = join(symbols, ',')

    try
        let url = 'https://www.alphavantage.co/query?function=BATCH_STOCK_QUOTES&symbols=' . joined_symbols . '&datatype=json&apikey=C63UA4JHK58SR2QN'
        let response = webapi#http#get(url)
        let content = webapi#json#decode(response.content)
    catch
        echoerr 'Request error: ' . v:exception
        return
    endtry

    let error = get(content, 'Error Message')
    if type(error) == 1
        echoerr get(content, 'Error Message')
        return
    endif

    let quotes = content['Stock Quotes']

    let results = []
    for quote in quotes
        let result = finance#format(g:finance_format, quote)
        call add(results, result)
    endfor
    return join(results, g:finance_separator)
endfunction

function! FinanceCn(...)
    if len(a:000)
        let symbols = a:000
    else
        let symbols = g:finance_watchlist
    endif
    let joined_symbols = join(symbols, ',')

    try
        let url = 'http://api.money.126.net/data/feed/' . joined_symbols
        let response = webapi#http#get(url)
        let content = substitute(response.content, '_ntes_quote_callback(', '', 'g')
        let content = substitute(content, ');', '', 'g')
        let quotes = webapi#json#decode(content)
    catch
        echoerr 'Request error: ' . v:exception
        return
    endtry

    let results = []
    for symbol in symbols
        if has_key(quotes, symbol)
            let result = finance#format(g:finance_cn_format, quotes[symbol])
            call add(results, result)
        endif
    endfor
    return join(results, g:finance_separator)
endfunction

function! Exchange(...)
    if len(a:000)
        let currencies = a:000
    else
        let currencies = g:exchange_currencies
    endif

    if len(currencies) >= 2
        let from_currency = currencies[0]
        let to_currency = currencies[1]
    else
        echoerr 'Invalid input, eg :Exchange BTC USD'
        return
    endif

    try
        let url = 'https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=' . from_currency . '&to_currency=' . to_currency . '&datatype=json&apikey=C63UA4JHK58SR2QN'
        let response = webapi#http#get(url)
        let content = webapi#json#decode(response.content)
    catch
        echoerr 'Request error: ' . v:exception
        return
    endtry

    let error = get(content, 'Error Message')
    if type(error) == 1
        echoerr get(content, 'Error Message')
        return
    endif

    return finance#format(g:exchange_format, content['Realtime Currency Exchange Rate'])
endfunction

command! -nargs=* Finance echo Finance(<f-args>)
command! -nargs=* FinanceCn echo FinanceCn(<f-args>)
command! -nargs=* Exchange echo Exchange(<f-args>)
