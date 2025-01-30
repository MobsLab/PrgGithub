clear all
GetEmbReactMiceFolderList_BM
Session_type={'Ext','CondPre','CondPost'};
for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.Resp.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'respi_freq_BM');
    [TSD_DATA.HR.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'heartrate');
    [TSD_DATA.HRVar.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'heartratevar');
    [TSD_DATA.Rip.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'wake_ripples');
end
cd /media/nas6/ProjetEmbReact
save('DataAllMiceDrugs.mat','-v7.3')



% 
% 1 = total
% 2 = after stim
% 3 = freeze
% 4 = no reeze
% 5 = shock fz
% 6 = safe fz
% 7 =  shock no fz
% 8 = safe no fz
% 
%  

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};
close all
step = 0.4;
SessType = 'CondPost';
for group = 1:8
if group==1 % saline mice
    MouseID=[688,739,777,779,849,893,1096]; % add 1096
elseif group==2 % chronic flx mice
    MouseID=[875,876,877,1001,1002,1095];
elseif group==3 % Acute Flx
    MouseID=[740,750,775,778,794];
elseif group==4 % midazolam mice
    MouseID=[829,851,857,858,859,1005,1006];
elseif group==5 % saline short BM
     MouseID=[1144,1146,1147,1170,1171,1174,9184,1189,9205]; % no 1172 1200 1204 1206 1207
elseif group==6 % diazepam short 
    MouseID=[11147,11184,11189,11200,11204,11205,11206,11207]; 
elseif group==7 % saline long
    MouseID=[1184 1205 1224 1225 1226 1227];
elseif group==8 % diazepam long BM
    MouseID=[11225 11226 11203 1199 1230];
%    MouseID=[11225 11226];
end
fig = figure('name',Drug_Group{group})
MOI = find(ismember(Mouse,MouseID));
AllDatSk{group} = [];
AllDatSf{group} = [];
IndivSf{group} = [];
IndivSk{group} = [];
for mm = 1:length(MOI)
subplot(3,3,mm)
nhist({Data(TSD_DATA.(SessType).respi_freq_BM.tsd{MOI(mm),6}),Data(TSD_DATA.(SessType).respi_freq_BM.tsd{MOI(mm),5})});
xlim([0 10])
AllDatSf{group} = [AllDatSf{group};Data(TSD_DATA.(SessType).respi_freq_BM.tsd{MOI(mm),6})];
AllDatSk{group} = [AllDatSk{group};Data(TSD_DATA.(SessType).respi_freq_BM.tsd{MOI(mm),5})];


[Y,X] = hist(Data(TSD_DATA.(SessType).respi_freq_BM.tsd{MOI(mm),6}),[1:step:10]);
IndivSf{group}(mm,:) = Y/sum(Y);
[Y,X] = hist(Data(TSD_DATA.(SessType).respi_freq_BM.tsd{MOI(mm),5}),[1:step:10]);
IndivSk{group}(mm,:) = Y/sum(Y);
end
fig = figure('name',Drug_Group{group})

subplot(311)
nhist({AllDatSf{group},AllDatSk{group}})

subplot(312)
plot([1:step:10],IndivSf{group}','b')
hold on
plot([1:step:10],IndivSk{group}','r')

subplot(313)
errorbar([1:step:10],nanmean(IndivSf{group}),stdError(IndivSf{group}),'b')
hold on
errorbar([1:step:10],nanmean(IndivSk{group}),stdError(IndivSk{group}),'r')

end

figure
subplot(231)
group = 5
errorbar([1:step:10],nanmean(IndivSf{group}),stdError(IndivSf{group}),'b')
hold on
group = 6
errorbar([1:step:10],nanmean(IndivSf{group}),stdError(IndivSf{group}),'c')
xlabel('Frequency (hz)')
title('Short')
legend('sal','dzp')
ylim([0 0.3])
subplot(234)
group = 5
errorbar([1:step:10],nanmean(IndivSk{group}),stdError(IndivSk{group}),'r')
group = 6
hold on,errorbar([1:step:10],nanmean(IndivSk{group}),stdError(IndivSk{group}),'m')
xlabel('Frequency (hz)')
legend('sal','dzp')
ylim([0 0.3])


subplot(232)
group = 7
errorbar([1:step:10],nanmean(IndivSf{group}),stdError(IndivSf{group}),'b')
hold on
group = 8
errorbar([1:step:10],nanmean(IndivSf{group}),stdError(IndivSf{group}),'c')
xlabel('Frequency (hz)')
title('Long')
legend('sal','dzp')
ylim([0 0.3])
subplot(235)
group = 7
errorbar([1:step:10],nanmean(IndivSk{group}),stdError(IndivSk{group}),'r')
group = 8
hold on,errorbar([1:step:10],nanmean(IndivSk{group}),stdError(IndivSk{group}),'m')
xlabel('Frequency (hz)')
legend('sal','dzp')
ylim([0 0.3])


subplot(233)
AllSal = [IndivSf{5};IndivSf{7}];
AllDzp = [IndivSf{6};IndivSf{8}];
errorbar([1:step:10],nanmean(AllSal),stdError(AllSal),'b')
hold on
errorbar([1:step:10],nanmean(AllDzp),stdError(AllDzp),'c')
xlabel('Frequency (hz)')
title('both')
legend('sal','dzp')
ylim([0 0.3])
subplot(236)
AllSal = [IndivSk{5};IndivSk{7}];
AllDzp = [IndivSk{6};IndivSk{8}];
errorbar([1:step:10],nanmean(AllSal),stdError(AllSal),'r')
hold on
errorbar([1:step:10],nanmean(AllDzp),stdError(AllDzp),'m')
xlabel('Frequency (hz)')
legend('sal','dzp')
ylim([0 0.3])
