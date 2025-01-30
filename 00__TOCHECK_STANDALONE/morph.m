function M = morph(A,B,n,met)
% morph
%       Morphs sequence A to sequence B with n points.
%       A and B must have the same number of elements. The final result
%       has the size of B plus an additional dimension of length n. Each
%       element along this dimension is an element of the morphing.
%       n must be greater than 2.
%
%       Fourth arg is optional and specifies the method of moprhing:
%           - Linear (default)
%           - Spline
%           - SplinEase: same than spline but with easeout borders
%           - Cubic
%           - Nearest
%           - Pchip
%           - ... (see interp1 documentation)
%
%       Example:
%             a = [1 2 3 4 5 6 7 8];
%             b = [4 5 6 7 8 9 10 11];
%             b = reshape(b,[2 2 2]);
%             c = IM_utils.IM_morph(a,b,4)
%   
%
%   Copyright 2011 Jonathan Hadida
%   ETS Montreal, Canada
%   Interventional Medical Imaging Laboratory
%
%   Contact: ariel dot hadida [a] google mail

    controlargs(nargin);
    if n < 2, return; end
    
    % Morphing    
    cA = A(:)'; cB = B(:)';
    
    if strcmp(met,'splinease')
        
        x  = [(1-1/n) 1 2 (2+1/n)];
        xx = linspace( 1 , 2 , n );
        y  = interp1( x , [ cA ; cA ; cB ; cB ] , xx , 'splinease' );
        
    else
        
        y = interp1( [1 2] , [cA ; cB] , linspace(1,2,n) , met );
        
    end
    
    % Reshaping
    M = reshape( y' , [size(B) n] );
    
        
    % Control inputs
    function controlargs(argc)
        
        % Three arguments at least
        if argc < 3
            error('Morph: Three arguments required.');
        end

        % A and B must have the same numel
        if numel(A) ~= numel(B)
            error('Morph: A and B must have the same number of elements.');
        end

        % Morhphing length should be longer than 2
        if n < 2
            disp('Morph: Morphing length cannot be lesser than 2. Returning concatenated inputs.');
            cn = ndims(B)+1;
            C  = reshape(A,size(B));
            M  = cat(cn,C,B);
            return;
        end

        % Method
        if argc < 4 || ~ismember(lower(met),{'nearest','linear','spline','pchip','cubic','v5cubic','splinease'})
            disp('Morph: Defaulting to linear morphing.');
            met = 'linear';
        else
            met = lower(met);
        end
        
        % Float required by interp1
        if ~isfloat(A), A = single(A); end
        if ~isfloat(B), B = single(B); end
        
    end

end