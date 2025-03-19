function A = fast_ica_AG(x,pcomponents,nit)

% Originally written by the Finish (Aapo) team;
% Modified by the PIB team in Aug. 21, 2007
% PIB - Biological Information Processing Lab - UFMA - Brazil
% Modified by Vitor Lopes dos Santos Aug. 2011.
%
% Modified by Marion Mallet, ENS, Paris, Nov 2021
%
% Modified by Arsenii Goriachenkov, ESPCI MOBS & ENS LSP teams, Paris, Sep 2022
% github.com/arsgorv

if nargin < 3, nit=100; end

% fprintf ('Removing mean...\n');

%-------------------------------------------------------------------
%   Meanize
%   Removes the mean of X
%-------------------------------------------------------------------

[nn,M]=size(x);
if nn>M,
  x=x'; 
  [garbage,M]=size(x);
end
X=double(x)-mean(x')'*ones([1,M]);     %#ok<UDIM> % Remove the mean.

X1=X;

%---- Meanize end ------

%zscoring data
%Mean has already been removed
sigma = std(X,0, 2);
sigma0 = sigma;
sigma0(sigma0==0) = 1;
X = X./ sigma0;

% Calculate the eigenvalues and eigenvectors of covariance matrix.
% fprintf ('Calculating covariance...\n');
covarianceMatrix = X*X'/size(X,2);
[E, D] = eig(covarianceMatrix);
% Sort the eigenvalues and select subset, and whiten

%-------------------------------------------------------------------
%                      PCA beggins 
%-------------------------------------------------------------------
[garbage,order] = sort(diag(-D));
E = E(:,order(1:pcomponents));
d = diag(D); 
d = real(d.^(-0.5)); %eigenvalues for whitening
D = diag(d(order(1:pcomponents)));
X = D*E'*X; %whitened data, checked correlation matrix is diagonal but also uniform (only 1 on diag)

whiteningMatrix = D*E';
dewhiteningMatrix = E*D^(-1);
%-------------------------------------------------------------------
%                      PCA ends
%-------------------------------------------------------------------

N = size(X,2);

B = randn(size(X,1),pcomponents); %B is weight ax expressed in space of PCA projection
% B = eye(pcomponents);   % teste
B = B*real((B'*B)^(-0.5));		% orthogonalize

% W1=randn(size(B' * whiteningMatrix)); 
W=rand(size(B' * whiteningMatrix));

iter=0;
while iter < nit %ICA iterations
%   clc
% while abs(norm(W)-norm(W1'))>1e-50,
  iter = iter+1;  
%   fprintf('(%d)',iter);

  % This is tanh but faster than matlabs own version
  hypTan = 1 - 2./(exp(2*(X'*B))+1);
  
  % This is the fixed-point step
  B = X*hypTan/N - ones(size(B,1),1)*mean(1-hypTan.^2).*B;
  
  B = B*real((B'*B)^(-0.5)); % orthogonalizing data; decorrelate data at each interation %rotate axis
%   W1=W;
  W = B' * whiteningMatrix; %Weights as expressed in function of original neurons    
  
end

Y=W*X1;   % X1 is X without the mean; project original data over PC weights
A = dewhiteningMatrix * B; % unmixing matrix
W=W'; %weight matrix   W=inv(A)

% fprintf(' Done!\n');


