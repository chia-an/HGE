clear all
load('CoMoDa_implicit4.mat')

del = [];
for i = 1:length(train)
    if ~isempty(find(train(i,1:5) == -1))
        del = [del;i];
    end
end
train(del,:) = [];

% Convert a list of subscripts to linear indices
allData = [train;valid;test];
dim = max(allData(:,1:end-1));
indTrain = cellfun(@(x) sub2ind(dim,x{:}),num2cell(num2cell(train(:,1:end-1)),2));
indValid = cellfun(@(x) sub2ind(dim,x{:}),num2cell(num2cell(valid(:,1:end-1)),2));
indTest = cellfun(@(x) sub2ind(dim,x{:}),num2cell(num2cell(test(:,1:end-1)),2));

% Initialize the data matrix
X = zeros(dim);
X(indTrain) = train(:,end);

% Call MC-AGA
[L,S,iter,obj] = MCAGA(X,1e-7,300,3e-1);

fVa = -L(indValid);
fTe = -L(indTest);

results = zeros(2,6);
[results(1,1),results(1,2),results(1,3)] = evaluation(train,valid,fVa,5);
[results(1,4),results(1,5),results(1,6)] = evaluation(train,valid,fVa,10);
[results(2,1),results(2,2),results(2,3)] = evaluation(train,test,fTe,5);
[results(2,4),results(2,5),results(2,6)] = evaluation(train,test,fTe,10);
fprintf('map5 \t mp5 \t mr5 \t map10 \t mp10 \t mr10\n');
fprintf('%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n', results(1,:));
fprintf('%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n', results(2,:));