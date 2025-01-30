% OLDMCAnalysis

load Data
load DataMCLFP
load Spikes
load UpDown

try
    cd OLD
catch 
    mkdir OLD
    cd OLD
end

[Res,numfig]=PatchCellPropertiesLR(Y+X(1),tps,spikes,DebutUp,FinUp,1,data,nom);

cd ..

save ResultsOld Res

fid = fopen('DataOldUpDown.txt','w');

    fprintf(fid,'%s\r\n','Frequence des Up: ',num2str(Res(13)));
    fprintf(fid,'%s\r\n','Duree moyenne des Up: ',num2str(Res(14)));
    fprintf(fid,'%s\r\n','Duree moyenne des Down: ',num2str(Res(15)));
    fprintf(fid,'%s\r\n','amplitude des UP: ',num2str(Res(16)));

fclose(fid);