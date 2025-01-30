function crutchfield = crutchfield(Hsingle,Hjoint)

nbCells = size(Hjoint,1);

crutchfield = zeros(nbCells)

for i=1:nbcells
	for j=i+1:nbCells

		crutchfield(i,j) = 2 - ((Hsingle(i) + Hsingle(j))/Hjoint(i,j);
		crutchfield(j,i) = crutchfield(i,j);

	end
end