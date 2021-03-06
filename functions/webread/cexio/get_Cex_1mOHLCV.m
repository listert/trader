function [datastruct] = get_Cex_1mOHLCV(symbol1,symbol2,day)
%GET1MOHLCV Obtain CEX.io 1m OHLCV data for a particular day.
%   INPUT
%   =======================================================================
%   symbol1: Data for pair symbol1/symbol2 will be downloaded.
%   symbol2:
%   day: The day in one of the matlab basic time formats for which the 
%   historical data should be downloaded. 
%
%   OUTPUT
%   =======================================================================
%   datastruct.time: Date returned by the server.
%   datastruct.data: Pair data in the form of a Timetable

% setup url
url = ['https://cex.io/api/ohlcv/hd/' datestr(day,'YYYYmmDD') '/' upper(symbol1) '/' upper(symbol2)];

% read webdata
str = webread(url);
if isempty(str)
    error('Trader:webreading','Couldn''t read CEX.io OHLCV data.');
end

% read the string
res = jsondecode(str);
datastruct.time = datetime(num2str(res.time),'InputFormat','yyyyMMdd');
str = res.data1m(3:end-2);
clear res;
lines = regexp(str,'],[','split');

% create timetable
N = max(size(lines));
timestamp = nan(N,1);
open = nan(N,1);
high = nan(N,1);
low = nan(N,1);
close = nan(N,1);
volume = nan(N,1);
for i = 1:N
    parts = textscan(lines{i},'%d %f %f %f %f %f','Delimiter',',');
    timestamp(i) = parts{1};
    open(i) = parts{2}; high(i) = parts{3}; low(i) = parts{4}; close(i) = parts{5};
    volume(i) = parts{6};
end
timestamp = datetime(timestamp,'ConvertFrom','posixtime');
datastruct.data = table2timetable(table(timestamp,open,high,low,close,volume,...
    'VariableNames',{'Timestamp','Open','High','Low','Close','Volume'}));
end

