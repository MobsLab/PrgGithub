nametoerase='VEH2-A5-6-refMouse6';
replaceby='BULB-Mouse-A6-23052014-OpenFieldVEH2-ref';


lis=dir;
for i=1:length(lis)
    temp=lis(i).name;
    if ~isempty(strfind(temp,nametoerase))
        indtemp=strfind(temp,nametoerase);
        newname=[temp(1:indtemp-1),replaceby,temp(indtemp+length(nametoerase):end)];
        disp(['rename ',temp])
        disp(['-> ',newname])
        movefile(temp,newname);
        
    end
end
        
    