clear all
MouseGroup = {'Sal','Mdz','Flx','FlxChr'};
% Mice.Sal = [688,739,777,779,849,893];
% Mice.Flx = [740,750,778,775,794];
% Mice.Mdz = [829,851,856,857,858,859];
% Mice.FlxChr = [876];

Mice.Sal = [688,739,777,779,849,893];
Mice.Flx = [740,750,778,775,794];
Mice.Mdz = [829,851,856,857,858,859, 1005, 1006];
Mice.FlxChr = [875,876,877,1001, 1002];


cd /media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_ExtinctionBlockedSafe_PostDrug/Ext1
load('B_Low_Spectrum.mat')
fLow = Spectro{3};
load('H_VHigh_Spectrum.mat')
fHigh = Spectro{3};


%% Make the figures
sesstype = 1;
blocked=0;
ExtendedSafe =1; % set to one take into account the safe zone and the central safe zone,
ReNorm=1;
ReNormTogether=1;

load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_B_Corr.mat'])
load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_Rip_Corr.mat'])
load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_Fz_Corr.mat'])
load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_Zn_Corr.mat'])
load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_HR_Corr.mat'])
load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_P_Corr.mat'])
load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_BlkEpoch_Corr.mat'])


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
    
    
    StdHR.Shk.(MouseGroup{mg}) = [];
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
        
        
        MeanP.Shk.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(P.(MouseGroup{gr}){m},ShockEpoch)));
        MeanP.Saf.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(P.(MouseGroup{gr}){m},SafeEpoch)));
        AllP.Shk.(MouseGroup{gr}) = [AllP.Shk.(MouseGroup{gr});Data(Restrict(P.(MouseGroup{gr}){m},ShockEpoch))./valfordiv];
        AllP.Saf.(MouseGroup{gr}) = [AllP.Saf.(MouseGroup{gr});Data(Restrict(P.(MouseGroup{gr}){m},SafeEpoch))./valfordiv];
        
        
        
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


% OB spectra figure
figure
for gr = 1 : size(MouseGroup,2)-1
    
    
    
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

%         ylim([0 0.03])
xlim([0 12])

legend('Shk Sal',['Shk ' MouseGroup{gr+1}],'Safe Sal',['Safe ' MouseGroup{gr+1}])
ylabel('Power')
xlabel('Frequency(Hz)')
title('OB spectra')
    
end

figure
for gr = 1 : size(MouseGroup,2)
 
subplot(4,1,gr)
plot(fLow,MeanOB.Shk.(MouseGroup{gr})','k')
grid on
makepretty
set(gca,'XTick',[0:2:10])
title(MouseGroup{gr})
ylim([0 0.03])
xlim([0 12])
end
