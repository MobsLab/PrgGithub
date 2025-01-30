function output = CenterMat(matrix,vector)


% Center each column of matrix around the index given by vector (used for
% reconstruction)

% matrix to center
% vector = list of index
% 



% condition :
%
%   size(vector) = size(matrix,2)
%   isint(vector)
%   vector is in (1:size(matrix,1))

output = [];

%number of bin, center bin, number of columns
nBins = size(matrix,1);
center = round(nBins/2);
N = size(matrix,2);

%Shift matrix
vect = vector - center;
shift = repmat(vect',nBins,1);

%Initial index matrix
matIndex = 1:nBins;
matIndex = repmat(matIndex',1,N);

%New Index
matIndex = matIndex + shift;
matIndex = mod(matIndex,nBins);

matIndex(matIndex==0)=nBins;

matIndex = matIndex + repmat((0:N-1) .*nBins,nBins,1);

% Unwrapped index
unwrap = matIndex(:);

%unwrap matrix and change index
m = matrix(:);
m = m(unwrap);

%reshape
output = reshape(m,nBins,N);
