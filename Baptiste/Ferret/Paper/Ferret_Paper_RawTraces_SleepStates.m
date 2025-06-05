


pwd = '/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240202_saline/';

%% EMG - OB
for l=[4 11 20 2] % EMG, OB, HPC, AuCx
    load([pwd 'LFPData/LFP' num2str(l) '.mat'])
    LFP_ferret{l} = LFP;
end
l = 11; LFP_ferret_Fil{l} = FilterLFP(LFP_ferret{l},[20 100],1024);
l = 4; LFP_ferret_Fil2{l} = FilterLFP(LFP_ferret{l},[50 300],1024);
l = 2; LFP_ferret_Fil3{l} = FilterLFP(LFP_ferret{l},[.5 10],1024);
l = 4; LFP_ferret_Fil3{l} = FilterLFP(LFP_ferret{l},[.5 10],1024);
l = 11; LFP_ferret_Fil4{l} = FilterLFP(LFP_ferret{l},[.1 100],1024);
l = 20; LFP_ferret_Fil5{l} = FilterLFP(LFP_ferret{l},[.1 100],1024);

figure
subplot(131)
i=0;
plot(Range(LFP_ferret_Fil2{4},'s') , Data(LFP_ferret_Fil2{4})-i*4.5e3 , 'k'), hold on
i=i+1;
plot(Range(LFP_ferret_Fil5{20},'s') , Data(LFP_ferret_Fil5{20})*2-i*4.5e3 , 'k'), hold on
i=i+1;
plot(Range(LFP_ferret_Fil4{11},'s') , (Data(LFP_ferret_Fil4{11}))-i*4.5e3 , 'k'), hold on
i=i+1;
plot(Range(LFP_ferret_Fil{11},'s') , Data(LFP_ferret_Fil{11})-i*4.5e3 , 'k')
xlim([12586 12590]), ylim([-16e3 4e3]), axis off % xlim([12840 12844])
text(12585,0,'EMG','FontSize',15)
text(12585,-4200,'HPC','FontSize',15)
text(12585,-9000,'OB','FontSize',15)
text(12585,-13000,'OB gamma','FontSize',15)

subplot(132)
i=0;
plot(Range(LFP_ferret_Fil2{4},'s') , Data(LFP_ferret_Fil2{4})-i*4.5e3 , 'k'), hold on
i=i+1;
plot(Range(LFP_ferret_Fil5{20},'s') , Data(LFP_ferret_Fil5{20})*2-i*4.5e3 , 'k'), hold on
i=i+1;
plot(Range(LFP_ferret_Fil4{11},'s') , (Data(LFP_ferret_Fil4{11}))-i*4.5e3 , 'k'), hold on
i=i+1;
plot(Range(LFP_ferret_Fil{11},'s') , Data(LFP_ferret_Fil{11})-i*4.5e3 , 'k')
xlim([9621 9625]), ylim([-16e3 4e3]), axis off 

subplot(133)
i=0;
plot(Range(LFP_ferret_Fil2{4},'s') , Data(LFP_ferret_Fil2{4})-i*4.5e3 , 'k'), hold on
i=i+1;
plot(Range(LFP_ferret_Fil5{20},'s') , Data(LFP_ferret_Fil5{20})*2-i*4.5e3 , 'k'), hold on
i=i+1;
plot(Range(LFP_ferret_Fil4{11},'s') , (Data(LFP_ferret_Fil4{11}))-i*4.5e3 , 'k'), hold on
i=i+1;
plot(Range(LFP_ferret_Fil{11},'s') , Data(LFP_ferret_Fil{11})-i*4.5e3 , 'k')
xlim([10003 10007]), ylim([-16e3 4e3]), axis off




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% with accelero
pwd = '/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240202_saline/';

l=11;
load([pwd 'LFPData/LFP' num2str(l) '.mat'])
LFP_ferret{l} = LFP;
LFP_ferret_Fil{l} = FilterLFP(LFP_ferret{l},[20 100],1024);

load([pwd 'behavResources.mat'])
Smooth_Acc = tsd(Range(MovAcctsd) , movmean(Data(MovAcctsd),10,'omitnan'));


figure
subplot(121)
bar(Range(Smooth_Acc,'s') , Data(Smooth_Acc)/1e5+200 , 'k' , 'LineWidth',1)
hold on
plot(Range(LFP_ferret_Fil{11},'s') , Data(LFP_ferret_Fil{11})+5e3 , 'k')
xlim([191.5 195.5]), axis off
text(191,1e3,'Motion','FontSize',15)
text(191,5e3,'OB','FontSize',15)
text(192.5,8e3,'Wake','FontSize',20)

subplot(122)
bar(Range(Smooth_Acc,'s') , Data(Smooth_Acc)/1e5+200 , 'k' , 'LineWidth',1)
hold on
plot(Range(LFP_ferret_Fil{11},'s') , Data(LFP_ferret_Fil{11})+5e3 , 'k')
xlim([6886 6890]), ylim([0 8e3]), axis off
text(6886+1.5,8e3,'Sleep','FontSize',20)


