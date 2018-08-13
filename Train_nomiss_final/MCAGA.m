function [L,S,iter,cost] = MCAGA(X,tol,maxIter,muScale)
% Group Algebra Matrix Completion
%   solve min_L |L|_* s.t. L+S=X, Pi(S)=0
%   using the inexact augmented Lagrangian method (IALM)
% ----------------------------------
% Chia-An Yu
% June, 2017
% b01201010@ntu.edu.tw
% Copyright: Music and Audio Computing Lab, Academia Sinica, Taiwan
% 

% Parameters
if nargin<2
    tol = 1e-7;
end
if nargin<3
    maxIter = 1000;
end
if nargin<4
    muScale = 0.0001;
end
rho0 = 1.2172;
rho1 = 1.8588;

% Initialization
absAGA = @(x) norm(x(:),2);
ST = @(x,c) max(1-c/norm(x(:)),0)*x;

D2 = length(size(X));
[N,M,G] = size(X);
P = min(N,M);

U = zeros(N,P,G);
Sigma = zeros(P,P,G);
V = zeros(M,P,G);
sv = zeros(P,1,G);
L = zeros(size(X));
S = zeros(size(X));
lambda = zeros(size(X));
omega = logical(X);
rho = rho0+rho1*nnz(omega)/numel(omega); % from Lin et al. (2009)

for k = 3:D2, X = fft(X,[],k); end     % move to the frequency domain
for i = 1:G
    sv(1,1,i) = svds(X(:,:,i),1,'L');
end
X_fro = norm(X(:));
mu = muScale/absAGA(sv(1,1,:));

for iter = 1:maxIter
    % Update L, singular value thresholding
    Z = X-S+lambda/mu;
    for i = 1:G
        [U(:,:,i),Sigma(:,:,i),V(:,:,i)] = svd(Z(:,:,i),'econ');
        sv(:,1,i) = diag(Sigma(:,:,i));
    end
    for i = 1:P
        sv(i,1,:) = ST(sv(i,1,:),1/mu);
    end
    for i = 1:G
        L(:,:,i) = U(:,:,i)*spdiags(sv(:,1,i),0,P,P)*V(:,:,i)';
    end
    
    % Update S, masking in data domain
    S = X-L+lambda/mu;
    for k = 3:D2, S = ifft(S,[],k); end
    err = sum(abs(S(omega)));
    S(omega) = 0;
    for k = 3:D2, S = fft(S,[],k); end
    
    R = X-L-S;
    lambda = lambda+mu*R;
    mu = rho*mu;
    
    % Check for convergence
    cost = 0;
    for i = 1:P
        cost = cost+absAGA(sv(i,1,:));
    end
    fprintf('#Iter.%2d: Res.=%f, |L|_*=%f, |Pi(S)|_1=%f\n',...
                iter,norm(R(:))/X_fro,cost,err);
    if norm(R(:))/X_fro<tol
        break;
    elseif iter==maxIter
        warning('Maximum iterations exceeded.');
    end
end
for k = 3:D2 % back to the data domain
    S = ifft(S,[],k);
    L = ifft(L,[],k);
end
S = real(S);
L = real(L);
end
