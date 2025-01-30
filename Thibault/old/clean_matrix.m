%clean_matrix -
% Takes a given matrix of any dimension, and replace all its non-numeric values (like Nan or Inf) by an argument.
% if no secondary argument is given, then values are replaced by zeros.

function cleanedM=clean_matrix(M,varargin)

	
	cleanedM=M;
	nb_points=prod(size(M));

	for x=1:nb_points
		if ~isfinite(M(x))
			if nargin==1
				cleanedM(x)=0;
			else
				cleanedM(x)=varargin{1};
			end
		end
	end
