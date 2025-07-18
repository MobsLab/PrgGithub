% DetailForMCAnalysis

% Pour analyser le comportement d'une cellule mitrale, placer le fichier
% .abf dans un dossier isol� (un seul fichier abf par dossier)
% se placer dans le dossier en question avec Matlab

TransformDataStep1('N');

% v�rifier que la d�tection est ok et choisir une m�thode (karim ou maud),
% sinon jouer sur les dur�es
% indiquer si on est s�r de la cellule
% v�rifier que la correction de la baseline est ok, sinon, jouer sur les 2
% param�tres
% _________________________________________________________________________
load Data
load DataMCLFP
load Spikes
load UpDown

[Res,numfig]=PatchCellProperties(Y+X(1),tps,spikes,DebutUp,FinUp,1);
save ResultsOld Res
% _________________________________________________________________________

% DetailForNewUpDownOK

load UpDown
load DataMCLFP

[UpN,DownN,TransitionUpDo,TransitionDoUp,listOK]=NewUpDown(Y,tps,DebutUp,FinUp);


lu=find(UpN(:,2)-UpN(:,1)>0);
UpN=UpN(lu,:);

ld=find(DownN(:,2)-DownN(:,1)>0);
DownN=DownN(ld,:);

lt1=find(TransitionUpDo(:,2)-TransitionUpDo(:,1)>0);
TransitionUpDo=TransitionUpDo(lt1,:);

lt2=find(TransitionDoUp(:,2)-TransitionDoUp(:,1)>0);
TransitionDoUp=TransitionDoUp(lt2,:);
% 
% 
% for i=1:length(UpN)-1
% if UpN(i,2)>UpN(i+1,1)
%    UpN(i+1,1)=UpN(i,2);  
% end    
% end

DebutUp=UpN(:,1);
FinUp=UpN(:,2);
% 
% 
% for i=1:length(DownN)-1
% if DownN(i,2)>DownN(i+1,1)
%    DownN(i+1,1)=DownN(i,2); 
%    disp(i)
% end    
% end

DebutDown=DownN(:,1);
FinDown=DownN(:,2);


save UpDownCorrected DebutUp FinUp DebutDown FinDown

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%pour visualiser

if 1
    
load Data

PlotUpStates(data,X,tps,DebutUp,FinUp)
hold on
plot(UpN(:,2),-35+zeros(length(UpN),1),'ro','markerfacecolor','r')

line([UpN(:,2) UpN(:,2)],[-60 -10],'color','r')
line([UpN(:,1) UpN(:,1)],[-60 -10],'color','g')

plot(UpN(:,1),-35+zeros(length(UpN),1),'go','markerfacecolor','g')
plot(DownN(:,2),-35+zeros(length(DownN),1),'bo','markerfacecolor','b')
plot(DownN(:,1),-35+zeros(length(DownN),1),'ko','markerfacecolor','k')

line([DownN(:,2) DownN(:,2)],[-60 -10],'color','b')
line([DownN(:,1) DownN(:,1)],[-60 -10],'color','k')


end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



%pour la moyenne des Up
M1=mean(UpN(:,2)-UpN(:,1));

%pour la moyenne des Down
M2=mean(DownN(:,2)-DownN(:,1));

%pour la moyenne de la transition Up -> Down
M3=mean(TransitionUpDo(:,2)-TransitionUpDo(:,1));

%pour la moyenne de la transition Down -> Up
M4=mean(TransitionDoUp(:,2)-TransitionDoUp(:,1));



%pour la moyenne du potentiel de membrane pendant les Up
EpochUp=intervalSet(UpN(:,1)*1E4,UpN(:,2)*1E4);
M5=mean(Data(Restrict(tsd(tps*1E4,X),EpochUp)));


%pour la moyenne du potentiel de membrane pendant les Down
EpochDown=intervalSet(DownN(:,1)*1E4,DownN(:,2)*1E4);
M6=mean(Data(Restrict(tsd(tps*1E4,X),EpochDown)));

%pour l'amplitude des Up:
M7=abs(M6-M5);


save DataNewUpDown M1 M2 M3 M4 M5 M6 M7

% -----------------------------------------------------------------
fid = fopen('DataNewUpDown.txt','w');

    fprintf(fid,'%s\r\n','moyenne des Up: ',num2str(M1));
    fprintf(fid,'%s\r\n','moyenne des Down: ',num2str(M2));
    fprintf(fid,'%s\r\n','moyenne de la transition Up -> Down: ',num2str(M3));
    fprintf(fid,'%s\r\n','moyenne de la transition Down -> Up: ',num2str(M4));
    fprintf(fid,'%s\r\n','moyenne du potentiel de membrane pendant les Up: ',num2str(M5));
    fprintf(fid,'%s\r\n','moyenne du potentiel de membrane pendant les Down: ',num2str(M6));
    fprintf(fid,'%s\r\n','amplitude des UP: ',num2str(M7));

fclose(fid);

% _________________________________________________________________________
load Data
load DataMCLFP
load Spikes
load UpDownCorrected

[Res,numfig]=PatchCellProperties(Y+X(1),tps,spikes,DebutUp,FinUp,1);
save ResultsNEW Res
% _________________________________________________________________________
