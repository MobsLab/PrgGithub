% clear all
% close all
GetAllSalineSessions_BM;
Mouse = Drugs_Groups_UMaze_BM(9);
% 
AllMice = fieldnames(CondSess);
% Mouse = [Mouse,1189];
for mm = 1:length(AllMice)
    if not(isempty(find(Mouse == eval(AllMice{mm}(2:end)))))
        Allsafe = [];
        Allshock = [];
        for ff = 1:length(CondSess.(AllMice{mm}))
            cd(CondSess.(AllMice{mm}){ff})
            keyboard
            if exist('HeartBeatInfo.mat')>0
                mkdir(['/media/nas7/ProjetEmbReact/Figures/Examples/' AllMice{mm}])
                fig = figure;
                load('B_Low_Spectrum.mat')
%                 load('HeartBeatInfo.mat')
                load('behavResources_SB.mat')
                load('InstFreqAndPhase_B.mat')
                
                SfZone = or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{4});
                SkZone = or(Behav.ZoneEpoch{1},Behav.ZoneEpoch{3});
                Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
                if ~isfield(Behav,'FreezeAccEpoch')
                    Allsafe = [Allsafe;Data(Restrict(Sptsd,and(Behav.FreezeEpoch,SfZone)))];
                    Allshock = [Allshock;Data(Restrict(Sptsd,and(Behav.FreezeEpoch,SkZone)))];
                else
                    Allsafe = [Allsafe;Data(Restrict(Sptsd,and(Behav.FreezeAccEpoch,SfZone)))];
                    Allshock = [Allshock;Data(Restrict(Sptsd,and(Behav.FreezeAccEpoch,SkZone)))];
                    
                end

%                 try
%                 % accelero
%                 subplot(511)
%                 plot(Range(Behav.MovAcctsd,'s'),Data(Behav.MovAcctsd))
%                 hold on
%                 plot(Range(Behav.MovAcctsd,'s'),Data(Behav.MovAcctsd))
%                 
%                 % position
%                 subplot(512)
%                 plot(Range(Behav.LinearDist,'s'),Data(Behav.LinearDist))
%                 ylim([0 1])
%                 
%                 % breathing
%                 subplot(513)
%                 imagesc(Spectro{2},Spectro{3},log(Spectro{1})'), axis xy
%                 hold on
%                 if not(isempty(Start(TTLInfo.StimEpoch,'s')))
%                     plot(Start(TTLInfo.StimEpoch,'s'),10,'r*')
%                 end
%                 caxis([9 14])
%                 line(xlim,[4 4])
%                 colormap jet
%                 ylim([1 15])
% 
%                 % breathing
%                 subplot(514)
%                 plot(Range(LocalFreq.PT,'s'),Data(LocalFreq.PT))
%                 hold on
%                 plot(Range(Restrict(LocalFreq.PT,and(Behav.FreezeEpoch,SfZone)),'s'),Data(Restrict(LocalFreq.PT,and(Behav.FreezeEpoch,SfZone))),'.c')
%                 plot(Range(Restrict(LocalFreq.PT,and(Behav.FreezeEpoch,SkZone)),'s'),Data(Restrict(LocalFreq.PT,and(Behav.FreezeEpoch,SkZone))),'.r')
%                 if not(isempty(Start(TTLInfo.StimEpoch,'s')))
%                     plot(Start(TTLInfo.StimEpoch,'s'),10,'r*')
%                 end
%                 % cardiac
%                 subplot(515)
%                 plot(Range(EKG.HBRate,'s'),Data(EKG.HBRate))
%                 hold on
%                 ylim([5 15])
%                 if not(isempty(Start(TTLInfo.StimEpoch,'s')))
%                     plot(Start(TTLInfo.StimEpoch,'s'),10,'r*')
%                 end
%                 end
% %                 saveas(fig.Number,['/media/nas7/ProjetEmbReact/Figures/Examples/',...
% %                     AllMice{mm},filesep,'Sess',num2str(ff),'.png'])
%                 
            else
                disp('no fig')
                
            end
            
            
        end
        close all

        fig = figure;
        subplot(211)
        imagesc(1:10,Spectro{3},Allsafe')
        axis xy
        line(xlim,[4 4]) 
          caxis([9 14])
                colormap jet
                ylim([1 15])
        subplot(212)
        imagesc(1:10,Spectro{3},Allshock')
        axis xy
        line(xlim,[4 4])
          caxis([9 14])
                colormap jet
                ylim([1 15])
        saveas(fig.Number,['/media/nas7/ProjetEmbReact/Figures/PAG',...
            AllMice{mm},'_Freezing.png'])
        close all

    else
        disp('no fig')
        
    end
end
