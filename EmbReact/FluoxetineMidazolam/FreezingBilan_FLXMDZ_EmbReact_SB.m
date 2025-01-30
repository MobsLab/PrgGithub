clear all
MouseGroup = {'Sal','Mdz','Flx','FlxChr'};
Mice.Sal = [688,739,777,779,849,893];
Mice.Flx = [740,750,778,775,794];
Mice.Mdz = [829,851,856,857,858,859, 1005, 1006];
Mice.FlxChr = [875,876,877, 1001, 1002];

cd /media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_ExtinctionBlockedSafe_PostDrug/Ext1
load('B_Low_Spectrum.mat')
fLow = Spectro{3};
load('H_VHigh_Spectrum.mat')
fHigh = Spectro{3};
Cols{1} = [[1 0.6 0.6]*0.5;[1 0.6 0.6]] ;
Cols{2} = [[0.6 0.6 1]*0.5;[0.6 0.6 1]] ;
%%
SessNames_Combi{1}={'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug' 'TestPost_PostDrug' 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };

SessNames_Combi{2}={'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

SessNames_Combi{3}={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'};

SessNames_Combi{4}={'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' 'UMazeCondExplo_PreDrug'};

SessNum_Combi{1} = [2,2,2,4,2,2];
SessNum_Combi{2} = [2,2];
SessNum_Combi{3} = [2,2];
SessNum_Combi{4} = [2,2,2];
SessNum_Combi{5} = [2,2,2];

ReNorm = 1; % should the spectra be renormalized to total power

%%
% sesstype = 1
for sesstype = [1,3]
    SessNames = SessNames_Combi{sesstype};
    SessNum = SessNum_Combi{sesstype};
    
    for mg = 1:length(MouseGroup)
        Files.(MouseGroup{mg}) = cell(1,length(Mice.(MouseGroup{mg})));
    end
    
    for sess = 1 : length(SessNames)
        Dir=PathForExperimentsEmbReact(SessNames{sess});
        for d = 1:length(Dir.path)
            
            for mg = 1:length(MouseGroup)
                
                if sum(ismember(Mice.(MouseGroup{mg}),Dir.ExpeInfo{d}{1}.nmouse))
                    
                    for p = 1:length(Dir.path{d})
                        Files.(MouseGroup{mg}){find(ismember(Mice.(MouseGroup{mg}),Dir.ExpeInfo{d}{1}.nmouse))}{end+1} = Dir.path{d}{p};
                    end
                end
            end
        end
    end
    
    for mg = 1:length(MouseGroup)
        
        disp(['getting ' MouseGroup{mg} ' files'])
        for mm = 1:size(Files.(MouseGroup{mg}),2)
            mm
             B.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'spectrum','prefix','B_Low');
            H.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'spectrum','prefix','H_Low');
            P.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'spectrum','prefix','PFCx_Low');
            Pos.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'LinearPosition');
            Fz.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','freezeepoch');
            Blk.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','blockedepoch');
            Zn.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','zoneepoch');
            HR.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'heartrate');
            Rip.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'ripples');
%             BInstP.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'instfreq','suffix_instfreq','B','method','PT');
%             BInstW.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'instfreq','suffix_instfreq','B','method','WV');
%             BWV.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'wavelet_spec','prefix','B');
%             HWV.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'wavelet_spec','prefix','H');
%             PWV.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'wavelet_spec','prefix','PFCx');
        end
    end
         save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_BlkEpoch_Corr.mat'],'Blk','-v7.3')
         save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_Pos_Corr.mat'],'Pos','-v7.3')

    save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_B_Corr.mat'],'B','-v7.3')
    save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_H_Corr.mat'],'H','-v7.3')
    save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_P_Corr.mat'],'P','-v7.3')
    save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_Fz_Corr.mat'],'Fz','-v7.3')
    save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_Zn_Corr.mat'],'Zn','-v7.3')
    save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_HR_Corr.mat'],'HR','-v7.3')
    save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_Rip_Corr.mat'],'Rip','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_BInstP_Corr.mat'],'BInstP','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_BInstW_Corr.mat'],'BInstW','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_BWV.mat'],'BWV','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_HWV.mat'],'HWV','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZV2',num2str(sesstype),'_PWV.mat'],'PWV','-v7.3')
    clear B H P Fz Zn HR Rip BInstP BInstW BWC HWV PWV
    
end


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

    NumRipples.Shk.(MouseGroup{mg}) = [];
    NumRipples.Saf.(MouseGroup{mg}) = [];
    
    MeanHR.Shk.(MouseGroup{mg}) = [];
    MeanHR.Saf.(MouseGroup{mg}) = [];
    
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
        
        MeanOB.Shk.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(B.(MouseGroup{gr}){m},ShockEpoch)));
        MeanOB.Saf.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(B.(MouseGroup{gr}){m},SafeEpoch)));
        
        valfordiv = nanmean([sum(MeanOB.Shk.(MouseGroup{gr})(m,10:end));sum(MeanOB.Saf.(MouseGroup{gr})(m,10:end))]);
        if gr ==3 & m==3
        else

        AllOB.Shk.(MouseGroup{gr}) = [AllOB.Shk.(MouseGroup{gr});Data(Restrict(B.(MouseGroup{gr}){m},ShockEpoch))./valfordiv];
        AllOB.Saf.(MouseGroup{gr}) = [AllOB.Saf.(MouseGroup{gr});Data(Restrict(B.(MouseGroup{gr}){m},SafeEpoch))./valfordiv];
        end
        MeanP.Shk.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(P.(MouseGroup{gr}){m},ShockEpoch)));
        MeanP.Saf.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(P.(MouseGroup{gr}){m},SafeEpoch)));

        
        if not(isempty(Range(Rip.(MouseGroup{gr}){m})))
        NumRipples.Shk.(MouseGroup{gr})(m,:) = length(Range(Restrict(Rip.(MouseGroup{gr}){m},ShockEpoch)))./nansum(Stop(ShockEpoch,'s')-Start(ShockEpoch,'s'));
        NumRipples.Saf.(MouseGroup{gr})(m,:) = length(Range(Restrict(Rip.(MouseGroup{gr}){m},SafeEpoch)))./nansum(Stop(SafeEpoch,'s')-Start(SafeEpoch,'s'));
        else
          NumRipples.Shk.(MouseGroup{gr})(m,:)  = NaN;
          NumRipples.Saf.(MouseGroup{gr})(m,:)  = NaN;
        end
                
        MeanHR.Shk.(MouseGroup{gr})(m) = nanmean(Data(Restrict(HR.(MouseGroup{gr}){m},and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{1}))));
        MeanHR.Saf.(MouseGroup{gr})(m) = nanmean(Data(Restrict(HR.(MouseGroup{gr}){m},and(Fz.(MouseGroup{gr}){m},or(Zn.(MouseGroup{gr}){m}{2},Zn.(MouseGroup{gr}){m}{5})))));
        MeanHR.Mov.(MouseGroup{gr})(m) = nanmean(Data(Restrict(HR.(MouseGroup{gr}){m},or(Zn.(MouseGroup{gr}){m}{2},Zn.(MouseGroup{gr}){m}{1})-Fz.(MouseGroup{gr}){m})));
        
        StdHR.Shk.(MouseGroup{gr})(m) = std(Data(Restrict(HR.(MouseGroup{gr}){m},and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{1}))));
        StdHR.Saf.(MouseGroup{gr})(m) = std(Data(Restrict(HR.(MouseGroup{gr}){m},and(Fz.(MouseGroup{gr}){m},or(Zn.(MouseGroup{gr}){m}{2},Zn.(MouseGroup{gr}){m}{5})))));
        StdHR.Mov.(MouseGroup{gr})(m) = std(Data(Restrict(HR.(MouseGroup{gr}){m},or(Zn.(MouseGroup{gr}){m}{2},Zn.(MouseGroup{gr}){m}{1})-Fz.(MouseGroup{gr}){m})));
        
    end
end

%%

if ReNorm
    for gr = 1:size(MouseGroup,2)
        for m = 1:length(B.(MouseGroup{gr}))
            if ReNormTogether
                %             MeanOB.Shk.(MouseGroup{gr})(m,:) = MeanOB.Shk.(MouseGroup{gr})(m,:)./(sum(MeanOB.Shk.(MouseGroup{gr})(m,1:end))+sum(MeanOB.Saf.(MouseGroup{gr})(m,1:end)))/2;
                %             MeanOB.Saf.(MouseGroup{gr})(m,:) = MeanOB.Saf.(MouseGroup{gr})(m,:)./(sum(MeanOB.Shk.(MouseGroup{gr})(m,1:end))+sum(MeanOB.Saf.(MouseGroup{gr})(m,1:end)))/2;
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
%%
figure
for gr = 1 : size(MouseGroup,2)-1
subplot(2,size(MouseGroup,2)-1,[gr,size(MouseGroup,2)+gr-1])
% line([-1 0],[-1 0],'color',Cols{1}(2,:),'linewidth',4), hold on
% line([-1 0],[-1 0]    g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.Sal),stdError(MeanOB.Saf.Sal));
% line([-1 0],[-1 0],'color',Cols{2}(2,:),'linewidth',4)
% line([-1 0],[-1 0],'color',Cols{2}(1,:),'linewidth',4)

line([-1 0],[-1 0],'color',[1 0.6 1],'linewidth',4), hold on
line([-1 0],[-1 0],'color',[0.8 0 0],'linewidth',4)
line([-1 0],[-1 0],'color',[0.4 0.7 1],'linewidth',4)
line([-1 0],[-1 0],'color',[0 0 0.9],'linewidth',4)

if length(Mice.(MouseGroup{gr+1}))==1 %nanmean(MeanOB.Shk.(MouseGroup{gr+1})) will give only one number (mean over the hole frequencies for 1 mouse) and you can't do the stdError with only one mouse
    st = zeros(1,261);
    g = shadedErrorBar(fLow,nanmean(MeanOB.Shk.Sal),stdError(MeanOB.Shk.Sal));
    set(g.patch,'FaceColor',[1 0.6 1],'FaceAlpha',0.5)
    set(g.mainLine,'Color',[1 0.6 1],'linewidth',2)
    %Cols{1}(2,:)
    g = shadedErrorBar(fLow,(MeanOB.Shk.(MouseGroup{gr+1})),st);
    set(g.patch,'FaceColor',[0.8 0 0],'FaceAlpha',0.3)
    set(g.mainLine,'Color',[0.8 0 0],'linewidth',2)
    %Cols{1}(1,:)
    g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.Sal),stdError(MeanOB.Saf.Sal));
    set(g.patch,'FaceColor',[0.4 0.7 1],'FaceAlpha',0.5)
    set(g.mainLine,'Color',[0.4 0.7 1],'linewidth',2)
    %Cols{2}(2,:)
    g = shadedErrorBar(fLow,(MeanOB.Saf.(MouseGroup{gr+1})),st);
    set(g.patch,'FaceColor',[0 0 0.9],'FaceAlpha',0.3)
    set(g.mainLine,'Color',[0 0 0.9],'linewidth',2)
    %Cols{2}(1,:)
else
    g = shadedErrorBar(fLow,nanmean(MeanOB.Shk.Sal),stdError(MeanOB.Shk.Sal));
    set(g.patch,'FaceColor',[1 0.6 1],'FaceAlpha',0.5)
    set(g.mainLine,'Color',[1 0.6 1],'linewidth',2)
    g = shadedErrorBar(fLow,nanmean(MeanOB.Shk.(MouseGroup{gr+1})),stdError(MeanOB.Shk.(MouseGroup{gr+1})));
    set(g.patch,'FaceColor',[0.8 0 0],'FaceAlpha',0.3)
    set(g.mainLine,'Color',[0.8 0 0],'linewidth',2)

    g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.Sal),stdError(MeanOB.Saf.Sal));
    set(g.patch,'FaceColor',[0.4 0.7 1],'FaceAlpha',0.5)
    set(g.mainLine,'Color',[0.4 0.7 1],'linewidth',2)
    g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.(MouseGroup{gr+1})),stdError(MeanOB.Saf.(MouseGroup{gr+1})));
    set(g.patch,'FaceColor',[0 0 0.9],'FaceAlpha',0.3)
    set(g.mainLine,'Color',[0 0 0.9],'linewidth',2)
end
ylim([0 0.03])
xlim([0 12])

legend('Shk Sal',['Shk ' MouseGroup{gr+1}],'Safe Sal',['Safe ' MouseGroup{gr+1}])
ylabel('Power')
xlabel('Frequency(Hz)')
title('OB spectra')

end
	annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with FreezingBilan_FLXMDZ_EmbReact_SB.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')
    
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
    
    
     figure
    for gr = 1 : size(MouseGroup,2)-1
        
        
        if length(Mice.(MouseGroup{gr+1}))==1 %nanmean(MeanOB.Shk.(MouseGroup{gr+1})) will give only one number (mean over the hole frequencies for 1 mouse) and you can't do the stdError with only one mouse
            
            subplot(2,size(MouseGroup,2)-1,size(MouseGroup,2)+gr-1)
            hold on
            st = zeros(1,261);
            g = shadedErrorBar(fLow,nanmean(MeanP.Shk.Sal),stdError(MeanOB.Shk.Sal));
            set(g.patch,'FaceColor',[1 0.6 1],'FaceAlpha',0.5)
            set(g.mainLine,'Color',[1 0.6 1],'linewidth',2)
            %Cols{1}(2,:)
            g = shadedErrorBar(fLow,(MeanP.Shk.(MouseGroup{gr+1})),st);
            set(g.patch,'FaceColor',[0.8 0 0],'FaceAlpha',0.3)
            set(g.mainLine,'Color',[0.8 0 0],'linewidth',2)
            %Cols{1}(1,:)
            
            subplot(2,size(MouseGroup,2)-1,gr)
            hold on
            g = shadedErrorBar(fLow,nanmean(MeanP.Saf.Sal),stdError(MeanOB.Saf.Sal));
            set(g.patch,'FaceColor',[0.4 0.7 1],'FaceAlpha',0.5)
            set(g.mainLine,'Color',[0.4 0.7 1],'linewidth',2)
            %Cols{2}(2,:)
            g = shadedErrorBar(fLow,(MeanP.Saf.(MouseGroup{gr+1})),st);
            set(g.patch,'FaceColor',[0 0 0.9],'FaceAlpha',0.3)
            set(g.mainLine,'Color',[0 0 0.9],'linewidth',2)
            %Cols{2}(1,:)
        else
            subplot(2,size(MouseGroup,2)-1,size(MouseGroup,2)+gr-1)
            hold on
            g = shadedErrorBar(fLow,nanmean(MeanP.Shk.Sal),stdError(MeanOB.Shk.Sal));
            set(g.patch,'FaceColor',[1 0.6 1],'FaceAlpha',0.5)
            set(g.mainLine,'Color',[1 0.6 1],'linewidth',2)
            g = shadedErrorBar(fLow,nanmean(MeanP.Shk.(MouseGroup{gr+1})),stdError(MeanOB.Shk.(MouseGroup{gr+1})));
            set(g.patch,'FaceColor',[0.8 0 0],'FaceAlpha',0.3)
            set(g.mainLine,'Color',[0.8 0 0],'linewidth',2)

            subplot(2,size(MouseGroup,2)-1,gr)
            hold on
            g = shadedErrorBar(fLow,nanmean(MeanP.Saf.Sal),stdError(MeanOB.Saf.Sal));
            set(g.patch,'FaceColor',[0.4 0.7 1],'FaceAlpha',0.5)
            set(g.mainLine,'Color',[0.4 0.7 1],'linewidth',2)
            g = shadedErrorBar(fLow,nanmean(MeanP.Saf.(MouseGroup{gr+1})),stdError(MeanOB.Saf.(MouseGroup{gr+1})));
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
    
figure
plot(fLow,(MeanOB.Saf.(MouseGroup{1})),'b')
hold on
plot(fLow,(MeanOB.Saf.(MouseGroup{2})),'r')
PowerRatioSal = nanmean(MeanOB.Saf.(MouseGroup{1})(:,find(fLow<1,1,'last'):find(fLow<2,1,'last'))');
PowerRatioSal2 = nanmean(MeanOB.Saf.(MouseGroup{1})(:,find(fLow<2,1,'last'):find(fLow<3,1,'last'))');

PowerRatioMdz = nanmean(MeanOB.Saf.(MouseGroup{2})(:,find(fLow<1,1,'last'):find(fLow<2,1,'last'))');
PowerRatioMdz2 = nanmean(MeanOB.Saf.(MouseGroup{2})(:,find(fLow<2,1,'last'):find(fLow<3,1,'last'))');

PowerRatioFlx = nanmean(MeanOB.Saf.(MouseGroup{3})(:,find(fLow<1,1,'last'):find(fLow<2,1,'last'))');
PowerRatioFlx2 = nanmean(MeanOB.Saf.(MouseGroup{3})(:,find(fLow<2,1,'last'):find(fLow<3,1,'last'))');

subplot(121)
PlotErrorBarN_KJ({PowerRatioSal./PowerRatioSal2,PowerRatioMdz./PowerRatioMdz2,PowerRatioFlx./PowerRatioFlx2},'newfig',0,'paired',0,'showPoints',1)

PowerRatioSal = nanmax(MeanOB.Saf.(MouseGroup{1})(:,find(fLow<1,1,'last'):find(fLow<2,1,'last'))');
PowerRatioSal2 = nanmax(MeanOB.Saf.(MouseGroup{1})(:,find(fLow<2,1,'last'):find(fLow<4,1,'last'))');
figure

PowerRatioMdz = nanmax(MeanOB.Saf.(MouseGroup{2})(:,find(fLow<1,1,'last'):find(fLow<2,1,'last'))');
PowerRatioMdz2 = nanmax(MeanOB.Saf.(MouseGroup{2})(:,find(fLow<2,1,'last'):find(fLow<4,1,'last'))');

PowerRatioFlx = nanmax(MeanOB.Saf.(MouseGroup{3})(:,find(fLow<1,1,'last'):find(fLow<2,1,'last'))');
PowerRatioFlx2 = nanmax(MeanOB.Saf.(MouseGroup{3})(:,find(fLow<2,1,'last'):find(fLow<4,1,'last'))');

subplot(122)
PlotErrorBarN_KJ({PowerRatioSal./PowerRatioSal2,PowerRatioMdz./PowerRatioMdz2,PowerRatioFlx./PowerRatioFlx2},'newfig',0,'paired',0,'showPoints',1)


    figure
    for gr = 1 : size(MouseGroup,2)
        subplot(2,size(MouseGroup,2),gr)
        imagesc(1:size(AllOB.Saf.(MouseGroup{gr}),1),fLow,log(AllOB.Shk.(MouseGroup{gr}))')
        axis xy
        ylim([0 15])
        line(xlim,[3 3],'color','k')
        subplot(2,size(MouseGroup,2),size(MouseGroup,2)+gr)
        imagesc(1:size(AllOB.Saf.(MouseGroup{gr}),1),fLow,log(AllOB.Saf.(MouseGroup{gr}))')
        axis xy
        ylim([0 15])
        line(xlim,[3 3],'color','k')
    end
    
    figure
    for gr = 1 : size(MouseGroup,2)
        subplot(2,1,1)
        plot(fLow,nanmean(AllOB.Shk.(MouseGroup{gr}))')
        hold on
        %         axis xy
        %         ylim([0 15])
        %         line(xlim,[3 3],'color','k')
        subplot(2,1,2)
        plot(fLow,nanmean(AllOB.Saf.(MouseGroup{gr}))'/max(nanmean(AllOB.Saf.(MouseGroup{gr}))))
        hold on
        %         axis xy
        %         ylim([0 15])
        %         line(xlim,[3 3],'color','k')
    end

    
    
%%
subplot(3,3,7)
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

subplot(3,3,8)
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
%%
subplot(339)


for gr = 1:size(MouseGroup,2)
    
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

%%

    
%     saveas(1,['/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis/AnalysisSpet2018/BilanFreezing',num2str(sesstype),'.png'])
%     saveas(1,['/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis/AnalysisSpet2018/BilanFreezing',num2str(sesstype),'.fig'])

% end

figure
for gr = 1:2
    for m = 1:length(B.(MouseGroup{gr}))
        
        plot(fLow,MeanOB.Saf.(MouseGroup{gr})(m,:))
        [ind.Saf.(MouseGroup{gr})(m),~] = ginput(1);
        if ind.Saf.(MouseGroup{gr})(m)>10
            ind.Saf.(MouseGroup{gr})(m) = NaN;
        end
        
        plot(fLow,MeanOB.Shk.(MouseGroup{gr})(m,:))
        [ind.Shk.(MouseGroup{gr})(m),~] = ginput(1);
        if ind.Shk.(MouseGroup{gr})(m)>10
            ind.Shk.(MouseGroup{gr})(m) = NaN;
        end
    end
end
%%

figure
gr = 1
for m = 1:length(B.(MouseGroup{gr}))
subplot(6,2,2*(m-1)+1)
ShockEpoch = and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{1});
SafeEpoch = and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{2});
imagesc(1:length(Data(Restrict(B.(MouseGroup{gr}){m},SafeEpoch))),fLow,log(Data(Restrict(B.(MouseGroup{gr}){m},SafeEpoch)))'), axis xy
line(xlim,[3 3])
subplot(6,2,2*(m-1)+2)
imagesc(1:length(Data(Restrict(B.(MouseGroup{gr}){m},ShockEpoch))),fLow,log(Data(Restrict(B.(MouseGroup{gr}){m},ShockEpoch)))'), axis xy
line(xlim,[3 3])

end
%%
figure
for gr = 1:3
    
    for m = 1:length(B.(MouseGroup{gr}))
        subplot(3,6,m+6*(gr-1))
        ShockEpoch = and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{1});
        SafeEpoch = and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{2});
        nhist({Data(Restrict(BInstW.(MouseGroup{gr}){m},ShockEpoch)),Data(Restrict(BInstW.(MouseGroup{gr}){m},SafeEpoch))})
    end
    
end

%%

figure
for gr = 1:3
    
    for m = 1:length(B.(MouseGroup{gr}))
        subplot(3,6,m+6*(gr-1))
        ShockEpoch = and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{1});
        SafeEpoch = and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{2});
        nhist({Data(Restrict(Pos.(MouseGroup{gr}){m},ShockEpoch)),Data(Restrict(Pos.(MouseGroup{gr}){m},SafeEpoch))})
    end
    
end

        figure
freqLims = [2.5 3.5];
for gr = 1:4
    for m = 1:length(B.(MouseGroup{gr}))
        
        SafePow{gr} = nanmean(MeanOB.Saf.(MouseGroup{gr})(:,find(fLow>freqLims(1),1,'first'):find(fLow>freqLims(2),1,'first')),2);
        
        ShockPow{gr} = nanmean(MeanOB.Saf.(MouseGroup{gr})(:,find(fLow>freqLims(1),1,'first'):find(fLow>freqLims(2),1,'first')),2);
    end
end

clf
Cols2 = {[0.8 0.8 0.8];[0.6 0.6 0.6];[0.6 0.6 0.6]} ;
MakeSpreadAndBoxPlot_SB(SafePow(1:3),Cols2,[1,2,3])
clear  p
[p(1),h,stats] = ranksum(SafePow{1},SafePow{2});
[p(2),h,stats] = ranksum(SafePow{1},SafePow{3});
sigstar_DB({[1,2],[1,3]},p)


for gr = 1:4
    for m = 1:size(MeanOB.Saf.(MouseGroup{gr}),1)
        A = (MeanOB.Saf.(MouseGroup{gr})(m,:));
        A = A(10:80)/sum(A(10:80));
        CentMass.Saf{gr}(m) = mean(A*fLow(10:80)',2);
    end
end




anova2([MeanOB.Saf.(MouseGroup{1});MeanOB.Saf.(MouseGroup{2})],6)