clear all
MouseGroup = {'Sal','Mdz','Flx','FlxChr'};
% Mice.Sal = [688,739,777,779,849,893];
% Mice.Flx = [740,750,778,775,794];
% Mice.Mdz = [829,851,856,857,858,859];
% Mice.FlxChr = [876];

Mice.Sal = [688,739,777,779,849,893];
Mice.Flx = [740,750,778,775,794];
Mice.Mdz = [829,851,856,857,858,859, 1005, 1006];
Mice.FlxChr = [875,876,877, 1001, 1002,1095];


cd /media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_ExtinctionBlockedSafe_PostDrug/Ext1
load('B_Low_Spectrum.mat')
fLow = Spectro{3};
load('H_VHigh_Spectrum.mat')
fHigh = Spectro{3};


%% Make the figures
sesstype = 3;
blocked=0;
ExtendedSafe =1; % set to one take into account the safe zone and the central safe zone, 
ReNorm=1;
ReNormTogether=1;

load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_B_Corr.mat'])
% load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Rip_Corr.mat'])
load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Fz_Corr_CS.mat'])
load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Zn_Corr_CS.mat'])
% load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_HR_Corr.mat'])
% load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_P_Corr.mat'])
% load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_BlkEpoch_Corr.mat'])


for mg = 1:4
    
    MeanOB.Shk.(MouseGroup{mg}) = [];
    MeanOB.Saf.(MouseGroup{mg}) = [];
     
    AllOB.Shk.(MouseGroup{mg}) = [];
    AllOB.Saf.(MouseGroup{mg}) = [];

    MeanP.Shk.(MouseGroup{mg}) = [];
    MeanP.Saf.(MouseGroup{mg}) = [];

    AllP.Shk.(MouseGroup{mg}) = [];
    AllP.Saf.(MouseGroup{mg}) = [];

    NumRipples.Shk.(MouseGroup{mg}) = [];
    NumRipples.Saf.(MouseGroup{mg}) = [];
    
    MeanHR.Shk.(MouseGroup{mg}) = [];
    MeanHR.Saf.(MouseGroup{mg}) = [];
    
    Fzdur.Shk.(MouseGroup{mg}) = [];
    Fzdur.Saf.(MouseGroup{mg}) = [];
    Fzdur.Tot.(MouseGroup{mg}) = [];

    
    StdHR.Shk.(MouseGroup{mg}) = [];h
    StdHR.Saf.(MouseGroup{mg}) = [];
    StdHR.Mov.(MouseGroup{mg}) = [];
    
end

%%
    
for gr = 1:length(MouseGroup)
    for m = 1:length(B.(MouseGroup{gr}))
        
        ShockEpoch = and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{1});
        if ExtendedSafe
         SafeEpoch = and(Fz.(MouseGroup{gr}){m},or(Zn.(MouseGroup{gr}){m}{2},Zn.(MouseGroup{gr}){m}{5}));
        else
         SafeEpoch = and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{2});
        end
        
        if blocked==1
            ShockEpoch=and(ShockEpoch,Blk.(MouseGroup{gr}){m});
            SafeEpoch=and(SafeEpoch,Blk.(MouseGroup{gr}){m});
        end
        
        Fzdur.Tot.(MouseGroup{gr})(m) = length(Data(Restrict(B.(MouseGroup{gr}){m},Fz.(MouseGroup{gr}){m})))./length(Data((B.(MouseGroup{gr}){m})));
        Fzdur.Shk.(MouseGroup{gr})(m) = length(Data(Restrict(B.(MouseGroup{gr}){m},ShockEpoch)))./length(Data((B.(MouseGroup{gr}){m})));;
        Fzdur.Saf.(MouseGroup{gr})(m) = length(Data(Restrict(B.(MouseGroup{gr}){m},SafeEpoch)))./length(Data((B.(MouseGroup{gr}){m})));

        
        MeanOB.Shk.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(B.(MouseGroup{gr}){m},ShockEpoch)));
        MeanOB.Saf.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(B.(MouseGroup{gr}){m},SafeEpoch)));
        
        valfordiv = nanmean([sum(MeanOB.Shk.(MouseGroup{gr})(m,10:end));sum(MeanOB.Saf.(MouseGroup{gr})(m,10:end))]);
        AllOB.Shk.(MouseGroup{gr}) = [AllOB.Shk.(MouseGroup{gr});Data(Restrict(B.(MouseGroup{gr}){m},ShockEpoch))./valfordiv];
        AllOB.Saf.(MouseGroup{gr}) = [AllOB.Saf.(MouseGroup{gr});Data(Restrict(B.(MouseGroup{gr}){m},SafeEpoch))./valfordiv];
        
        
%         MeanP.Shk.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(P.(MouseGroup{gr}){m},ShockEpoch)));
%         MeanP.Saf.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(P.(MouseGroup{gr}){m},SafeEpoch)));
%         AllP.Shk.(MouseGroup{gr}) = [AllP.Shk.(MouseGroup{gr});Data(Restrict(P.(MouseGroup{gr}){m},ShockEpoch))./valfordiv];
%         AllP.Saf.(MouseGroup{gr}) = [AllP.Saf.(MouseGroup{gr});Data(Restrict(P.(MouseGroup{gr}){m},SafeEpoch))./valfordiv];
        

        
%         if not(isempty(Range(Rip.(MouseGroup{gr}){m})))
%         NumRipples.Shk.(MouseGroup{gr})(m,:) = length(Range(Restrict(Rip.(MouseGroup{gr}){m},ShockEpoch)))./nansum(Stop(ShockEpoch,'s')-Start(ShockEpoch,'s'));
%         NumRipples.Saf.(MouseGroup{gr})(m,:) = length(Range(Restrict(Rip.(MouseGroup{gr}){m},SafeEpoch)))./nansum(Stop(SafeEpoch,'s')-Start(SafeEpoch,'s'));
%         else
%           NumRipples.Shk.(MouseGroup{gr})(m,:)  = NaN;
%           NumRipples.Saf.(MouseGroup{gr})(m,:)  = NaN;
%         end
%                 
%         MeanHR.Shk.(MouseGroup{gr})(m) = nanmean(Data(Restrict(HR.(MouseGroup{gr}){m},and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{1}))));
%         MeanHR.Saf.(MouseGroup{gr})(m) = nanmean(Data(Restrict(HR.(MouseGroup{gr}){m},and(Fz.(MouseGroup{gr}){m},or(Zn.(MouseGroup{gr}){m}{2},Zn.(MouseGroup{gr}){m}{5})))));
%         MeanHR.Mov.(MouseGroup{gr})(m) = nanmean(Data(Restrict(HR.(MouseGroup{gr}){m},or(Zn.(MouseGroup{gr}){m}{2},Zn.(MouseGroup{gr}){m}{1})-Fz.(MouseGroup{gr}){m})));
%         
%         StdHR.Shk.(MouseGroup{gr})(m) = std(Data(Restrict(HR.(MouseGroup{gr}){m},and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{1}))));
%         StdHR.Saf.(MouseGroup{gr})(m) = std(Data(Restrict(HR.(MouseGroup{gr}){m},and(Fz.(MouseGroup{gr}){m},or(Zn.(MouseGroup{gr}){m}{2},Zn.(MouseGroup{gr}){m}{5})))));
%         StdHR.Mov.(MouseGroup{gr})(m) = std(Data(Restrict(HR.(MouseGroup{gr}){m},or(Zn.(MouseGroup{gr}){m}{2},Zn.(MouseGroup{gr}){m}{1})-Fz.(MouseGroup{gr}){m})));
%         
    end
end
% m=2;
% ShockEpoch = and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{1});
% if ExtendedSafe
%     SafeEpoch = and(Fz.(MouseGroup{gr}){m},or(Zn.(MouseGroup{gr}){m}{2},Zn.(MouseGroup{gr}){m}{5}));
% else
%     SafeEpoch = and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{2});
% end
% Fzdur.Tot.(MouseGroup{gr})(m) = length(Data(Restrict(B.(MouseGroup{gr}){1},Fz.(MouseGroup{gr}){m})))./length(Data((B.(MouseGroup{gr}){1})));
% Fzdur.Shk.(MouseGroup{gr})(m) = length(Data(Restrict(B.(MouseGroup{gr}){1},ShockEpoch)))./length(Data((B.(MouseGroup{gr}){1})));;
% Fzdur.Saf.(MouseGroup{gr})(m) = length(Data(Restrict(B.(MouseGroup{gr}){1},SafeEpoch)))./length(Data((B.(MouseGroup{gr}){1})));

%%

if ReNorm
    for gr = 1:size(MouseGroup,2)
        for m = 1:length(B.(MouseGroup{gr}))
            if ReNormTogether
                valfordiv = nanmean([sum(MeanOB.Shk.(MouseGroup{gr})(m,10:end));sum(MeanOB.Saf.(MouseGroup{gr})(m,10:end))]);
                MeanOB.Shk.(MouseGroup{gr})(m,:) = MeanOB.Shk.(MouseGroup{gr})(m,:)./valfordiv;
                MeanOB.Saf.(MouseGroup{gr})(m,:) = MeanOB.Saf.(MouseGroup{gr})(m,:)./valfordiv;
                
                valfordiv = nanmean([sum(MeanP.Shk.(MouseGroup{gr})(m,10:end));sum(MeanP.Saf.(MouseGroup{gr})(m,10:end))]);
                MeanP.Shk.(MouseGroup{gr})(m,:) = (MeanP.Shk.(MouseGroup{gr})(m,:))./valfordiv;
                MeanP.Saf.(MouseGroup{gr})(m,:) = (MeanP.Saf.(MouseGroup{gr})(m,:))./valfordiv;
                
            else
                MeanOB.Shk.(MouseGroup{gr})(m,:) = MeanOB.Shk.(MouseGroup{gr})(m,:)./sum(MeanOB.Shk.(MouseGroup{gr})(m,10:end));
                MeanOB.Saf.(MouseGroup{gr})(m,:) = MeanOB.Saf.(MouseGroup{gr})(m,:)./sum(MeanOB.Saf.(MouseGroup{gr})(m,10:end));
                MeanP.Shk.(MouseGroup{gr})(m,:) = (MeanP.Shk.(MouseGroup{gr})(m,:))./sum(MeanP.Shk.(MouseGroup{gr})(m,10:end));
                MeanP.Saf.(MouseGroup{gr})(m,:) = (MeanP.Saf.(MouseGroup{gr})(m,:))./sum(MeanP.Shk.(MouseGroup{gr})(m,10:end));
                
            end
        end
    end
end

% the last saline mouse has bad heart rate data
MeanHR.Shk.(MouseGroup{1})(end) = NaN;
StdHR.Shk.(MouseGroup{1})(end) = NaN;
StdHR.Saf.(MouseGroup{1})(end) = NaN;
StdHR.Saf.(MouseGroup{1})(end) = NaN;
MeanHR.Mov.(MouseGroup{1})(end) = NaN;
StdHR.Mov.(MouseGroup{1})(end) = NaN;

% OB spectra figure
figure
for gr = 1 : size(MouseGroup,2)-1
    
    
    if length(Mice.(MouseGroup{gr+1}))==1 %nanmean(MeanOB.Shk.(MouseGroup{gr+1})) will give only one number (mean over the hole frequencies for 1 mouse) and you can't do the stdError with only one mouse
        
        subplot(2,size(MouseGroup,2)-1,size(MouseGroup,2)+gr-1)
        hold on
        st = zeros(1,261);
        g = shadedErrorBar(fLow,nanmean(MeanOB.Shk.Sal),stdError(MeanOB.Shk.Sal));
        set(g.patch,'FaceColor',[1 0.6 1],'FaceAlpha',0.5)
        set(g.mainLine,'Color',[1 0.6 1],'linewidth',2)
        %Cols{1}(2,:)
        g = shadedErrorBar(fLow,(MeanOB.Shk.(MouseGroup{gr+1})),st);
        set(g.patch,'FaceColor',[0.8 0 0],'FaceAlpha',0.3)
        set(g.mainLine,'Color',[0.8 0 0],'linewidth',2)
        %Cols{1}(1,:)
        
        subplot(2,size(MouseGroup,2)-1,gr)
        hold on
        g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.Sal),stdError(MeanOB.Saf.Sal));
        set(g.patch,'FaceColor',[0.4 0.7 1],'FaceAlpha',0.5)
        set(g.mainLine,'Color',[0.4 0.7 1],'linewidth',2)
        %Cols{2}(2,:)
        g = shadedErrorBar(fLow,(MeanOB.Saf.(MouseGroup{gr+1})),st);
        set(g.patch,'FaceColor',[0 0 0.9],'FaceAlpha',0.3)
        set(g.mainLine,'Color',[0 0 0.9],'linewidth',2)
        %Cols{2}(1,:)
    else
        subplot(2,size(MouseGroup,2)-1,size(MouseGroup,2)+gr-1)
        hold on
        g = shadedErrorBar(fLow,nanmean(MeanOB.Shk.Sal),stdError(MeanOB.Shk.Sal));
        set(g.patch,'FaceColor',[1 0.6 1],'FaceAlpha',0.5)
        set(g.mainLine,'Color',[1 0.6 1],'linewidth',2)
        g = shadedErrorBar(fLow,nanmean(MeanOB.Shk.(MouseGroup{gr+1})),stdError(MeanOB.Shk.(MouseGroup{gr+1})));
        set(g.patch,'FaceColor',[0.8 0 0],'FaceAlpha',0.3)
        set(g.mainLine,'Color',[0.8 0 0],'linewidth',2)
        
        subplot(2,size(MouseGroup,2)-1,gr)
        hold on
        g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.Sal),stdError(MeanOB.Saf.Sal));
        set(g.patch,'FaceColor',[0.4 0.7 1],'FaceAlpha',0.5)
        set(g.mainLine,'Color',[0.4 0.7 1],'linewidth',2)
        g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.(MouseGroup{gr+1})),stdError(MeanOB.Saf.(MouseGroup{gr+1})));
        set(g.patch,'FaceColor',[0 0 0.9],'FaceAlpha',0.3)
        set(g.mainLine,'Color',[0 0 0.9],'linewidth',2)
        hold on
    end
    %         ylim([0 0.03])
    xlim([0 12])
    
    legend('Shk Sal',['Shk ' MouseGroup{gr+1}],'Safe Sal',['Safe ' MouseGroup{gr+1}])
    ylabel('Power')
    xlabel('Frequency(Hz)')
    title('OB spectra')
    
end

%ob quantif
figure
freqLims = [3:4];
for gr = 1:4
    for m = 1:length(B.(MouseGroup{gr}))
        
        SafePow{gr} = nanmean(MeanOB.Saf.(MouseGroup{gr})(:,find(fLow>freqLims(1),1,'first'):find(fLow>freqLims(2),1,'first')),2);
        
        ShockPow{gr} = nanmean(MeanOB.Saf.(MouseGroup{gr})(:,find(fLow>freqLims(1),1,'first'):find(fLow>freqLims(2),1,'first')),2);
    end
end

clf
Cols2 = {[0.8 0.8 0.8];[0.6 0.6 0.6];[0.6 0.6 0.6];[0.6 0.6 0.6]} ;
MakeSpreadAndBoxPlot_SB(SafePow(1:4),Cols2,[1,2,3,4])
clear  p
[p(1),h,stats] = ranksum(SafePow{1},SafePow{2});
[p(2),h,stats] = ranksum(SafePow{1},SafePow{3});
sigstar_DB({[1,2],[1,3]},p)


%freezing quantif freezing
figure
A = {Fzdur.Tot.Sal;Fzdur.Tot.Mdz;Fzdur.Tot.Flx;Fzdur.Tot.FlxChr};
A = {Fzdur.Shk.Sal;Fzdur.Shk.Mdz;Fzdur.Shk.Flx;Fzdur.Shk.FlxChr};
Cols2 = {UMazeColors((MouseGroup{1})),UMazeColors((MouseGroup{2})),UMazeColors((MouseGroup{3})),UMazeColors((MouseGroup{4}))};
 MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,3,4])


figure
for gr = 1:size(MouseGroup,2)
bar(-1,1,'Facecolor',UMazeColors((MouseGroup{gr}))), hold on
end
for gr = 1:size(MouseGroup,2)
    % Movement
bar(gr,nanmean(MeanHR.Mov.(MouseGroup{gr})),'Facecolor',UMazeColors((MouseGroup{gr}))), hold on
plot(gr,MeanHR.Mov.(MouseGroup{gr}),'.k','MarkerSize',10)

    % Shock 
bar(gr+size(MouseGroup,2)+1,nanmean(MeanHR.Shk.(MouseGroup{gr})),'Facecolor',UMazeColors((MouseGroup{gr}))), hold on
plot(gr+size(MouseGroup,2)+1,MeanHR.Shk.(MouseGroup{gr}),'.k','MarkerSize',10)

    % Safe 
bar(gr+size(MouseGroup,2)*2+2,nanmean(MeanHR.Saf.(MouseGroup{gr})),'Facecolor',UMazeColors((MouseGroup{gr}))), hold on
plot(gr+size(MouseGroup,2)*2+2,MeanHR.Saf.(MouseGroup{gr}),'.k','MarkerSize',10)

end
xlim([0 size(MouseGroup,2)*4-1])
legend(MouseGroup)
set(gca,'XTick',[ceil(size(MouseGroup,2)*0.5) ceil(size(MouseGroup,2)*1.5) ceil(size(MouseGroup,2)*3)],'XTickLabel',{'Mov','Shock','Safe'})
ylim([6 13])
ylabel('Heart rate (Hz)')
title('Heart rate')
box off


%% 

figure
for gr = 1:size(MouseGroup,2)
bar(-1,1,'Facecolor',UMazeColors((MouseGroup{gr}))), hold on
end

for gr = 1:size(MouseGroup,2)
    % Movement
bar(gr,nanmean(StdHR.Mov.(MouseGroup{gr})),'Facecolor',UMazeColors((MouseGroup{gr}))), hold on
plot(gr,StdHR.Mov.(MouseGroup{gr}),'.k','MarkerSize',10)

    % Shock 
bar(gr+size(MouseGroup,2)+1,nanmean(StdHR.Shk.(MouseGroup{gr})),'Facecolor',UMazeColors((MouseGroup{gr}))), hold on
plot(gr+size(MouseGroup,2)+1,StdHR.Shk.(MouseGroup{gr}),'.k','MarkerSize',10)

    % Safe 
bar(gr+size(MouseGroup,2)*2+2,nanmean(StdHR.Saf.(MouseGroup{gr})),'Facecolor',UMazeColors((MouseGroup{gr}))), hold on
plot(gr+size(MouseGroup,2)*2+2,StdHR.Saf.(MouseGroup{gr}),'.k','MarkerSize',10)

end
xlim([0 size(MouseGroup,2)*4-1])
legend(MouseGroup)
set(gca,'XTick',[ceil(size(MouseGroup,2)*0.5) ceil(size(MouseGroup,2)*1.5) ceil(size(MouseGroup,2)*3)],'XTickLabel',{'Mov','Shock','Safe'})
ylabel('Heart rate Var')
title('Heart rate var')
box off

figure
for gr = 1:size(MouseGroup,2)

    plot(MeanHR.Saf.(MouseGroup{gr}),StdHR.Saf.(MouseGroup{gr}),'.','color',UMazeColors((MouseGroup{gr})),'MarkerSize',30)
    hold on
        plot(MeanHR.Shk.(MouseGroup{gr}),StdHR.Shk.(MouseGroup{gr}),'*','color',UMazeColors((MouseGroup{gr})),'MarkerSize',20)
        plot(MeanHR.Mov.(MouseGroup{gr}),StdHR.Mov.(MouseGroup{gr}),'^','color',UMazeColors((MouseGroup{gr})),'MarkerSize',20)

end
    plot(MeanHR.Saf.(MouseGroup{gr})(3:4),StdHR.Saf.(MouseGroup{gr})(3:4),'.','color','b','MarkerSize',30)
    hold on
        plot(MeanHR.Shk.(MouseGroup{gr})(3:4),StdHR.Shk.(MouseGroup{gr})(3:4),'*','color','b','MarkerSize',20)

        
for gr = 1:size(MouseGroup,2)-1

    plot(MeanHR.Saf.(MouseGroup{gr}),NumRipples.Saf.(MouseGroup{gr}),'.','color',UMazeColors((MouseGroup{gr})),'MarkerSize',30)
    hold on
        plot(MeanHR.Shk.(MouseGroup{gr}),NumRipples.Shk.(MouseGroup{gr}),'*','color',UMazeColors((MouseGroup{gr})),'MarkerSize',20)

end
    plot(MeanHR.Saf.(MouseGroup{gr})(3:4),NumRipples.Saf.(MouseGroup{gr})(3:4),'.','color','b','MarkerSize',30)
    hold on
        plot(MeanHR.Shk.(MouseGroup{gr})(3:4),NumRipples.Shk.(MouseGroup{gr})(3:4),'*','color','b','MarkerSize',20)

%%

figure
for gr = 1:size(MouseGroup,2)-1
    
    bar((gr-1)*2.5+1,nanmean(NumRipples.Shk.(MouseGroup{gr})),'Facecolor',UMazeColors('shock')), hold on
plot((gr-1)*2.5+1,NumRipples.Shk.(MouseGroup{gr}),'.k','MarkerSize',10)
bar((gr-1)*2.5+2,nanmean(NumRipples.Saf.(MouseGroup{gr})),'Facecolor',UMazeColors('safe')), hold on
plot((gr-1)*2.5+2,NumRipples.Saf.(MouseGroup{gr}),'.k','MarkerSize',10)
line([NumRipples.Shk.(MouseGroup{gr})*0+(gr-1)*2.5+1,NumRipples.Saf.(MouseGroup{gr})*0+(gr-1)*2.5+2]',[NumRipples.Shk.(MouseGroup{gr}),NumRipples.Saf.(MouseGroup{gr})]','color','k')
end

xlim([0 size(MouseGroup,2)*3-1])
set(gca,'XTick',[1.5:2.5:(gr-1)*2.5+2],'XTickLabel',MouseGroup),xtickangle(45)
ylabel('Ripple /sec')
title('Ripples')
box off





