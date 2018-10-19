% Chia-An Yu & Ching-Lun Tai
% b01201010@ntu.edu.tw & b03901048@ntu.edu.tw
%

clear all
load('CoMoDa_implicit4.mat')

del = [];
for i = 1:length(train)
    if ~isempty(find(train(i,1:5) == -1))
        del = [del;i];
    end
end
train(del,:) = [];

% no OOV
nVer = [length(unique(train(:,1))),length(unique(train(:,2))),length(unique(train(:,3))),length(unique(train(:,4))),length(unique(train(:,5)))];
V = sum(nVer);

allData = [train;valid;test];
nTr = length(train);
nVa = length(valid);
nTe = length(test);

for i = 2:5
    tmp = find(allData(:,i) ~= -1);
    allData(tmp,i) = allData(tmp,i)+sum(nVer(1:i-1));
end

train = allData(1:nTr,:);
valid = allData(nTr+1:nTr+nVa,:);
test = allData(nTr+nVa+1:end,:);