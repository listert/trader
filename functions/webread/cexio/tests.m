clear;clc;

%% get1mOHLCV
res = get_Cex_1mOHLCV('BTC','USD',datenum([2017 11 28]));
disp(res.data(1:5,:));

%% getOrderbook
res = get_Cex_Orderbook('BTC','USD',1000,true);
ob = OrderBook('cexio',res);

%% getTicker
res = get_Cex_Ticker('BTC','USD');