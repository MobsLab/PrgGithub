%make_multiD_position -
% computes the indexed position of a point in a matrix of multiple dimensions. Useful when the number of dimensions is unknown.
%
%----INPUT----
% positions						array of all the subscripts
% M								matrix where data is to be extracted
%
%----OUTPUT----
% position 						offset into the storage column
%
%----EXAMPLE----
% for the (s(1) s(2) s(3) ... s(n)) subscripts in the [d(1) d(2) d(3) ... d(n)] dimensions, what is computed is :
% (s(n)-1)d(n-1)d(n-2)...d(1) + (s(n-1)-1)d(n-2)...d(1) + ... + (s(2)-1)d(1) + s(1)


function position=make_multiD_position(positions,M)

	if size(positions,2)==1
		position=positions(1);
	else
		dim_offset=1;
		for dim=1:(size(positions,2)-1)
			dim_offset=dim_offset*size(M,dim);
		end
		position=dim_offset*(positions(end)-1)+make_multiD_position(positions(1:end-1),M);
	end