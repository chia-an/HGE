function rep = HHE_new(dim,train)
% dim = 5
%delta_e = 5;   % degree of e

% sorted data
User = unique(train(:,1));
Item = unique(train(:,2));
C1 = unique(train(:,3));
C2 = unique(train(:,4));
C3 = unique(train(:,5));
C1(1) = [];
C2(1) = [];
C3(1) = [];

nTrUser = length(User);
nTrItem = length(Item);
nTrC1 = length(C1);
nTrC2 = length(C2);
nTrC3 = length(C3);
nEdge = size(train,1);
nV = nTrUser + nTrItem + nTrC1 + nTrC2 + nTrC3;

H = zeros(nV,nEdge);
De = zeros(nEdge);
% construct H
for i = 1:nEdge
    %     H(find(User == train(i,1)),i) = 1;
    %     H(nTrUser + find(Item == train(i,2)),i) = 1;
    %     H(nTrUser + nTrItem + find(C1 == train(i,3)),i) = 1;
    %     H(nTrUser + nTrItem + nTrC1 + find(C2 == train(i,4)),i) = 1;
    %     H(nTrUser + nTrItem + nTrC1 + nTrC2 + find(C3 == train(i,5)),i) = 1;
    tmp = train(i,find(train(i,1:5) ~= -1));
    De(i,i) = length(tmp);
    H(tmp,i) = 1;
end
W = eye(nEdge);
%De = delta_e*W;
Dv = zeros(nV);

for j = 1:nV
    Dv(j,j) = length(find(H(j,:) ~= 0));
end

L = Dv-H*W*inv(De)*H';
[V,D] = eig(L);
d = diag(D);   % eigenvalue vector
V_NZ = V(:,find(d));
[value,index] = sort(d(find(d)),'ascend');
rep = V_NZ(:,index(1:dim));  % representation

end