function St=PoolNeurons(S,cells)


st=[];


for i=1:length(cells)

	s=Range(S{cells(i)});
	st=[st;s];

end


St=tsd(sort(st),sort(st));

end



