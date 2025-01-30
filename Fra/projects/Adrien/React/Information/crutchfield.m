function crutchfield = crutchfield(Hsingle,Hjoint)

nbCells = size(Hjoint,1);
oneVect = ones(1,nbCells);
HXplusHY = Hsingle*oneVect + (Hsingle*oneVect)';


crutchfield = 2*Hjoint - HXplusHY;

%  
%  for i=1:nbCells
%  	for j=i+1:nbCells
%  
%  		a = Hsingle(i)
%  		b = Hsingle(j)
%  		c = 2 - (Hsingle(i) + Hsingle(j))/Hjoint(i,j)
%  		crutchfield(i,j) = 2 - (Hsingle(i) + Hsingle(j))/Hjoint(i,j);
%  		crutchfield(j,i) = crutchfield(i,j);
%  
%  	end
%  end