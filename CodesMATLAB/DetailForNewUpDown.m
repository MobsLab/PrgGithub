% DetailForNewUpDown

load UpDown
load DataMCLFP

[UpN,DownN,TransitionUpDo,TransitionDoUp,listOK]=NewUpDown(Y,tps,DebutUp,FinUp);


lu=find(UpN(:,2)-UpN(:,1)>0);
ld=find(DownN(:,2)-DownN(:,1)>0);
lt1=find(TransitionUpDo(:,2)-TransitionUpDo(:,1)>0);
lt2=find(TransitionDoUp(:,2)-TransitionDoUp(:,1)>0);


l1=intersect(lu,ld);
l2=intersect(lt1,lt2);

l=intersect(l1,l2);

UpN=UpN(l,:);
DownN=DownN(ld,:);
TransitionUpDo=TransitionUpDo(l,:);
TransitionDoUp=TransitionDoUp(l,:);





for i=1:size(UpN,1)-1
if UpN(i,2)>UpN(i+1,1)
   UpN(i+1,1)=UpN(i,2)-0.01;  
end    
end

DebutUp=UpN(:,1);
FinUp=UpN(:,2);


for i=1:size(DownN,1)-1
if DownN(i,2)>DownN(i+1,1)
   DownN(i+1,1)=DownN(i,2)-0.01; 
   disp(i)
end    
end

DebutDown=DownN(:,1);
FinDown=DownN(:,2);


save UpDownCorrected DebutUp FinUp DebutDown FinDown TransitionUpDo TransitionDoUp UpN DownN ThM

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%pour visualiser

if 0
    
load Data
load UpDown
load DataMCLFP
PlotUpStates(data,X,tps,DebutUp,FinUp)
hold on
% plot(UpN(:,2),-35+zeros(length(UpN),1),'ro','markerfacecolor','r')
% plot(UpN(:,1),-35+zeros(length(UpN),1),'go','markerfacecolor','g')
% plot(DownN(:,2),-35+zeros(length(DownN),1),'bo','markerfacecolor','b')
% plot(DownN(:,1),-35+zeros(length(DownN),1),'ko','markerfacecolor','k')
load UpDownCorrected
plot(FinUp,-35+zeros(length(FinUp),1),'ro','markerfacecolor','r')
for j=1:size(FinUp,1)
line([FinUp(j) FinUp(j)],[-70 -10],'color','r')
line([DebutUp(j) DebutUp(j)],[-70 -10],'color','g')
end
plot(DebutUp,-35+zeros(length(DebutUp),1),'go','markerfacecolor','g')
plot(FinDown ,-35+zeros(length(DebutDown),1),'bo','markerfacecolor','b')
plot(DebutDown,-35+zeros(length(DebutDown),1),'ko','markerfacecolor','k')
for j=1:size(DebutDown,1)
    line([FinDown(j) FinDown(j)],[-70 -10],'color','b')
    line([DebutDown(j) DebutDown(j)],[-70 -10],'color','k')
end

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

save DataNewUpDown M1 M2 M3 M4 M5 M6

% -----------------------------------------------------------------
fid = fopen('DataNewUpDown.txt','w');

    fprintf(fid,'%s\r\n','moyenne des Up: ',num2str(M1));
    fprintf(fid,'%s\r\n','moyenne des Down: ',num2str(M2));
    fprintf(fid,'%s\r\n','moyenne de la transition Up -> Down: ',num2str(M3));
    fprintf(fid,'%s\r\n','moyenne de la transition Down -> Up: ',num2str(M4));
    fprintf(fid,'%s\r\n','moyenne du potentiel de membrane pendant les Up: ',num2str(M5));
    fprintf(fid,'%s\r\n','moyenne du potentiel de membrane pendant les Down: ',num2str(M6));

fclose(fid);

