load DataAnalyseLisaFinalSpont.mat


a=1;
b=1;
c=1;
d=1;
e=1;
NamesWT={};
Names30={};
Names43={};
NamesdbKO={};


for a=1:length(R)
    
    
    if R(a,5)<1&&R(a,26)==1;
        NamesWT{b}=Cellnames{a};
        b=b+1;
%     else
%         b=b;
    end
    
    
    if R(a,5)<1&&R(a,26)==2;
        Names30{c}=Cellnames{a};
        c=c+1;
%     else
%         b=b;
    end
    
    
    if R(a,5)<1&&R(a,26)==3;
        Names43{d}=Cellnames{a};
        d=d+1;
%     else
%         b=b;
    end
    
    
    if R(a,5)<1&&R(a,26)==4;
        NamesdbKO{e}=Cellnames{a};
        e=e+1;
%     else
%         b=b;
    end
    
    
    a=a+1;
    
end

% ______________________________________________________________________

% Enregistrement en fichier .txt

fid = fopen('WTNamesSpont','w');

for i=1:length(NamesWT)
    
    fprintf(fid,'%s\r\n',num2str(NamesWT{i}));

end

fclose(fid);

% _______________________________________________________________________

fid = fopen('KO30NamesSpont','w');

for i=1:length(Names30)
    
    fprintf(fid,'%s\r\n',num2str(Names30{i}));

end

fclose(fid);

% _______________________________________________________________________

fid = fopen('KO43NamesSpont','w');

for i=1:length(Names43)
    
    fprintf(fid,'%s\r\n',num2str(Names43{i}));

end

fclose(fid);

% _______________________________________________________________________

fid = fopen('dbKONamesSpont','w');

for i=1:length(NamesdbKO)
    
    fprintf(fid,'%s\r\n',num2str(NamesdbKO{i}));

end

fclose(fid);


% _________________________________________________________________________
% _________________________________________________________________________
load DataAnalyseLisaFinal60mV.mat
% ______________________________________________________________________

% Enregistrement en fichier .txt


fid = fopen('WTNames-60mV','w');


for i=1:length(cellnamesctrl)
    

      fprintf(fid,'%s\r\n',num2str(cellnamesctrl{i}));

end

fclose(fid);

% _______________________________________________________________________

fid = fopen('KO30Names-60mV','w');

for i=1:length(cellnames30)
    
     fprintf(fid,'%s\r\n',num2str(cellnames30{i}));

end

fclose(fid);

% _______________________________________________________________________

fid = fopen('KO43Names-60mV','w');

for i=1:length(cellnames43)
    
    fprintf(fid,'%s\r\n',num2str(cellnames43{i}));

end

fclose(fid);

% _______________________________________________________________________

fid = fopen('dbKONames-60mV','w');

for i=1:length(cellnamesdoKO)
    
    fprintf(fid,'%s\r\n',num2str(cellnamesdoKO{i}));

end

fclose(fid);



