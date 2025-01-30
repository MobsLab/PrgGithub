%QuantifExploICSS
%-------------
marie=1;
if marie==1
    Cd='/media/MarieBackUp/DataProjetSommeil';
else 
    Cd='/media/KARIMBACKUP/Data/ICSS-Sleep';
end

Mouse='/Mouse013';
Date='/20110420';
File{1}='/ExploQuantif';File{2}='/ExploQuantif2';
cd(['/home/marie/',f,'/',g])

manipe=13; %manipe=9; %manipe=5;
adj=0; %adj=20; %adj=30;
%--------------------

if manipe==13
    cd([Cd,Mouse,Date,File{2},'/ICSS-Mouse-',Mouse(8:9),'-',Date(2:end)])
SetCurrentSession
evt=GetEvents('output','Descriptions');  
SessionNameExplo='ICSS-Mouse-13-20042011-15-Explo-wideband'; 
SessionName='ICSS-Mouse-13-20042011-13-QuantifExplo3-wideband'; manipe=13;

elseif manipe==5 || manipe==9
    cd([Cd,Mouse,Date,File{1},'/ICSS-Mouse-',Mouse(8:9),'-',Date(2:end)])
    SetCurrentSession
    evt=GetEvents('output','Descriptions');
    if manipe==5
        SessionNameExplo='ICSS-Mouse-13-20042011-07-ICSSexplo8V1-wideband';
        SessionName='ICSS-Mouse-13-20042011-05-QuantifExplo-wideband';manipe=5;
    elseif manipe==9
        SessionNameExplo='ICSS-Mouse-13-20042011-07-ICSSexplo8V1-wideband';
        SessionName='ICSS-Mouse-13-20042011-09-QuantifExplo2-wideband'; manipe=9;
    end    
end

%--------------------------------------------------------------------------


deb=GetEvents(['beginning of ',SessionNameExplo])+5;
fin=GetEvents(['end of ',SessionNameExplo])-5;
ExploEpoch=intervalSet(deb*1E4,fin*1E4);

load behavResources
X=Restrict(X,ExploEpoch);
Y=Restrict(Y,ExploEpoch);
V=Restrict(V,ExploEpoch);

figure('Color',[1 1 1]),
subplot(2,1,1), hold on
plot(Data(X),Data(Y),'Color',[0.7 0.7 0.7])

% SessionName='ICSS-Mouse-13-20042011-12-ICSSexplo8V3-wideband';
% deb=GetEvents(['beginning of ',SessionName])+5;
% fin=GetEvents(['end of ',SessionName])-5;
% ExploEpoch=intervalSet(deb*1E4,fin*1E4);
% 
% load behavResources
% X=Restrict(X,ExploEpoch);
% Y=Restrict(Y,ExploEpoch);
% V=Restrict(V,ExploEpoch);
% 
% 
% plot(Data(X),Data(Y),'Color','k')

deb=GetEvents(['beginning of ',SessionName]);
fin=GetEvents(['end of ',SessionName]);
ExploEpoch=intervalSet(deb*1E4,fin*1E4);

load behavResources
X=Restrict(X,ExploEpoch);
Y=Restrict(Y,ExploEpoch);
V=Restrict(V,ExploEpoch);

5

%Trial 1
%-------------------------------------------------------------

%StartTrial1=GetEvents('101')*1E4;
%EndTrial1=GetEvents('102')*1E4;

if manipe==13
%ExploQuantif1-13
StartTrial1=(90+deb)*1E4;
EndTrial1=(140+deb)*1E4;
end


if manipe==5
%ExploQuantif1-05
StartTrial1=(80+deb)*1E4;
EndTrial1=(135+deb)*1E4;
end

if manipe==9
%ExploQuantif1-05
StartTrial1=(8+deb)*1E4;
EndTrial1=(60+20+deb)*1E4;
end


%Trial 2
%-------------------------------------------------------------

if manipe==13
%ExploQuantif1-15
StartTrial2=GetEvents('103')*1E4;
EndTrial2=GetEvents('104')*1E4;
end

if manipe==5
%ExploQuantif1-05
StartTrial2=(3*60+54+deb)*1E4;
EndTrial2=(4*60+45+deb)*1E4;
end

if manipe==9
%ExploQuantif1-05
StartTrial2=(3*60+5+deb)*1E4;
EndTrial2=(4*60+1+deb)*1E4;
end

%Trial 3
%-------------------------------------------------------------

if manipe==13
%ExploQuantif1-15
StartTrial3=GetEvents('105')*1E4;
EndTrial3=GetEvents('106')*1E4;
end

if manipe==5
%ExploQuantif1-05
StartTrial3=(6*60+44+deb)*1E4;
EndTrial3=(7*60+30+deb)*1E4;
end


if manipe==9
%ExploQuantif1-05
StartTrial3=(5*60+34+deb)*1E4;
EndTrial3=(6*60+25+deb)*1E4;
end

%Trial 4
%-------------------------------------------------------------

if manipe==13
StartTrial4=(GetEvents('107')-1)*1E4;
EndTrial4=(GetEvents('108')-2)*1E4;
end

if manipe==5
%ExploQuantif1-05
StartTrial4=(8*60+58+deb)*1E4;
EndTrial4=(9*60+28+deb)*1E4;
end

if manipe==9
%ExploQuantif1-05
StartTrial4=(7*60+55+deb)*1E4;
EndTrial4=(9*60+0+deb)*1E4;
end


%-------------------------------------------------------------


if manipe==5|manipe==9
    
StartTrial=[StartTrial1 StartTrial2 StartTrial3 StartTrial4];

if adj~=0
   EndTrial=[StartTrial1 StartTrial2 StartTrial3 StartTrial4]+adj*1E4;
else
    EndTrial=[EndTrial1 EndTrial2 EndTrial3 EndTrial4];

end

end

if manipe==13
StartTrial=[StartTrial1 StartTrial2 StartTrial4];

if adj~=0
   EndTrial=[StartTrial1 StartTrial2 StartTrial4]+adj*1E4;
else
EndTrial=[EndTrial1 EndTrial2 EndTrial4];
end
end

%-------------------------------------------------------------







TestExplo=intervalSet(StartTrial,EndTrial);






trajectory=subset(TestExplo,1);
hold on, plot(Data(Restrict(X,trajectory)),Data(Restrict(Y,trajectory)),'r','linewidth',2)
hold on, plot(Data(Restrict(X,Start(trajectory))),Data(Restrict(Y,Start(trajectory))),'o','Color',[0.5 0 0],'linewidth',10)


trajectory=subset(TestExplo,2);
hold on, plot(Data(Restrict(X,trajectory)),Data(Restrict(Y,trajectory)),'g','linewidth',2)
hold on, plot(Data(Restrict(X,Start(trajectory))),Data(Restrict(Y,Start(trajectory))),'o','Color',[0 0.5 0],'linewidth',10)


trajectory=subset(TestExplo,3);
hold on, plot(Data(Restrict(X,trajectory)),Data(Restrict(Y,trajectory)),'b','linewidth',2)
hold on, plot(Data(Restrict(X,Start(trajectory))),Data(Restrict(Y,Start(trajectory))),'o','Color',[0 0 0.6],'linewidth',10)

try
trajectory=subset(TestExplo,4);
hold on, plot(Data(Restrict(X,trajectory)),Data(Restrict(Y,trajectory)),'k','linewidth',2)
hold on, plot(Data(Restrict(X,Start(trajectory))),Data(Restrict(Y,Start(trajectory))),'o','Color',[0 0 0],'linewidth',10)
end

xlim([0 350])
ylim([0 300])


subplot(2,1,2), hold on


% deb=GetEvents(['beginning of ',SessionName])+5;
% fin=GetEvents(['end of ',SessionName])-5;
% ExploEpoch=intervalSet(deb*1E4,fin*1E4);
% 
% load behavResources
% X=Restrict(X,ExploEpoch);
% Y=Restrict(Y,ExploEpoch);
% V=Restrict(V,ExploEpoch);
% plot(Data(X),Data(Y),'Color',[0.7 0.7 0.7])


load behavResources
plot(Data(Restrict(X,TestExplo)),Data(Restrict(Y,TestExplo)),'k.','linewidth',4)
xlim([0 350])
ylim([0 300])


deb=GetEvents(['beginning of ',SessionName]);
fin=GetEvents(['end of ',SessionName]);
ExploEpoch=intervalSet(deb*1E4,fin*1E4);

load behavResources
X=Restrict(X,ExploEpoch);
Y=Restrict(Y,ExploEpoch);
V=Restrict(V,ExploEpoch);





if manipe==13
save Manipe13
end

if manipe==9
save Manipe9
end

if manipe==5
save Manipe5
end


