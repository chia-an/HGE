function [MAP,MP,MR,APs,Ps,Rs] = evaluation(trainT, testT, fpred, k)
% [MAP,MP,MR] = evaluation(trainT, testT, fpred, k)
%
% Compute the ranking scores MAP@k, P@k, R@k.
% 

idx = randperm(size(testT,1));
testT = testT(idx,:); fpred = fpred(idx,:);
%testT = testT(end:-1:1,:); fpred = fpred(end:-1:1,:);
uIds = unique(testT(:,1));
APs=[]; Ps=[]; Rs=[];
for uid = uIds(:)'
  if ~any(trainT(:,1) == uid), continue; end
% This for MAP of user | context but too few items to use this measure  
  indice = find(testT(:,1)==uid);
  R = testT(indice,:);
  [~,~,ctxId] = unique(R(:,3:end-1),'rows');
  for j=1:max(ctxId)
    % careful: the indince of items here are in R, not in the testT
    itemsInR = find(ctxId==j);
    ratings = R(itemsInR,end);
    actual = find(ratings == 1); % order of relevant items does not matter
    if (numel(actual) == 0) % no relevant item so no ranking to do
      continue;
    end
    [~, prediction] = sort(fpred(indice(itemsInR)));%, 'descend');
    APs = [APs; averagePrecisionAtK(actual,prediction(1:length(actual)),k)];
    Ps = [Ps; precisionAtK(actual,prediction,k)];
    Rs = [Rs; recallAtK(actual,prediction,k)];
  end
end
MAP = mean(APs);
MP = mean(Ps);
MR = mean(Rs);
end

function pk = precisionAtK(actual,prediction,k)
    k = min(k, length(prediction));
	pk = numel(intersect(actual,prediction(1:k)))/k;
end

function rk = recallAtK(actual,prediction,k)
    k = min(k, length(prediction));
	rk = numel(intersect(actual,prediction(1:k)))/numel(actual);
end

function score = averagePrecisionAtK(actual, prediction, k)
%Average Precision at K
%   Calculates the average precision at k
%   score = averagePrecisionAtK(actual, prediction, k)
%
%   actual is a vector
%   prediction is a vector
%   k is an integer
%
%   Author: Ben Hamner (ben@benhamner.com)

if nargin<3, k=10; end

if length(prediction)>k
    prediction = prediction(1:k);
end

score = 0;
num_hits = 0;
for i=1:min(length(prediction), k)
    if ismember(prediction(i),actual),
        %&& sum(prediction(1:i-1)==prediction(i))==0
        num_hits = num_hits + 1;
        score = score + num_hits / i;
    end
end
score = score / min(length(actual), k);
end

