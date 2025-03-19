

pwd = '/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240202_saline/';

%% EMG - OB
for l=[4 11 2] % EMG, OB, AuCx
    load([pwd 'LFPData/LFP' num2str(l) '.mat'])
    LFP_ferret{l} = LFP;
    LFP_ferret_Fil{l} = FilterLFP(LFP,[20 100],1024);
    LFP_ferret_Fil2{l} = FilterLFP(LFP,[50 300],1024);
    LFP_ferret_Fil3{l} = FilterLFP(LFP,[.5 10],1024);
end

figure
subplot(121)
i=0;
plot(Range(LFP_ferret_Fil2{4},'s') , Data(LFP_ferret_Fil2{4})-i*4.5e3 , 'k'), hold on
i=i+1;
plot(Range(LFP_ferret_Fil{11},'s') , Data(LFP_ferret_Fil{11})-i*4.5e3 , 'k')
i=i+1;
plot(Range(LFP_ferret_Fil3{2},'s') , (Data(LFP_ferret_Fil3{2})-Data(LFP_ferret_Fil3{4}))*2-i*4.5e3 , 'k' , 'LineWidth',1)
xlim([191.5 195.5]), ylim([-12e3 4e3]), axis off
text(191,0,'EMG','FontSize',15)
text(191,-4200,'OB','FontSize',15)
text(191,-9000,'EEG','FontSize',15)
text(192.5,3500,'Wake','FontSize',20)

subplot(122)
i=0;
plot(Range(LFP_ferret_Fil2{4},'s') , Data(LFP_ferret_Fil2{4})-i*4.5e3 , 'k'), hold on
i=i+1;
plot(Range(LFP_ferret_Fil{11},'s') , Data(LFP_ferret_Fil{11})-i*4.5e3 , 'k')
i=i+1;
plot(Range(LFP_ferret_Fil3{2},'s') , Data(LFP_ferret_Fil3{2})*2-i*4.5e3 , 'k' , 'LineWidth',1)
xlim([6886 6890]), ylim([-12e3 4e3]), axis off
text(6886+1.5,3500,'Sleep','FontSize',20)





%% accelero - OB
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














