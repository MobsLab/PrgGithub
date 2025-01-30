clear all
MouseGroup = {'Sal','Mdz','Flx','FlxChr'};
Mice.Sal = [688,739,777,779,849,893];
Mice.Flx = [740,750,778,775,794];
Mice.Mdz = [829,851,856,857,858,859];
Mice.FlxChr = [876,877];

cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondBlockedShock_PreDrug/Cond1
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
sesstype = 1
%for sesstype = 1:length(SessNames_Combi)
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
%             B.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'spectrum','prefix','B_Low');
%             H.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'spectrum','prefix','H_Low');
%              P.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'spectrum','prefix','PFCx_Low');
% %             Pos.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'LinearPosition');
            Fz.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','freezeepoch');
%             Blk.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','blockedepoch');
%             Zn.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','zoneepoch');
%             HR.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'heartrate');
%             Rip.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'ripples');
%             BInstP.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'instfreq','suffix_instfreq','B','method','PT');
%             BInstW.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'instfreq','suffix_instfreq','B','method','WV');
%             BWV.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'wavelet_spec','prefix','B');
%             HWV.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'wavelet_spec','prefix','H');
%             PWV.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'wavelet_spec','prefix','PFCx');
            
        end
    end
         save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_BlkEpoch_Corr_CS.mat'],'Blk','-v7.3')

%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_B_Corr.mat'],'B','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_H_Corr.mat'],'H','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_P_Corr.mat'],'P','-v7.3')
     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Fz_Corr_CS.mat'],'Fz','-v7.3')
     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Zn_Corr_CS.mat'],'Zn','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_HR_Corr.mat'],'HR','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Rip_Corr.mat'],'Rip','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_BInstP_Corr.mat'],'BInstP','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_BInstW_Corr.mat'],'BInstW','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_BWV.mat'],'BWV','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_HWV.mat'],'HWV','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_PWV.mat'],'PWV','-v7.3')
    clear B H P Fz Zn HR Rip BInstP BInstW BWC HWV PWV
    
%end



%% Make the figures
    
sesstype = 1;
    
    load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Fz_Corr_CS.mat'])
    load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Zn_Corr_CS.mat'])
    load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_BlkEpoch_Corr_CS.mat']);


%%
bloque=0;
for mg=1:length(MouseGroup)
    Mat.(MouseGroup{mg})=[];
    Mat_percent.(MouseGroup{mg})=[];
    Total.(MouseGroup{mg})=[];
    PercentTotal.(MouseGroup{mg})=[];
end

for mg = 1:length(MouseGroup)
    for m = 1:length(Mice.(MouseGroup{mg}))
        TotalEpoch=Fz.(MouseGroup{mg}){m};
        ShockEpoch = and(Fz.(MouseGroup{mg}){m},Zn.(MouseGroup{mg}){m}{1});
%          SafeEpoch = and(Fz.(MouseGroup{mg}){m},or(Zn.(MouseGroup{mg}){m}{2},Zn.(MouseGroup{mg}){m}{5}));
        SafeEpoch = and(Fz.(MouseGroup{mg}){m},Zn.(MouseGroup{mg}){m}{2});
        if bloque==1
            ShockEpoch=and(ShockEpoch,Blk.(MouseGroup{mg}){m});
            SafeEpoch=and(SafeEpoch,Blk.(MouseGroup{mg}){m});
            TotalEpoch=and(TotalEpoch,Blk.(MouseGroup{mg}){m});
        end
        Mat.(MouseGroup{mg})(m,1)=sum(Stop(ShockEpoch)-Start(ShockEpoch));
        Mat.(MouseGroup{mg})(m,2)=sum(Stop(SafeEpoch)-Start(SafeEpoch));
        Total.(MouseGroup{mg})(m)=sum(Stop(TotalEpoch)-Start(TotalEpoch));
        Mat_percent.(MouseGroup{mg})(m,1)=(sum(Stop(ShockEpoch)-Start(ShockEpoch)))/sum(Stop(Zn.(MouseGroup{mg}){m}{1})-Start(Zn.(MouseGroup{mg}){m}{1}));
        Mat_percent.(MouseGroup{mg})(m,2)=(sum(Stop(SafeEpoch)-Start(SafeEpoch)))/sum(Stop(Zn.(MouseGroup{mg}){m}{2})-Start(Zn.(MouseGroup{mg}){m}{2}));                
        PercentTotal.(MouseGroup{mg})(m)=sum(Stop(TotalEpoch)-Start(TotalEpoch))/sum(Stop(Blk.(MouseGroup{mg}){m})-Start(Blk.(MouseGroup{mg}){m}));
    end
end



%% figure quantity freezing

Mat_safe=NaN(6,11);
Mat_shock=NaN(6,11);
Mat_tot=NaN(6,4);

Mat_shock(:,1)=Mat.Sal(:,1);
Mat_shock(:,4)=Mat.Mdz(:,1);
Mat_shock(1:5,7)=Mat.Flx(:,1);
Mat_shock(1:2,10)=Mat.FlxChr(:,1);

Mat_safe(:,2)=Mat.Sal(:,2);
Mat_safe(:,5)=Mat.Mdz(:,2);
Mat_safe(1:5,8)=Mat.Flx(:,2);
Mat_safe(1:2,11)=Mat.FlxChr(:,2);

Mat_tot(:,1)=Total.Sal;
Mat_tot(:,2)=Total.Mdz;
Mat_tot(1:5,3)=Total.Flx;
Mat_tot(1:2,4)=Total.FlxChr;
%%
figure
line([-1 0],[-1 0],'color',[1,0,0],'linewidth',4);
hold on
line([-1 0],[-1 0],'color',[0,0,1],'linewidth',4);
hold on
PlotErrorBarN_KJ(Mat_shock/10000, 'newfig', 0,'barcolors',[1 0 0],'paired',0);
PlotErrorBarN_KJ(Mat_safe/10000, 'newfig', 0,'barcolors',[0 0 1],'paired',0);
set(gca,'xticklabel',{'','saline','Mdz','','Flx','FlxCh','',''});
legend('shock','safe');
ylabel('s')
xlim([0 12]);
title('total amount of recorded freezing');
xticklabels({'Saline','','','','Midazolam','','Acute','Fluoxetine','','Chronic','Fluoxetine',''})
xticks([1:11])
annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with qtity_freezing_cs.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')
%%
figure

PlotErrorBarN_KJ(Mat_tot/10000, 'newfig', 0,'barcolors','m','paired',0);
title('total freezing')
xticklabels({'Sal','Mdz','Flx','FlxChr'})
xticks([1:4])
annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with qtity_freezing_cs.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')
%% tests



              