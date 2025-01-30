clear all
MouseGroup = {'Sal','Mdz','Flx','FlxChr'};
Mice.Sal = [688,739,777,779,849,893];
Mice.Flx = [740,750,778,775,794];
Mice.Mdz = [829,851,856,857,858,859,1005,1006];
Mice.FlxChr = [876,875,877,1001,1002];

cd /media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_ExtinctionBlockedShock
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

SessNames_Combi{5}={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug' 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };

SessNum_Combi{1} = [2,2,2,4,4,4];
SessNum_Combi{2} = [2,2];
SessNum_Combi{3} = [2,2];
SessNum_Combi{4} = [2,2,2];
SessNum_Combi{5} = [2,2,4,4];

ReNorm = 1; % should the spectra be renormalized to total power
ReNormTogether = 0;
%%
for sesstype = 1:5
    sesstype
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
            Fz.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','freezeepoch');
            Zn.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','zoneepoch');
            
        end
    end
    
    
    for mg = 1:4
        
        MeanOB.Shk.(MouseGroup{mg}) = [];
        MeanOB.Saf.(MouseGroup{mg}) = [];
        
        AllOB.Shk.(MouseGroup{mg}) = [];
        AllOB.Saf.(MouseGroup{mg}) = [];
        
    end
    ExtendedSafe = 1;
    
    for gr = 1:length(MouseGroup)
        for m = 1:length(B.(MouseGroup{gr}))
            
            ShockEpoch = and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{1});
            if ExtendedSafe
                SafeEpoch = and(Fz.(MouseGroup{gr}){m},or(Zn.(MouseGroup{gr}){m}{2},Zn.(MouseGroup{gr}){m}{5}));
            else
                SafeEpoch = and(Fz.(MouseGroup{gr}){m},Zn.(MouseGroup{gr}){m}{2});
            end
            
            
            Fzdur.Tot.(MouseGroup{gr})(m) = length(Data(Restrict(B.(MouseGroup{gr}){m},Fz.(MouseGroup{gr}){m})))./length(Data((B.(MouseGroup{gr}){m})));
            Fzdur.Shk.(MouseGroup{gr})(m) = length(Data(Restrict(B.(MouseGroup{gr}){m},ShockEpoch)))./length(Data((B.(MouseGroup{gr}){m})));
            Fzdur.Saf.(MouseGroup{gr})(m) = length(Data(Restrict(B.(MouseGroup{gr}){m},SafeEpoch)))./length(Data((B.(MouseGroup{gr}){m})));
            
            
            MeanOB.Shk.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(B.(MouseGroup{gr}){m},ShockEpoch)));
            MeanOB.Saf.(MouseGroup{gr})(m,:) = nanmean(Data(Restrict(B.(MouseGroup{gr}){m},SafeEpoch)));
            
            valfordiv = nanmean([sum(MeanOB.Shk.(MouseGroup{gr})(m,10:end));sum(MeanOB.Saf.(MouseGroup{gr})(m,10:end))]);
            AllOB.Shk.(MouseGroup{gr}) = [AllOB.Shk.(MouseGroup{gr});Data(Restrict(B.(MouseGroup{gr}){m},ShockEpoch))./valfordiv];
            AllOB.Saf.(MouseGroup{gr}) = [AllOB.Saf.(MouseGroup{gr});Data(Restrict(B.(MouseGroup{gr}){m},SafeEpoch))./valfordiv];
            
            
            
        end
    end
    
    %%
    
    
    fig = figure;
    fig.Name = num2str(sesstype);
    
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
            title(MouseGroup{gr+1})
            
            subplot(2,size(MouseGroup,2)-1,gr)
            hold on
            g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.Sal),stdError(MeanOB.Saf.Sal));
            set(g.patch,'FaceColor',[0.4 0.7 1],'FaceAlpha',0.5)
            set(g.mainLine,'Color',[0.4 0.7 1],'linewidth',2)
            %Cols{2}(2,:)
            g = shadedErrorBar(fLow,(MeanOB.Saf.(MouseGroup{gr+1})),st);
            set(g.patch,'FaceColor',[0 0 0.9],'FaceAlpha',0.3)
            set(g.mainLine,'Color',[0 0 0.9],'linewidth',2)
            title(MouseGroup{gr+1})
            
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
            title(MouseGroup{gr+1})
            
            subplot(2,size(MouseGroup,2)-1,gr)
            hold on
            g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.Sal),stdError(MeanOB.Saf.Sal));
            set(g.patch,'FaceColor',[0.4 0.7 1],'FaceAlpha',0.5)
            set(g.mainLine,'Color',[0.4 0.7 1],'linewidth',2)
            g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.(MouseGroup{gr+1})),stdError(MeanOB.Saf.(MouseGroup{gr+1})));
            set(g.patch,'FaceColor',[0 0 0.9],'FaceAlpha',0.3)
            set(g.mainLine,'Color',[0 0 0.9],'linewidth',2)
            hold on
            title(MouseGroup{gr+1})
        end
        %         ylim([0 0.03])
        xlim([0 12])
        
        ylabel('Power')
        xlabel('Frequency(Hz)')
        
    end
    
    saveas(fig.Number,['/media/nas4/ProjetEmbReact/DrugEffectFigures/ResultsDec2019/FigBefRenorm',num2str(sesstype),'.fig'])
    saveas(fig.Number,['/media/nas4/ProjetEmbReact/DrugEffectFigures/ResultsDec2019/FigBefRenorm',num2str(sesstype),'.png'])
    
    
    fig = figure;
    fig.Name = num2str(sesstype);
    
    for gr = 1 : size(MouseGroup,2)-1
        
        
        subplot(2,size(MouseGroup,2)-1,size(MouseGroup,2)+gr-1)
        hold on
        g = shadedErrorBar(fLow,nanmean(MeanOB.Shk.(MouseGroup{gr+1})),stdError(MeanOB.Shk.(MouseGroup{gr+1})));
        set(g.patch,'FaceColor',[0.8 0 0],'FaceAlpha',0.3)
        set(g.mainLine,'Color',[0.8 0 0],'linewidth',2)
        title(MouseGroup{gr+1})
        line([4.12 4.12],ylim,'color','r','linewidth',3)
        title(MouseGroup{gr+1})
        xlim([0 12])
        ylabel('Power')
        xlabel('Frequency(Hz)')
        
        subplot(2,size(MouseGroup,2)-1,gr)
        hold on
        g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.(MouseGroup{gr+1})),stdError(MeanOB.Saf.(MouseGroup{gr+1})));
        set(g.patch,'FaceColor',[0 0 0.9],'FaceAlpha',0.3)
        set(g.mainLine,'Color',[0 0 0.9],'linewidth',2)
        hold on
        line([2.4 2.4],ylim,'color','b','linewidth',3)
        title(MouseGroup{gr+1})
        
        xlim([0 12])
        
        ylabel('Power')
        xlabel('Frequency(Hz)')
        
    end
    
    saveas(fig.Number,['/media/nas4/ProjetEmbReact/DrugEffectFigures/ResultsDec2019/Fig2BefRenorm',num2str(sesstype),'.fig'])
    saveas(fig.Number,['/media/nas4/ProjetEmbReact/DrugEffectFigures/ResultsDec2019/Fig2BefRenorm',num2str(sesstype),'.png'])
    
    if ReNorm
        for gr = 1:size(MouseGroup,2)
            for m = 1:length(B.(MouseGroup{gr}))
                if ReNormTogether
                    valfordiv = nanmax([sum(MeanOB.Shk.(MouseGroup{gr})(m,10:end));sum(MeanOB.Saf.(MouseGroup{gr})(m,10:80))]);
                    MeanOB.Shk.(MouseGroup{gr})(m,:) = MeanOB.Shk.(MouseGroup{gr})(m,:)./valfordiv;
                    MeanOB.Saf.(MouseGroup{gr})(m,:) = MeanOB.Saf.(MouseGroup{gr})(m,:)./valfordiv;
                    
                else
                    MeanOB.Shk.(MouseGroup{gr})(m,:) = MeanOB.Shk.(MouseGroup{gr})(m,:)./max(MeanOB.Shk.(MouseGroup{gr})(m,10:80));
                    MeanOB.Saf.(MouseGroup{gr})(m,:) = MeanOB.Saf.(MouseGroup{gr})(m,:)./max(MeanOB.Saf.(MouseGroup{gr})(m,10:80));
                    
                end
            end
        end
    end
    
    fig = figure;
    fig.Name = num2str(sesstype);
    
    for gr = 1 : size(MouseGroup,2)
        subplot(4,1,gr)
        plot(fLow,MeanOB.Shk.(MouseGroup{gr}),'r')
        hold on
        plot(fLow,MeanOB.Saf.(MouseGroup{gr}),'b')
        title(MouseGroup{gr})
        xlim([0 12])
        ylabel('Power')
        xlabel('Frequency(Hz)')
        ylim([0 1.5])
        box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
    end
    
    
    saveas(fig.Number,['/media/nas4/ProjetEmbReact/DrugEffectFigures/ResultsDec2019/Fig3AfterRenorm',num2str(sesstype),'.fig'])
    saveas(fig.Number,['/media/nas4/ProjetEmbReact/DrugEffectFigures/ResultsDec2019/Fig3AfterRenorm',num2str(sesstype),'.png'])
    
    
    fig = figure;
    fig.Name = num2str(sesstype);
    
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
            title(MouseGroup{gr+1})
            
            subplot(2,size(MouseGroup,2)-1,gr)
            hold on
            g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.Sal),stdError(MeanOB.Saf.Sal));
            set(g.patch,'FaceColor',[0.4 0.7 1],'FaceAlpha',0.5)
            set(g.mainLine,'Color',[0.4 0.7 1],'linewidth',2)
            %Cols{2}(2,:)
            g = shadedErrorBar(fLow,(MeanOB.Saf.(MouseGroup{gr+1})),st);
            set(g.patch,'FaceColor',[0 0 0.9],'FaceAlpha',0.3)
            set(g.mainLine,'Color',[0 0 0.9],'linewidth',2)
            title(MouseGroup{gr+1})
            
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
            title(MouseGroup{gr+1})
            
            subplot(2,size(MouseGroup,2)-1,gr)
            hold on
            g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.Sal),stdError(MeanOB.Saf.Sal));
            set(g.patch,'FaceColor',[0.4 0.7 1],'FaceAlpha',0.5)
            set(g.mainLine,'Color',[0.4 0.7 1],'linewidth',2)
            g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.(MouseGroup{gr+1})),stdError(MeanOB.Saf.(MouseGroup{gr+1})));
            set(g.patch,'FaceColor',[0 0 0.9],'FaceAlpha',0.3)
            set(g.mainLine,'Color',[0 0 0.9],'linewidth',2)
            hold on
            title(MouseGroup{gr+1})
        end
        %         ylim([0 0.03])
        xlim([0 12])
        
        ylabel('Power')
        xlabel('Frequency(Hz)')
        
    end
    saveas(fig.Number,['/media/nas4/ProjetEmbReact/DrugEffectFigures/ResultsDec2019/Fig4AfterRenorm',num2str(sesstype),'.fig'])
    saveas(fig.Number,['/media/nas4/ProjetEmbReact/DrugEffectFigures/ResultsDec2019/Fig4AfterRenorm',num2str(sesstype),'.png'])
    
    
    fig = figure;
    fig.Name = num2str(sesstype);
    
    for gr = 1 : size(MouseGroup,2)-1
        
        
        subplot(2,size(MouseGroup,2)-1,size(MouseGroup,2)+gr-1)
        hold on
        g = shadedErrorBar(fLow,nanmean(MeanOB.Shk.(MouseGroup{gr+1})),stdError(MeanOB.Shk.(MouseGroup{gr+1})));
        set(g.patch,'FaceColor',[0.8 0 0],'FaceAlpha',0.3)
        set(g.mainLine,'Color',[0.8 0 0],'linewidth',2)
        title(MouseGroup{gr+1})
        line([4.12 4.12],ylim,'color','r','linewidth',3)
        title(MouseGroup{gr+1})
        xlim([0 12])
        ylabel('Power')
        xlabel('Frequency(Hz)')
        
        subplot(2,size(MouseGroup,2)-1,gr)
        hold on
        g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.(MouseGroup{gr+1})),stdError(MeanOB.Saf.(MouseGroup{gr+1})));
        set(g.patch,'FaceColor',[0 0 0.9],'FaceAlpha',0.3)
        set(g.mainLine,'Color',[0 0 0.9],'linewidth',2)
        hold on
        line([2.4 2.4],ylim,'color','b','linewidth',3)
        title(MouseGroup{gr+1})
        
        %         ylim([0 0.03])
        xlim([0 12])
        
        ylabel('Power')
        xlabel('Frequency(Hz)')
        
    end
    saveas(fig.Number,['/media/nas4/ProjetEmbReact/DrugEffectFigures/ResultsDec2019/Fig5AfterRenorm',num2str(sesstype),'.fig'])
    saveas(fig.Number,['/media/nas4/ProjetEmbReact/DrugEffectFigures/ResultsDec2019/Fig5AfterRenorm',num2str(sesstype),'.png'])
    close all
end
%
% figure
% for gr = 1 : size(MouseGroup,2)-1
%
%
%     if length(Mice.(MouseGroup{gr+1}))==1 %nanmean(MeanOB.Shk.(MouseGroup{gr+1})) will give only one number (mean over the hole frequencies for 1 mouse) and you can't do the stdError with only one mouse
%
%         subplot(2,size(MouseGroup,2)-1,size(MouseGroup,2)+gr-1)
%         hold on
%         st = zeros(1,261);
%         g = shadedErrorBar(fLow,nanmean(MeanOB.Shk.Sal),stdError(MeanOB.Shk.Sal));
%         set(g.patch,'FaceColor',[1 0.6 1],'FaceAlpha',0.5)
%         set(g.mainLine,'Color',[1 0.6 1],'linewidth',2)
%         %Cols{1}(2,:)
%         g = shadedErrorBar(fLow,(MeanOB.Shk.(MouseGroup{gr+1})),st);
%         set(g.patch,'FaceColor',[0.8 0 0],'FaceAlpha',0.3)
%         set(g.mainLine,'Color',[0.8 0 0],'linewidth',2)
%         %Cols{1}(1,:)
%
%         subplot(2,size(MouseGroup,2)-1,gr)
%         hold on
%         g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.Sal),stdError(MeanOB.Saf.Sal));
%         set(g.patch,'FaceColor',[0.4 0.7 1],'FaceAlpha',0.5)
%         set(g.mainLine,'Color',[0.4 0.7 1],'linewidth',2)
%         %Cols{2}(2,:)
%         g = shadedErrorBar(fLow,(MeanOB.Saf.(MouseGroup{gr+1})),st);
%         set(g.patch,'FaceColor',[0 0 0.9],'FaceAlpha',0.3)
%         set(g.mainLine,'Color',[0 0 0.9],'linewidth',2)
%         %Cols{2}(1,:)
%     else
%         subplot(2,size(MouseGroup,2)-1,size(MouseGroup,2)+gr-1)
%         hold on
%         g = shadedErrorBar(fLow,nanmean(MeanOB.Shk.Sal),stdError(MeanOB.Shk.Sal));
%         set(g.patch,'FaceColor',[1 0.6 1],'FaceAlpha',0.5)
%         set(g.mainLine,'Color',[1 0.6 1],'linewidth',2)
%         g = shadedErrorBar(fLow,nanmean(MeanOB.Shk.(MouseGroup{gr+1})),stdError(MeanOB.Shk.(MouseGroup{gr+1})));
%         set(g.patch,'FaceColor',[0.8 0 0],'FaceAlpha',0.3)
%         set(g.mainLine,'Color',[0.8 0 0],'linewidth',2)
%
%         subplot(2,size(MouseGroup,2)-1,gr)
%         hold on
%         g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.Sal),stdError(MeanOB.Saf.Sal));
%         set(g.patch,'FaceColor',[0.4 0.7 1],'FaceAlpha',0.5)
%         set(g.mainLine,'Color',[0.4 0.7 1],'linewidth',2)
%         g = shadedErrorBar(fLow,nanmean(MeanOB.Saf.(MouseGroup{gr+1})),stdError(MeanOB.Saf.(MouseGroup{gr+1})));
%         set(g.patch,'FaceColor',[0 0 0.9],'FaceAlpha',0.3)
%         set(g.mainLine,'Color',[0 0 0.9],'linewidth',2)
%         hold on
%     end
%     %         ylim([0 0.03])
%     xlim([0 12])
%
%     legend('Shk Sal',['Shk ' MouseGroup{gr+1}],'Safe Sal',['Safe ' MouseGroup{gr+1}])
%     ylabel('Power')
%     xlabel('Frequency(Hz)')
%     title('OB spectra')
%
% end
%
%
% figure
% for gr = 1:size(MouseGroup,2)
%     for m = 1:length(B.(MouseGroup{gr}))
%
%         Mice.(MouseGroup{gr})(m)
%         plot(fLow,MeanOB.Saf.(MouseGroup{gr})(m,:),'r')
%         [SafePeak.(MouseGroup{gr})(m),y]=ginput(1);
%
%         plot(fLow,MeanOB.Shk.(MouseGroup{gr})(m,:),'r')
%         [ShockPeak.(MouseGroup{gr})(m),y]=ginput(1);
%
%
%     end
% end
%
%
% figure
% freqLims = [2.3;3.3];
% freq2Lims = [2,2.5];
%
% for gr = 1:4
%     for m = 1:length(B.(MouseGroup{gr}))
%
%         SafePow{gr} = nanmean(MeanOB.Saf.(MouseGroup{gr})(:,find(fLow>freqLims(1),1,'first'):find(fLow>freqLims(2),1,'first')),2);
%         %./...
%         %   nanmean(MeanOB.Saf.(MouseGroup{gr})(:,find(fLow>freq2Lims(1),1,'first'):find(fLow>freq2Lims(2),1,'first')),2);
%
%         ShockPow{gr} = nanmean(MeanOB.Saf.(MouseGroup{gr})(:,find(fLow>freqLims(1),1,'first'):find(fLow>freqLims(2),1,'first')),2);
%     end
% end
%
% clf
% Cols2 = {[0.8 0.8 0.8];[0.6 0.6 0.6];[0.6 0.6 0.6];[0.6 0.6 0.6]} ;
% MakeSpreadAndBoxPlot_SB(SafePow(1:4),Cols2,[1,2,3,4])
% clear  p
% [p(1),h,stats] = ranksum(SafePow{1},SafePow{2});
% [p(2),h,stats] = ranksum(SafePow{1},SafePow{3});
% sigstar_DB({[1,2],[1,3]},p)
%
% figure
% A = {ShockPeak.Sal;ShockPeak.Mdz;ShockPeak.Flx;ShockPeak.FlxChr};
% % A = {SafePeak.Sal;SafePeak.Mdz;SafePeak.Flx;SafePeak.FlxChr};
% Cols2 = {UMazeColors((MouseGroup{1})),UMazeColors((MouseGroup{2})),UMazeColors((MouseGroup{3})),UMazeColors((MouseGroup{4}))};
% MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,3,4])
% [p(1),h,stats] = ranksum(A{1},A{2});
% [p(2),h,stats] = ranksum(A{1},A{3});
% [p(3),h,stats] = ranksum(A{1},A{4});
%
%
%
%
% for gr = 1 : size(MouseGroup,2)
%     subplot(2,4,gr)
%     imagesc(log(AllOB.Shk.(MouseGroup{gr}))'), axis xy
%     subplot(2,4,gr+4)
%     imagesc(log(AllOB.Saf.(MouseGroup{gr}))'), axis xy
% end


figure,
subplot(3,1,1),PlotErrorBarN_KJ({Fzdur.Tot.Sal,Fzdur.Tot.Mdz,Fzdur.Tot.Flx,Fzdur.Tot.FlxChr},'paired',0,'newfig',0)
subplot(3,1,2),PlotErrorBarN_KJ({Fzdur.Shk.Sal,Fzdur.Shk.Mdz,Fzdur.Shk.Flx,Fzdur.Shk.FlxChr},'paired',0,'newfig',0)
subplot(3,1,3),PlotErrorBarN_KJ({Fzdur.Saf.Sal,Fzdur.Saf.Mdz,Fzdur.Saf.Flx,Fzdur.Saf.FlxChr},'paired',0,'newfig',0)

figure,
PlotErrorBarN_KJ({Fzdur.Shk.Sal./(Fzdur.Shk.Sal+Fzdur.Saf.Sal),...
    Fzdur.Shk.Mdz./(Fzdur.Shk.Mdz+Fzdur.Saf.Mdz),...
    Fzdur.Shk.Flx./(Fzdur.Shk.Flx+Fzdur.Saf.Flx),...
    Fzdur.Shk.FlxChr./(Fzdur.Shk.FlxChr+Fzdur.Saf.FlxChr)},'paired',0,'newfig',0)

