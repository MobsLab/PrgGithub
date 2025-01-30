% FinalRtColonnesTxt


cd H:\Electrophy_astros_final
load FinalResult1

% RAPPEL: Res=[VmMoy,STD,Error,Skew];
% Rt=[Rt;[a,Res]]; avec a=index de la cellule

%----------------------------------------------------------
%Pour récupérer l'index


fid = fopen('index.txt','w');

for i=1:length(Rt)
    
    fprintf(fid,'%s\r\n',num2str(Rt(i,1)));

end

fclose(fid);

%----------------------------------------------------------
%Pour récupérer le nom des cellules


fid = fopen('noms.txt','w');
% 
for i=1:length(cellnames)
%     
    fprintf(fid,'%s\r\n',cellnames{i}); %Pourquoi cellnames et Rt n'ont pas la même taille???
% 
end
% 
fclose(fid);
%----------------------------------------------------------
%Pour récupérer le mois des cellules


fid = fopen('mois.txt','w');
% 
for i=1:length(Mois)
%     
    fprintf(fid,'%s\r\n',Mois{i});
% 
end
% 
fclose(fid);


%----------------------------------------------------------
%Pour récupérer leur Vm moyen

fid = fopen('Vm.txt','w');

for i=1:length(Rt)
    
    fprintf(fid,'%s\r\n',num2str(Rt(i,2)));

end

fclose(fid);

% %----------------------------------------------------------
%Pour récupérer la STD de leur Vm

fid = fopen('STD.txt','w');

for i=1:length(Rt)
    
    fprintf(fid,'%s\r\n',num2str(Rt(i,3)));

end

fclose(fid);
% %----------------------------------------------------------
%Pour récupérer la std error de leur Vm 

fid = fopen('Error.txt','w');

for i=1:length(Rt)
    
    fprintf(fid,'%s\r\n',num2str(Rt(i,4)));

end

fclose(fid);
% 
% %----------------------------------------------------------
%Pour récupérer la skewness de leur Vm 

fid = fopen('Skew.txt','w');

for i=1:length(Rt)
    
    fprintf(fid,'%s\r\n',num2str(Rt(i,5)));

end

fclose(fid);
