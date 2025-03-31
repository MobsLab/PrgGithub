Mice = [666,668,669];
for mm=1:3
    FileName = {'/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Day',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Night',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Day_saline',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Night_saline',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Day_fluoxetine',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Night_fluoxetine',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Day_fluoxetine48H',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Night_fluoxetine48H'};
    FileName = strrep(FileName,'MouseX',['Mouse',num2str(Mice(mm))]);
        
    for f = 1:length(FileName)
        cd(FileName{f})
        load('Ripples.mat')
        load('StateEpochSB.mat','SWSEpoch')
        RipDens(mm,f) = size(RipplesR,1)./sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));
        clear RipplesR SWSEpoch
    end
    
end


figure
subplot(121)
PlotErrorBarN_KJ(RipDens(:,1:2:7),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('Ripple density')
title('day')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})
subplot(122)
PlotErrorBarN_KJ(RipDens(:,2:2:8),'newfig',0,'paired',1,'optiontest','ranksum')
ylabel('Ripple density')
title('night')
set(gca,'XTick',[1:4],'XTickLabel',{'Base','SAL','FLX','FLX+24'})
