c%goodname1='FEAR-Mouse-231-12022015-01-EXTenvC-wideband';
goodname1='FEAR-Mouse-258-20151203';

file1 = fopen([goodname1,'.pos'],'w');

for pp = 1:length(PosMat)
    fprintf(file1,'%f\t',PosMat(pp,2)); fprintf(file1,'%f\n',PosMat(pp,3));

end