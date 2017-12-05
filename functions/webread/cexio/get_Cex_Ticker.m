function [datastruct] = get_Cex_Ticker(symbol1,symbol2)
%GET_CEX_TICKER Download current Cex ticker
%   INPUT
%   =======================================================================
%   symbol1: Data for pair symbol1/symbol2 will be downloaded.
%   symbol2:
%
%   OUTPUT
%   =======================================================================
%   datastruct: See https://cex.io/rest-api#ticker

url = ['https://cex.io/api/ticker/' upper(symbol1) '/' upper(symbol2)];

% read webdata
str = webread(url);
if isempty(str)
    error('Trader:webreading','Couldn''t read CEX.io Orderbook data.');
end

% read the string
datastruct = jsondecode(str);
datastruct.timestamp = datetime(str2double(datastruct.timestamp),'ConvertFrom','posixtime');
datastruct.low = str2double(datastruct.low);
datastruct.high = str2double(datastruct.high);
datastruct.last = str2double(datastruct.last);
datastruct.volume = str2double(datastruct.volume);
datastruct.volume30d = str2double(datastruct.volume30d);

end

