clear all
load('Processed_train_nomiss_final.mat')

rep = HHE_new(10,train);

%% Compute recommendation score
fVa = zeros(nVa,1);
fTe = zeros(nTe,1);
for i = 1:nVa
    ri = rep(valid(i,1:2),:);
    fVa(i) = sum((ri(1,:)-ri(2,:)).^2);
end
for i=1:nTe
    ri = rep(test(i,1:2),:);
    fTe(i) = sum((ri(1,:)-ri(2,:)).^2);
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