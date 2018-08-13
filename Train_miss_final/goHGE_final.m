clear all
load('Processed_train_miss_final.mat')

nIter = 100;
edgs = [];
rec = [];
for i = 1:nTr
    edgs = [edgs;num2cell(train(i,find(train(i,1:5) ~= -1)),2)];
end

nNeg = 2;
negEdgs = cell(nTr,nNeg);

tmp = zeros(2,6);
for num = 1:nIter
    for i = 1:nTr, for j = 1:nNeg
            negEdgs{i,j} = edgs{i};
            negEdgs{i,j}(2) = nVer(1) + randi(nVer(2),1);
        end;end
    [rep,conv] = HGE_P2(V,[edgs;negEdgs(:)],10,[ones(nTr,1);-ones(nTr*nNeg,1).*0.1./nNeg]);
%     [rep,conv] = HGE_P2(V,edgs,10,ones(nTr,1));
    %% Evaluation
    fVa = zeros(nVa,1);
    fTe = zeros(nTe,1);
    for i = 1:nVa
        ri = rep(valid(i,1:5),:);
        fVa(i) = mean(sum(ri.^5,2))-sum(prod(ri,1),2);
    end
    for i=1:nTe
        ri = rep(test(i,1:5),:);
        fTe(i) = mean(sum(ri.^5,2))-sum(prod(ri,1),2);
    end
    
    % Evaluate results
    results = zeros(2,6);
    [results(1,1),results(1,2),results(1,3)] = evaluation(train,valid,fVa,5);
    [results(1,4),results(1,5),results(1,6)] = evaluation(train,valid,fVa,10);
    [results(2,1),results(2,2),results(2,3)] = evaluation(train,test,fTe,5);
    [results(2,4),results(2,5),results(2,6)] = evaluation(train,test,fTe,10);
    fprintf('map5 \t mp5 \t mr5 \t map10 \t mp10 \t mr10\n');
    fprintf('%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n', results(1,:));
    fprintf('%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n', results(2,:));
    
    tmp = tmp+results;
    rec = [rec;[results(2,1),results(2,4)]];
end

final = tmp/nIter
var(rec)