function y_m = pima_logKernSmooth(x_m,opDim_n,winGrow_n)

% @description | Input data matrix x_m is smoothed along opDim_n using a 
% Gaussian kernel (window). Window size grows logarithmically according to 
% wLen_n = winGrow_n*log10(ii).
% @input1 | x_m: Input of data to be smoothed [sDim_n,...].
% @input2 | opDim_n: Specified operating dimension (optional; default = 1).
% @input3 | winGrow_n: Kernel/window size growth parameter (optional;
% default = 10).

% Default window length growth parameter value

if (nargin<3)
    
    winGrow_n = 10;
    
end

% Default operating dimension

if (nargin<2)
    
    opDim_n = 1;
    
end

% Initialize stuff

xSize_v = size(x_m);
sDim_n = xSize_v(opDim_n);
y_m = zeros(xSize_v);
Ndims_n = length(xSize_v);

% Make sure operating dimension is within size of matrix to be smoothed

assert(opDim_n<=Ndims_n,'Invalid operating dimension.');

% Initialize more stuff

allInds_c = cell(1,Ndims_n);
allInds_c(:) = {':'};
ii_v = 1:sDim_n;
wLen_v = round(winGrow_n*log10(ii_v)+2);

% Make sure window length is odd (so that there exists a central point)

wLen_v(mod(wLen_v,2)==0) = wLen_v(mod(wLen_v,2)==0)+1;

% Smoothing loop

for ii = ii_v
    
    wLen_n = wLen_v(ii);    
    w_v = gausswin(wLen_n);
    eInd_n = ii+((wLen_n-1)/2);
    
    % Adjust start/end points at the end (constant window)
    
    if (eInd_n>sDim_n)
        
        eInd_n = sDim_n;
        sInd_n = eInd_n-wLen_n+1;
        
    else
        
        sInd_n = ii-((wLen_n-1)/2);
        
    end
    
    if (sInd_n<1)
        
        sInd_n = 1;
        eInd_n = sInd_n+wLen_n-1;
        
    end
    
    w_v = w_v/sum(w_v);
    
    % Make sure w_v is aligned with operating dimension
    
    wPerm_v = ones(Ndims_n,1);
    
    for jj = 2:Ndims_n
        
        wPerm_v(jj) = jj;
        
    end
    
    repOpDim_n = wPerm_v(opDim_n);
    wPerm_v(opDim_n) = 1;
    wPerm_v(1) = repOpDim_n;
    w_v = permute(w_v,wPerm_v);
    
    % Grab x_m indices along operating dimension
    
    sliceInds_c = allInds_c;
    sliceInds_c{opDim_n} = sInd_n:eInd_n;
    dropInds_c = allInds_c;
    dropInds_c{opDim_n} = ii;
    
    y_m(dropInds_c{:}) = sum(x_m(sliceInds_c{:}).*w_v,opDim_n,'omitnan');
    
end

end