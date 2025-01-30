

%BilanOldNewMitral



%Res=[nbspk/temps maxAuto Skew Kurto Indice PBimod PUnimod p Delai nbspkUp/DureeUpTotal (nbspk-nbspkUp)/DureeDownTotal nbupStates/temps DureeUp DureeDown amplUp DureeUpTotal DureeDownTotal percS percE percSm percEm MembPot PotUp PotDown AmpSpk AhpSpk FreqS0 mSpect];
 
l=0;
l=l+1;labels{l}='nbspk/temps';
l=l+1;labels{l}='maxAuto';
l=l+1;labels{l}='Skew';
l=l+1;labels{l}='Kurto';
l=l+1;labels{l}='Indice';
l=l+1;labels{l}='PBimod';
l=l+1;labels{l}='PUnimod';
l=l+1;labels{l}='P test unimod';
l=l+1;labels{l}='P test bimod';
l=l+1;labels{l}='Delai';
l=l+1;labels{l}='nbspkUp/DureeUpTotal';
l=l+1;labels{l}='(nbspk-nbspkUp)/DureeDownTotal';
l=l+1;labels{l}='nbupStates/temps';
l=l+1;labels{l}='DureeUp';
l=l+1;labels{l}='DureeDown';
l=l+1;labels{l}='amplUp';
l=l+1;labels{l}='DureeUpTotal';
l=l+1;labels{l}='DureeDownTotal';
l=l+1;labels{l}='percS';
l=l+1;labels{l}='percE';
l=l+1;labels{l}='percSm';
l=l+1;labels{l}='percEm';
l=l+1;labels{l}='MembPot';
l=l+1;labels{l}='PotUp';
l=l+1;labels{l}='PotDown';
l=l+1;labels{l}='AmpSpk';
l=l+1;labels{l}='AhpSpk';
l=l+1;labels{l}='FreqSO';
l=l+1;labels{l}='mSpect';


%--------------------------------------------------------------
%--------------------------------------------------------------
%--------------------------------------------------------------


% cd /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/NewPaper/DataNewPaper/DataMitralKO/OLD/
% 
% 
% load AnaSWSCtrl
% 
% HistoDownTcO=HistoDownT;
% HistoUpTcO=HistoUpT;
% RcO=R;
% %Rc=R(R(:,9)<1,:);
% 
% load  AnaSWSdoKO
% 
% HistoDownTdO=HistoDownT;
% HistoUpTdO=HistoUpT;
% RdO=R;
% %Rd=R(R(:,9)<1,:);
%  
% cd /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/NewPaper/DataNewPaper/DataMitralKO/NEW
% 
% load AnaSWSCtrl
% 
% HistoDownTcN=HistoDownT;
% HistoUpTcN=HistoUpT;
% RcN=R;
% %Rc=R(R(:,9)<1,:);
% 
% load  AnaSWSdoKO
% 
% HistoDownTdN=HistoDownT;
% HistoUpTdN=HistoUpT;
% RdN=R;
% %Rd=R(R(:,9)<1,:);

%--------------------------------------------------------------



cd /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/NewPaper/DataNewPaper/DataMitralKO



load AnaSWSoldCtrl

HistoDownTcO=HistoDownT;
HistoUpTcO=HistoUpT;
RcO=R;
%Rc=R(R(:,9)<1,:);
ConTCo=Cont;
NomCellulesCtrlOld=nomcellule;
clear nomcellule
clear Cont
clear R

load  AnaSWSolddoKO

HistoDownTdO=HistoDownT;
HistoUpTdO=HistoUpT;
RdO=R;
%Rd=R(R(:,9)<1,:);
ConTDo=Cont;
NomCellulesdoKOOld=nomcellule;
clear nomcellule
clear Cont
clear R

load AnaSWSnewCtrl

HistoDownTcN=HistoDownT;
HistoUpTcN=HistoUpT;
RcN=R;
%Rc=R(R(:,9)<1,:);
ConTCn=Cont;

NomCellulesCtrlNew=nomcellule;
clear nomcellule
clear Cont
clear R

load  AnaSWSnewdoKO

HistoDownTdN=HistoDownT;
HistoUpTdN=HistoUpT;
RdN=R;
%Rd=R(R(:,9)<1,:);
ConTDn=Cont;

NomCellulesdoKONew=nomcellule;
clear nomcellule
clear Cont
clear R



%--------------------------------------------------------------
%--------------------------------------------------------------
%--------------------------------------------------------------

setdata='n';
met=4; % if 1 Indice; if 2 test bimodal; if 3 test bimodal (Anton); if 4 manual selection; if 5 manul selection & Bimod
    psii1=0.05;    % lim Unimod
    psii2=0.05; %lim Bimod   
    limI=200; %200 : 'all neurones'
plotfig=1;


%--------------------------------------------------------------


if setdata=='n'

    Rc=RcN;
    Rd=RdN;
    HistoDownTc=HistoDownTcN;
    HistoUpTc=HistoUpTcN;
    HistoDownTd=HistoDownTdN;
    HistoUpTd=HistoUpTdN;
    ConTC=ConTCn;
    ConTD=ConTDn;

    NomCellulesTotalCtrl=NomCellulesCtrlNew;
    NomCellulesTotaldoKO=NomCellulesdoKONew;

% 
elseif setdata=='o'
    Rc=RcO;
    Rd=RdO;
    HistoDownTd=HistoDownTdO;
    HistoUpTd=HistoUpTdO;
    HistoDownTc=HistoDownTcO;
    HistoUpTc=HistoUpTcO;
    ConTC=ConTCo;
    ConTD=ConTDo;
    NomCellulesTotalCtrl=NomCellulesCtrlOld;
    NomCellulesTotaldoKO=NomCellulesdoKOOld;

elseif setdata=='a'
    Rc=[RcN; RcO];
    Rd=[RdN; RdO];
    HistoDownTc=[HistoDownTcN;HistoDownTcO];
    HistoUpTc=[HistoUpTcN;HistoUpTcO];
    HistoDownTd=[HistoDownTdN;HistoDownTdO];
    HistoUpTd=[HistoUpTdN;HistoUpTdO];
    ConTC=[ConTCn;ConTCo];
    ConTD=[ConTDn;ConTDo];

    NomCellulesTotalCtrl=NomCellulesCtrlNew;
    
    le1=length(NomCellulesTotalCtrl);
    le=length(NomCellulesCtrlOld);
    a=le1+1;
    
    for i=1:le
        NomCellulesTotalCtrl{a}=NomCellulesCtrlOld{i};
        a=a+1;
    end

    NomCellulesTotaldoKO=NomCellulesdoKONew;
    
    le1=length(NomCellulesTotaldoKO);
    le=length(NomCellulesdoKOOld);
    a=le1+1;
    
    for i=1:le
        NomCellulesTotaldoKO{a}=NomCellulesdoKOOld{i};
        a=a+1;
    end


end


% size(Rc)
% size(HistoDownTc)
% size(HistoUpTc)
% 
% size(Rd)
% size(HistoDownTd)
% size(HistoUpTd)




    if met==1
         listC=find(Rc(:,5)<limI);
    elseif met==2
    listC=find(Rc(:,8)>psii1&Rc(:,9)<psii2);
    elseif met==3
    listC=find(Rc(:,6)>psii1&Rc(:,7)<psii2);
    elseif met==4
    listC=find(ConTC==1);
    elseif met==5
    listC=find(ConTC==1&Rc(:,7)<psii2);
    end
    
    HistoDownTc=HistoDownTc(listC,:);
    HistoUpTc=HistoUpTc(listC,:);
    Rc=Rc(listC,:);
    ConTC=ConTC(listC);
    NomCellulesTotalCtrl=NomCellulesTotalCtrl(listC);

        if met==1
    listD=find(Rd(:,5)<limI);
        elseif met==2
    listD=find(Rd(:,8)>psii1&Rd(:,9)<psii2);
        elseif met==3
    listD=find(Rd(:,6)>psii1&Rd(:,7)<psii2);
    elseif met==4
    listD=find(ConTD==1);
        elseif met==5
    listD=find(ConTD==1&Rd(:,7)<psii2);
        end
        
    HistoDownTd=HistoDownTd(listD,:);
    HistoUpTd=HistoUpTd(listD,:);
    Rd=Rd(listD,:);
    ConTD=ConTD(listD);
    NomCellulesTotaldoKO=NomCellulesTotaldoKO(listD);



%--------------------------------------------------------------
%--------------------------------------------------------------
%--------------------------------------------------------------

xx=100;
figure('color',[1 1 1]), hold on
hold on, plot(binUp,sum(HistoDownTc)/sum(sum(HistoDownTc)),'k','linewidth',1),xlim([0 xx])
hold on, plot(binUp,sum(HistoDownTd)/sum(sum(HistoDownTd)),'r','linewidth',1),xlim([0 xx])
title('Down States')

figure('color',[1 1 1]), hold on
hold on, plot(binUp,sum(HistoUpTc)/sum(sum(HistoUpTc)),'k','linewidth',1),xlim([0 xx])
hold on, plot(binUp,sum(HistoUpTd)/sum(sum(HistoUpTd)),'r','linewidth',1),xlim([0 xx])
title('Up States')

for i=1:size(Rc,2)
    try
 [h,p(i)]=ttest2(Rc(:,i),Rd(:,i));
p2(i)=ranksum(Rc(:,i),Rd(:,i));
    catch
    p(i)=NaN;    
    end
    
    [nanmean(Rc(:,i)) nanmean(Rd(:,i))]
    
    %if p(i)<0.1
    [nanstd(Rc(:,i)) nanstd(Rd(:,i))]
    %end
    
    disp([labels{i},' ',num2str(p(i))])
    disp(' ')
end
 
%set(gca,'xtick',[1:length(labels)])
%set(gca,'Xticklabel',labels)
                    
 


%--------------------------------------------------------------
%--------------------------------------------------------------
%--------------------------------------------------------------


% figure('color',[1 1 1]), 
% subplot(2,1,1), hold on
% plot(Rc(:,19),Rc(:,21),'ko','markerfacecolor','k')
% plot(Rd(:,19),Rd(:,21),'ro','markerfacecolor','r')
% title([labels{19},' ',labels{21}])
% 
% subplot(2,1,2), hold on
% plot(Rc(:,20),Rc(:,22),'ko','markerfacecolor','k')
% plot(Rd(:,20),Rd(:,22),'ro','markerfacecolor','r')
% title([labels{20},' ',labels{22}])


if plotfig
for i=1:29

figure('color',[1 1 1]), 
subplot(2,2,1), hold on
plot(Rc(:,14),Rc(:,i),'ko','markerfacecolor','k')
plot(Rd(:,14),Rd(:,i),'ro','markerfacecolor','r')

if setdata=='a'
plot(Rc(1:18,14),Rc(1:18,i),'bo','markerfacecolor','b')
plot(Rd(1:5,14),Rd(1:5,i),'mo','markerfacecolor','m')
end

title([labels{14},' ',labels{i}])

subplot(2,2,3), hold on
plot(Rc(:,15),Rc(:,i),'ko','markerfacecolor','k')
plot(Rd(:,15),Rd(:,i),'ro','markerfacecolor','r')

if setdata=='a'
plot(Rc(1:18,15),Rc(1:18,i),'bo','markerfacecolor','b')
plot(Rd(1:5,15),Rd(1:5,i),'mo','markerfacecolor','m')
end

title([labels{15},' ',labels{i}])


subplot(2,2,2), hold on
plot(Rc(:,16),Rc(:,i),'ko','markerfacecolor','k')
plot(Rd(:,16),Rd(:,i),'ro','markerfacecolor','r')

if setdata=='a'
plot(Rc(1:18,16),Rc(1:18,i),'bo','markerfacecolor','b')
plot(Rd(1:5,16),Rd(1:5,i),'mo','markerfacecolor','m')
end

title([labels{16},' ',labels{i}])

subplot(2,2,4), hold on
plot(Rc(:,13),Rc(:,i),'ko','markerfacecolor','k')
plot(Rd(:,13),Rd(:,i),'ro','markerfacecolor','r')

if setdata=='a'
plot(Rc(1:18,13),Rc(1:18,i),'bo','markerfacecolor','b')
plot(Rd(1:5,13),Rd(1:5,i),'mo','markerfacecolor','m')
end

title([labels{13},' ',labels{i}])

end


end


for i=1:29
disp([labels{i},'     ',num2str(p(i)),'    ',num2str(p2(i))])
end




