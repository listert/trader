classdef OrderBook
    %ORDERBOOK General class to store orderbook data sample
    %   Support for creating the book from Cex.io datastructure (see
    %   get_Cex_Orderbook function).
    
    properties
        pair = '';
        timestamp;
        bids = [];
        asks = [];
        last_price = 0;
    end
    
    methods % ------------------------- Constructor -----------------------
        function obj = OrderBook(varargin)
            N = size(varargin,2);
            if N == 2
                switch lower(varargin{1})
                    case 'cexio'
                        obj.pair = varargin{2}.pair;
                        obj.timestamp = varargin{2}.timestamp;
                        obj.bids = varargin{2}.bids;
                        obj.asks = varargin{2}.asks;
                        if isfield(varargin{2},'last'), obj.last_price = varargin{2}.last;end
                end
            end
        end
    end
    
    methods % --------------------- Util functions ------------------------
        %   sum amounts in price intervals (binning)
        %   for ask the edges should be ascending
        %   for bid the edges should be descending
        %   which: either 'ask' or 'bid'
        %   edges: edges of the intervals
        function [amounts] = to_Intervals(obj,which,edges)
            N = size(edges,2)+1;
            amounts = zeros(N,1);
            if strncmp(which,'ask',3)
                vec = obj.asks;
                edges = [-Inf,edges,Inf];
                for i = 1:N, amounts(i) = sum(vec(vec(:,1) > edges(i) & vec(:,1) <= edges(i+1),2));end
            else
                vec = obj.bids;
                edges = [Inf,edges,-Inf];
                for i = 1:N, amounts(i) = sum(vec(vec(:,1) < edges(i) & vec(:,1) >= edges(i+1),2));end
            end
        end
        
        %   ---------------------------------------------------------------
        %   sum amounts in intervals that are constructed symmetrically
        %   from the last price
        %   method: method to calculate intervals
        %   varargin: params corresponding to the method
        function [bid_amounts,ask_amounts,diffs] = to_AskBid_Intervals(obj,method,varargin)
            bid_amounts = [];
            ask_amounts = [];
            diffs = [];
            switch method
                case 'relative'
                    perc = varargin{1}/100;edges = 1+perc;
                    ask_amounts = obj.to_Intervals('ask',obj.last_price*edges);
                    edges = 1-perc;
                    bid_amounts = obj.to_Intervals('bid',obj.last_price*edges);
                    diffs = perc*obj.last_price;
            end
        end
    end
end

