function [rep,conv] = HGE_P2(V,edgs,dim,ws)
% function [R,C] = HGE(V,E,DIM,WS)
% Compute an embedding of the given hypegraph G=(V,E,WS) by solving the
% following optimization problem using stochastic gradient descent.
% max_R sum_{e in E}cost(e), s.t. norm(R(i,:),P)=1, R(i,j)>=0, forall i,j,
% where cost(e) = sum(mean(R(e,:).^numel(e),1)-prod(R(e,:),1),2)
%
% V - An integer indicating the number of nodes.
%     Nodes are numbered from 1 ro V.
% E - A cell array containing all the hyperedges.
%     Every hyperedge is a (column) vector containing the ID of vertices
%     being connected.
% DIM - The dimension of the intended embedding.
% WS - The weight of each hyperedge, i.e. WS(i) is the weight of the
%      hyperedge E{i}.
%
% R - The representation of the hypergraph.
% C - A logical indicating whether the algorithm converges.
% --
% Example:
% [R,C] = HGE_P2(4,{[1;2;3],[2;3;4]},5,[1,-1]);
% --
% Chia-An Yu, 2017/08/03
% b01201010@ntu.edu.tw
%

% Parameters
learnRate = 1e-2; % learning rate
lrDecRate = 0.995; % decreasing rate of the learning rate
lrDecFreq = 3; % frequency (per epoch) of decreasing learning rate
nEpoch = 300; % number of maximum epoch
epsSC = 1e-5; % eps for the stopping criterion
P = max(cellfun(@(x) numel(x),edgs))+1; % normalize using P-norm
% Set normP larger than orders of all hyperedges

% Initialization
rep = nan*ones(V,dim);
E = length(edgs);
cost = zeros(E,1);
lastLoss = inf;
conv = false;
decIdx = floor(linspace(0,E,lrDecFreq+1));

for epoch = 1:nEpoch
    fprintf('# %d\n',epoch);
    idx = randperm(E);
    edgs = edgs(idx);
    ws = ws(idx);
    for i = 1:E
        e = edgs{i};
        de = numel(e);
        ri = rep(e,:);
        idx = find(isnan(ri));
        % Initialize if this is the first time to update
        ri(idx) = rand(size(idx));
        % Compute the gradient
        grad = [ones(1,dim);cumprod(ri(1:end-1,:),1)].*...
               [cumprod(ri(2:end,:),1,'reverse');ones(1,dim)];
        grad = ws(i)*(ri.^(de-1)-grad);
        % Update rep
        rep(e,:) = ri-learnRate*grad;
        % Clip negative coordinates
        rep(e,:) = max(rep(e,:),0);
        % Normalize rep
        for v = e(:)'
            z = norm(rep(v,:),P);
            if z == 0
                rep(v,:) = rand(1,dim);
            else
                rep(v,:) = rep(v,:).*(dim^(1/P))./z;
            end
        end
        % Decrease learning rate
        if ismember(i,decIdx)
            learnRate = learnRate*lrDecRate;
        end
    end
    % Compute loss
    for j = 1:E
        ri = rep(edgs{j},:);
        de = numel(edgs{j});
        cost(j) = sum(mean(ri.^de,1)-prod(ri,1),2);
    end
    loss = mean(cost.*ws(:));
    fprintf('Loss: %f, LearnRate: %f\n',loss,learnRate);
    % Check convergence
    if abs(loss-lastLoss) < epsSC
        conv = true;
        break;
    else
        lastLoss = loss;
    end
end
end