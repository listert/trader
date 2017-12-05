function [datastruct] = get_Cex_Orderbook(symbol1,symbol2,depth,append_ticker)
%GET_CEX_ORDERBOOK Download current Cex orderbook
%   INPUT
%   =======================================================================
%   symbol1: Data for pair symbol1/symbol2 will be downloaded.
%   symbol2:
%   depth:  Limit the number of bid/ask records returned.
%   append_ticker: Include ticker data (true/false)
%
%   OUTPUT
%   =======================================================================
%   datastruct: See https://cex.io/rest-api#orderbook

if nargin < 4, append_ticker = true;end

% setup url
url = ['https://cex.io/api/order_book/' upper(symbol1) '/' upper(symbol2) '/?depth=' round(num2str(depth))];

if append_ticker
    url_ticker = ['https://cex.io/api/ticker/' upper(symbol1) '/' upper(symbol2)];
end

% read webdata
str = webread(url);
if isempty(str)
    error('Trader:webreading','Couldn''t read CEX.io Orderbook data.');
end

if append_ticker
    str_ticker = webread(url_ticker);
end

% read the string
datastruct = jsondecode(str);
datastruct.timestamp = datetime(datastruct.timestamp,'ConvertFrom','posixtime');
if append_ticker
    tstruct = jsondecode(str_ticker);
    datastruct.last = str2double(tstruct.last);
    datastruct.ticker_timestamp = datetime(str2double(tstruct.timestamp),'ConvertFrom','posixtime');
end
end

