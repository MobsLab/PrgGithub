% Correlation_FreezImDiff_FreezAcc
% 25.10.2017

sav=0;
cd /media/DataMOBsRAIDN/ProjetAversion/OptoFear
res=pwd;

StepName={'HABlaser';'EXT-24'; 'EXT-48';'COND';};
stepN=2;
cd /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear-CTRL
temp_mov_ctrl= load([StepName{stepN} '_fullperiod_close2sound']);
temp_movacc_ctrl= load([StepName{stepN} '_fullperiod_close2sound_acc']);
% bilan_CTRL=bilan;
clear bilan


mice_acc=[244 248 253 254  299 395 402 403 450 451]; % EIB32 -> accelero data available : 231 258 259 excluded
mice_included=[231 244 248 253 254  258 259 299 395 402 403 450 451]; % EIB32 -> accelero data available :  excluded
acc_ok=[];
for k=1:length(mice_included)
    acc_ok=[acc_ok; ~isempty(find(mice_acc==mice_included(k)))];
 
end
figure('Position',[     104         747        1697         227]),
figure,  hold on,
for k=1:6
%     subplot(1,6,k)
    plot(temp_mov_ctrl.bilan{stepN}(logical(acc_ok),k), temp_movacc_ctrl.bilan{stepN}(:,k),'.');
    xlim([0 1]); ylim([0 1]);
    plot([0,1], [0 1],'-','Color',[0.5 0.5 0.5])
end
xlabel('Freeze ImDiff'),ylabel('Freez Acc'), 

if sav
    cd (res)
    saveas(gcf,'Correlation_FreezImDiff_FreezAcc_by_step.fig')
    saveFigure(gcf,'Correlation_FreezImDiff_FreezAcc_by_step', res)
end