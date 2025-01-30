% PotentielEvoqueCheck
% 20.05.2017
% aims at checking that the modulation we observe during laser stimulation
% is not due to evoked response of neurons to the light start or end

sav=1;
cd /media/DataMOBsRAIDN/ProjetAversion/SleepStim
resRslt=pwd;

Dir.path={
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
};
load('/media/DataMOBsRAIDN/ProjetAversion/SleepStim/ModNeurons_dur.mat')
mu_sau=mu;
mu(pval>0.05)=nan;

load Py_or_IN_ID
choose_Py_or_IN='Py';
if strcmp(choose_Py_or_IN,'Py')
    mu=mu(Py_or_IN==1,:);
    color2plot=[0 0 1];
elseif strcmp(choose_Py_or_IN,'IN')
    mu=mu(Py_or_IN==-1,:);
    color2plot=[1 0 0];
else
    color2plot=[0.7 0.7 0.7];
end

figure('Position',[        1926         724        1808         233])
for fq=1:8
    subplot(1,8,fq)
    hist(mu(:,fq),[0.628:0.628:6.28+1])
    %temp=mu(:,fq);
    %temp(isnan(temp))=[];
    %JustPoltMod(temp,15);
    title([ num2str(fq_list(fq)) ' Hz - n tot ' num2str(size(mu,1))])
    xlim([0 6.28+1])
    ylim([0 15])
    if fq==1; 
        ylabel('nb neurons');
        text(-0.2,1.05,choose_Py_or_IN, 'units','normalized')
    end
end
if sav
    saveas(gcf,['Phase_pref_' choose_Py_or_IN '.fig'])
    saveFigure(gcf,['Phase_pref_' choose_Py_or_IN], resRslt)
end


figure
PlotErrorSpreadN_KJ(mu,'plotcolors',color2plot,'newfig',0);hold on % Py  

figure;
delay=[];
for fq=1:length(fq_list)
    delay=[delay mu(:,fq)./(2*pi)./fq_list(fq)];%
end
PlotErrorSpreadN_KJ(delay,'plotcolors',color2plot,'newfig',0);hold on % Py 
set(gca,'XTick',[1:8],'XTickLabel',fq_list)
ylabel(' response delay (sec)')
title (['n = ' num2str(size(mu,1))])
plot([0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5]./fq_list,'Color',[ 0.5 0.5 0.5])

if sav
    cd(resRslt)
    saveas(gcf,['RespDelay_' choose_Py_or_IN '.fig'])
    saveFigure(gcf,['RespDelay_' choose_Py_or_IN ])
end