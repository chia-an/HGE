% Chia-An Yu & Ching-Lun Tai
% b01201010@ntu.edu.tw & b03901048@ntu.edu.tw
%

clear all
load('Processed_train_nomiss_final.mat')
load('rep_DW.mat')
rep = rep_DW;

fVa = zeros(nVa,1);
fTe = zeros(nTe,1);
for i = 1:nVa
    ri = rep(valid(i,1:5),:);
    for j=1:5, for k=j+1:5
        fVa(i) = fVa(i)+ri(j,:)*ri(k,:)';
	end;end
end
for i = 1:nTe
    ri = rep(test(i,1:5),:);
	for j=1:5, for k=j+1:5
        fTe(i) = fTe(i)+ri(j,:)*ri(k,:)';
	end;end
end
fVa(isnan(fVa)) = -inf;
fTe(isnan(fTe)) = -inf;
fVa = -fVa;  % smaller value is better
fTe = -fTe;

results = zeros(2,6);
[results(1,1),results(1,2),results(1,3)] = evaluation(train,valid,fVa,5);
[results(1,4),results(1,5),results(1,6)] = evaluation(train,valid,fVa,10);
[results(2,1),results(2,2),results(2,3)] = evaluation(train,test,fTe,5);
[results(2,4),results(2,5),results(2,6)] = evaluation(train,test,fTe,10);
fprintf('map5 \t mp5 \t mr5 \t map10 \t mp10 \t mr10\n');
fprintf('%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n', results(1,:));
fprintf('%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n', results(2,:));