clear all
MouseGroup = {'Sal','Mdz','Flx','FlxChr'};
Mice.Sal = [688,739,777,779,849,893];
Mice.Flx = [740,750,778,775,794];
Mice.Mdz = [829,851,856,857,858,859];
Mice.FlxChr = [876];

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

SessNames_Combi{5}={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug' 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };

SessNum_Combi{1} = [2,2,2,4,4,4];
SessNum_Combi{2} = [2,2];
SessNum_Combi{3} = [2,2];
SessNum_Combi{4} = [2,2,2];
SessNum_Combi{5} = [2,2,4,4];

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
            Zn.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','zoneepoch');
%             HR.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'heartrate');
%             Rip.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'ripples');
            BInstP.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'instfreq','suffix_instfreq','B','method','PT');
            BInstW.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'instfreq','suffix_instfreq','B','method','WV');
            Blk.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'Epoch','epochname','blockedepoch');
%             BWV.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'wavelet_spec','prefix','B');
%             HWV.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'wavelet_spec','prefix','H');
%             PWV.(MouseGroup{mg}){mm} = ConcatenateDataFromFolders_SB(Files.(MouseGroup{mg}){mm},'wavelet_spec','prefix','PFCx');
            
        end
    end
    %save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_BlkEpoch_Corr.mat'],'Blk','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_B_Corr.mat'],'B','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_H_Corr.mat'],'H','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_P_Corr.mat'],'P','-v7.3')
    save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Fz_Corr.mat'],'Fz','-v7.3')
    save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Zn_Corr.mat'],'Zn','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_HR_Corr.mat'],'HR','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Rip_Corr.mat'],'Rip','-v7.3')
    save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_BInstP_Corr.mat'],'BInstP','-v7.3')
    save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_BInstW_Corr.mat'],'BInstW','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_BWV.mat'],'BWV','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_HWV.mat'],'HWV','-v7.3')
%     save(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_PWV.mat'],'PWV','-v7.3')
    clear B H P Fz Zn HR Rip BInstP BInstW BWC HWV PWV
    
%end


%% Make the figures
    
sesstype = 1;
%     load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_B_Corr.mat'])
%     load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Rip_Corr.mat'])
    load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Fz_Corr.mat'])
    load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_Zn_Corr.mat'])
%     load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_HR_Corr.mat'])
%     load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_P_Corr.mat'])
    load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_BlkEpoch_Corr.mat']);
    load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_BInstP_Corr.mat']);
    load(['/media/nas4/ProjetEmbReact/DrugEffectFigures/DataFLXMDZ',num2str(sesstype),'_BInstW_Corr.mat']);

%% episode per episode
for mg=1:length(MouseGroup)
    for m=1:length(Mice.(MouseGroup{mg}))
        BInst_ep.(MouseGroup{mg}){m}=[];
        BInst_ep_dur.(MouseGroup{mg}){m}=[];
        BInst_ep_pond.(MouseGroup{mg}){m}=[];
    end
end
tech='P';
for mg=1:length(MouseGroup)
    for m=1:length(Mice.(MouseGroup{mg}))
        mean_ep=[];
        dur=[];
        if tech=='W'
            for k=1:length(Start(Fz.(MouseGroup{mg}){m}))
                ep=Restrict(BInstW.(MouseGroup{mg}){m},subset(Fz.(MouseGroup{mg}){m},k));
                dur=[dur,(Stop(subset(Fz.(MouseGroup{mg}){m},k))-Start(subset(Fz.(MouseGroup{mg}){m},k)))];
                mean_ep(k)=mean(ep);
            end 
        else
            for k=1:length(Start(Fz.(MouseGroup{mg}){m}))
                ep=Restrict(BInstP.(MouseGroup{mg}){m},subset(Fz.(MouseGroup{mg}){m},k));
                dur=[dur,(Stop(subset(Fz.(MouseGroup{mg}){m},k))-Start(subset(Fz.(MouseGroup{mg}){m},k)))];
                mean_ep(k)=mean(ep);
            end
        end
        BInst_ep.(MouseGroup{mg}){m}=mean_ep;
        BInst_ep_dur.(MouseGroup{mg}){m}=dur;
    end
end
%%
%ponderation
for mg=1:length(MouseGroup)
    for m=1:length(Mice.(MouseGroup{mg}))
        pond=[];
        for k=1:length(BInst_ep.(MouseGroup{mg}){m})
            for i=1:fix(BInst_ep_dur.(MouseGroup{mg}){m}(k)/1000)
                pond=[pond,BInst_ep.(MouseGroup{mg}){m}(k)];
            end
        end
        BInst_ep_pond.(MouseGroup{mg}){m}=pond;
    end
end
%%
centres=0:0.3:8;
norm=1;
for mg = 1:length(MouseGroup)
    for m=1:length(Mice.(MouseGroup{mg}))
    
        Y.(MouseGroup{mg}){m}=[];
        X.(MouseGroup{mg}){m}=[];
        Ymean.(MouseGroup{mg})=[];
        Xmean.(MouseGroup{mg})=[];

    end
end
%%
figure
for mg=1:length(MouseGroup) % sur tous les groupes
    for m=1:length(Mice.(MouseGroup{mg})) % sur toutes les souris du groupe
  
        [Y.(MouseGroup{mg}){m},X.(MouseGroup{mg}){m}]=hist(BInst_ep_pond.(MouseGroup{mg}){m},centres);
        if norm==1;
            Y.(MouseGroup{mg}){m}=Y.(MouseGroup{mg}){m}/sum(Y.(MouseGroup{mg}){m});
        end
       
    end
    for c=1:length(centres)
        S=0;
        for m=1:length(Mice.(MouseGroup{mg}))
            S=S+Y.(MouseGroup{mg}){m}(c);
        end
        Ymean.(MouseGroup{mg})(c)=S/length(Mice.(MouseGroup{mg}));
        Xmean.(MouseGroup{mg})(c)=X.(MouseGroup{mg}){1}(c);
    end

    subplot(2,2,mg)
    bar(Xmean.(MouseGroup{mg}),Ymean.(MouseGroup{mg}),1,'m')
    title(strcat(num2str(MouseGroup{mg}),'Fz_Ep per fz_ep, tech=',tech, ', norm each mouse=',norm))
    xlabel('frequencies')
%     ylim([0 3000])
    xlim([0 8.5])
   
end
annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with analyse_inst_freq_CS.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')



    %% smooth
smoofact=15
for mg=1:length(MouseGroup)
    for m=1:length(Mice.(MouseGroup{mg}))
        NewBInstW.(MouseGroup{mg}){m}=tsd(Range(BInstW.(MouseGroup{mg}){m}),runmean(Data(BInstW.(MouseGroup{mg}){m}),smoofact));
    end
end
    
    %% histogram tout le freezing
    
    clear mg m BInst_ep BInst_ep_dur BInst_ep_pond tech Y X Ymean Xmean xlim ylim
    
smooth=0;
bloque=0;
norm=0;
centres=0:0.3:8;
%centres2=0:0.2:12;
%centres=centres(2:end);
for mg = 1:length(MouseGroup)
    for m=1:length(Mice.(MouseGroup{mg}))
    
        Y.(MouseGroup{mg}){m}=[];
        X.(MouseGroup{mg}){m}=[];
        Ymean.(MouseGroup{mg})=[];
        Xmean.(MouseGroup{mg})=[];
        
        %NY.(MouseGroup{mg}){m}=[];
        %NX.(MouseGroup{mg}){m}=[];
        %NYmean.(MouseGroup{mg})=[];
        %NXmean.(MouseGroup{mg})=[];
    end
end
figure
for mg=1:length(MouseGroup) % sur tous les groupes
    for m=1:length(Mice.(MouseGroup{mg})) % sur toutes les souris du groupe
        
        Fz_bloqued=and(Fz.(MouseGroup{mg}){m}, Blk.(MouseGroup{mg}){m});
        %Non_Fz_bloqued=minus(Blk.(MouseGroup{mg}){m},Fz.(MouseGroup{mg}){m});
        %totalepoch=intervalSet(0, max(Range(BInstW.(MouseGroup{mg}){m})));
        %Non_Fz=minus(totalepoch,Fz.(MouseGroup{mg}){m});
        
        
            if bloque==1
                if smooth==0
                    BInst_Fz=Restrict(BInstW.(MouseGroup{mg}){m},Fz_bloqued);
                    %BInst_non_Fz=Restrict(BInstW.(MouseGroup{mg}){m},Non_Fz_bloqued);
                else 
                    BInst_Fz=Restrict(NewBInstW.(MouseGroup{mg}){m},Fz_bloqued);
                    %BInst_non_Fz=Restrict(NewBInstW.(MouseGroup{mg}){m},Non_Fz_bloqued);
                end
            else
                if smooth==0
                    BInst_Fz=Restrict(BInstW.(MouseGroup{mg}){m},Fz.(MouseGroup{mg}){m});
                    %BInst_non_Fz=Restrict(BInstW.(MouseGroup{mg}){m},Non_Fz);
                else
                    BInst_Fz=Restrict(NewBInstW.(MouseGroup{mg}){m},Fz.(MouseGroup{mg}){m});
                    %BInst_non_Fz=Restrict(NewBInstW.(MouseGroup{mg}){m},Non_Fz);
                end
                    
            end
        

        %[NY.(MouseGroup{mg}){m},NX.(MouseGroup{mg}){m}]=hist(Data(BInst_non_Fz),centres2);
        [Y.(MouseGroup{mg}){m},X.(MouseGroup{mg}){m}]=hist(Data(BInst_Fz),centres);
        if norm==1;
            Y.(MouseGroup{mg}){m}=Y.(MouseGroup{mg}){m}/sum(Y.(MouseGroup{mg}){m});
            %NY.(MouseGroup{mg}){m}=NY.(MouseGroup{mg}){m}/sum(NY.(MouseGroup{mg}){m});
        end
%         figure
%         bar(X.(MouseGroup{mg}){m},Y.(MouseGroup{mg}){m},1)
%         title(num2str(Mice.(MouseGroup{mg})(m)))
       
    end
    for c=1:length(centres)
        S=0;
        for m=1:length(Mice.(MouseGroup{mg}))
            S=S+Y.(MouseGroup{mg}){m}(c);
        end
        Ymean.(MouseGroup{mg})(c)=S/length(Mice.(MouseGroup{mg}));
        Xmean.(MouseGroup{mg})(c)=X.(MouseGroup{mg}){1}(c);
    end
    
%     for c=1:length(centres2)
%         NS=0;
%         for m=1:length(Mice.(MouseGroup{mg}))
%             NS=NS+NY.(MouseGroup{mg}){m}(c);
%         end
%         NYmean.(MouseGroup{mg})(c)=NS/length(Mice.(MouseGroup{mg}));
%         NXmean.(MouseGroup{mg})(c)=NX.(MouseGroup{mg}){1}(c);
%     end

    subplot(2,2,mg)
    bar(Xmean.(MouseGroup{mg}),Ymean.(MouseGroup{mg}),1,'m')
    title(strcat(num2str(MouseGroup{mg}), 'all freezing, tech=W, norm each mouse=0, smooth=', num2str(smooth)))
    xlabel('frequencies')
    %ylim([0 600])
    xlim([0 8.5])
    
%     subplot(4,2,4+mg)
%     bar(NXmean.(MouseGroup{mg}),NYmean.(MouseGroup{mg}),1,'m')
%     title(strcat('Non Freezing, ',num2str(MouseGroup{mg})))
%     xlabel('frequencies')
%     ylim([0 4000])
%     xlim([0 12])
    
    
    
    
end
annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with analyse_inst_freq_CS.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')

%% plot les distrib ensemble
% /!\ il faut que la section precedente ai tourné sans normalisation, de
% preference sur W

for mg=1:length(MouseGroup) % sur tous les groupes
    Ymean.(MouseGroup{mg})=Ymean.(MouseGroup{mg})/sum(Ymean.(MouseGroup{mg}));
    %NYmean.(MouseGroup{mg})=NYmean.(MouseGroup{mg})/sum(NYmean.(MouseGroup{mg}));
   
end
figure
line([-1 0],[-1 0],'color',[0 0 0],'linewidth',4), hold on
line([-1 0],[-1 0],'color',[0 0 1],'linewidth',4)
line([-1 0],[-1 0],'color',[0 1 0],'linewidth',4)
line([-1 0],[-1 0],'color',[1 0 0],'linewidth',4)
plot(Xmean.Sal, Ymean.Sal, 'color',[0 0 0], 'linewidth',2)
plot(Xmean.Mdz, Ymean.Mdz, 'color',[0 0 1], 'linewidth',2)
plot(Xmean.Flx, Ymean.Flx, 'color',[0 1 0], 'linewidth',2)
plot(Xmean.FlxChr, Ymean.FlxChr, 'color',[1 0 0], 'linewidth',2)
legend('Sal','Mdz','Flx','FlxChr')
xlim([0 8])
xlabel('frequencies')
ylabel('distrib - norm')
title('all freezing')

% figure
% line([-1 0],[-1 0],'color',[0 0 0],'linewidth',4), hold on
% line([-1 0],[-1 0],'color',[0 0 1],'linewidth',4)
% line([-1 0],[-1 0],'color',[0 1 0],'linewidth',4)
% line([-1 0],[-1 0],'color',[1 0 0],'linewidth',4)
% plot(NXmean.Sal, NYmean.Sal, 'color',[0 0 0], 'linewidth',2)
% plot(NXmean.Mdz, NYmean.Mdz, 'color',[0 0 1], 'linewidth',2)
% plot(NXmean.Flx, NYmean.Flx, 'color',[0 1 0], 'linewidth',2)
% plot(NXmean.FlxChr, NYmean.FlxChr, 'color',[1 0 0], 'linewidth',2)
% legend('Sal','Mdz','Flx','FlxChr')
% xlim([0 12])
% xlabel('frequencies')
% ylabel('distrib - norm')
% title('Non freezing')

annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with analyse_inst_freq_CS.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')

%% percentage tout le freezing
clear mg m BInst_ep BInst_ep_dur BInst_ep_pond tech Y X Ymean Xmean xlim ylim centres

bloque=1;
smooth=1;
for mg = 1:length(MouseGroup)
    Mean_percent_low.(MouseGroup{mg})=0;
    Mean_percent_high.(MouseGroup{mg})=0;
    Mean_percent_wrong.(MouseGroup{mg})=0;
    for m=1:length(Mice.(MouseGroup{mg}))
    
        Y_LH.(MouseGroup{mg}){m}=[];
        Count_low.(MouseGroup{mg}){m}=0;
        Count_high.(MouseGroup{mg}){m}=0;
        Count_wrong.(MouseGroup{mg}){m}=0;
        Percent_low.(MouseGroup{mg}){m}=0;
        Percent_high.(MouseGroup{mg}){m}=0;
        Percent_wrong.(MouseGroup{mg}){m}=0;
        Mean_percent_low.(MouseGroup{mg})=0;
        Mean_percent_high.(MouseGroup{mg})=0;
        Mean_percent_wrong.(MouseGroup{mg})=0;
        
    end
end

for mg=1:length(MouseGroup) % sur tous les groupes
    for m=1:length(Mice.(MouseGroup{mg}))
        Fz_bloqued=and(Fz.(MouseGroup{mg}){m}, Blk.(MouseGroup{mg}){m});
        if bloque==1
            if smooth==0
                BInst_Fz=Restrict(BInstW.(MouseGroup{mg}){m},Fz_bloqued);
            else
                BInst_Fz=Restrict(NewBInstW.(MouseGroup{mg}){m},Fz_bloqued);
            end
        else
            if smooth==0
                BInst_Fz=Restrict(BInstW.(MouseGroup{mg}){m},Fz.(MouseGroup{mg}){m});
            else
                BInst_Fz=Restrict(NewBInstW.(MouseGroup{mg}){m},Fz.(MouseGroup{mg}){m});
            end
        end
        Y_LH.(MouseGroup{mg}){m}=histc(Data(BInst_Fz),[-inf,1,3,7.5,+inf]);
        Count_low.(MouseGroup{mg}){m}=Y_LH.(MouseGroup{mg}){m}(2);
        Count_high.(MouseGroup{mg}){m}=Y_LH.(MouseGroup{mg}){m}(3);
        Count_wrong.(MouseGroup{mg}){m}=Y_LH.(MouseGroup{mg}){m}(1)+Y_LH.(MouseGroup{mg}){m}(4)+Y_LH.(MouseGroup{mg}){m}(5);
%         Percent_low.(MouseGroup{mg}){m}=Count_low.(MouseGroup{mg}){m}/((Count_low.(MouseGroup{mg}){m}+Count_high.(MouseGroup{mg}){m})+Count_wrong.(MouseGroup{mg}){m});
%         Percent_high.(MouseGroup{mg}){m}=Count_high.(MouseGroup{mg}){m}/((Count_low.(MouseGroup{mg}){m}+Count_high.(MouseGroup{mg}){m})+Count_wrong.(MouseGroup{mg}){m});
%         Percent_wrong.(MouseGroup{mg}){m}=Count_wrong.(MouseGroup{mg}){m}/((Count_low.(MouseGroup{mg}){m}+Count_high.(MouseGroup{mg}){m})+Count_wrong.(MouseGroup{mg}){m});
        Percent_low.(MouseGroup{mg}){m}=Count_low.(MouseGroup{mg}){m}/((Count_low.(MouseGroup{mg}){m}+Count_high.(MouseGroup{mg}){m}));
        Percent_high.(MouseGroup{mg}){m}=Count_high.(MouseGroup{mg}){m}/((Count_low.(MouseGroup{mg}){m}+Count_high.(MouseGroup{mg}){m}));

    end
end
figure
for mg=1:length(MouseGroup)
    SL=0;
    SH=0;
     %SW=0;
    for m=1:length(Mice.(MouseGroup{mg}))
        SL=SL+Percent_low.(MouseGroup{mg}){1,m};
        SH=SH+Percent_high.(MouseGroup{mg}){1,m};
         %SW=SW+Percent_wrong.(MouseGroup{mg}){1,m};
    end
        
        
    Mean_percent_low.(MouseGroup{mg})=SL/length(Mice.(MouseGroup{mg}));
    Mean_percent_high.(MouseGroup{mg})=SH/length(Mice.(MouseGroup{mg}));
     %Mean_percent_wrong.(MouseGroup{mg})=SW/length(Mice.(MouseGroup{mg}));
    
    subplot(2,2,mg)
%     pie([Mean_percent_low.(MouseGroup{mg}),Mean_percent_high.(MouseGroup{mg}),Mean_percent_wrong.(MouseGroup{mg})]);
%     colormap([0 0 1;1 0 0;0.8 0.8 0.8]);
    pie([Mean_percent_low.(MouseGroup{mg}),Mean_percent_high.(MouseGroup{mg})]);
    colormap([0 0 1;1 0 0]);
    title(MouseGroup{mg});
    
end
annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with analyse_inst_freq_CS.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')







%% histogram freezing en safe et shock
clear mg m BInst_ep BInst_ep_dur BInst_ep_pond tech Y X Ymean Xmean xlim ylim centres Mean_percent_low Mean_percent_high Mean_percent_wrong Y_LH Count_low Count_high Count_wrong ...
    Percent_low Percent_high Percent_wrong Mean_percent_low Mean_percent_high Mean_percent_wrong Count Percent Mean_percent Freez_shk Freez_saf BInst_Fz_shk BInst_Fz_saf       

bloque=0;
norm=0;
technique='W'; % W ou P
centres=0:0.4:8;
for mg = 1:length(MouseGroup)
    for m=1:length(Mice.(MouseGroup{mg}))
    
        Y.(MouseGroup{mg}).shk{m}=[];
        Y.(MouseGroup{mg}).saf{m}=[];
        X.(MouseGroup{mg}).shk{m}=[];
        X.(MouseGroup{mg}).saf{m}=[];
        Ymean.(MouseGroup{mg}).shk=[];
        Ymean.(MouseGroup{mg}).saf=[];
        Xmean.(MouseGroup{mg}).shk=[];
        Xmean.(MouseGroup{mg}).saf=[];

    end
end
figure
for mg=1:length(MouseGroup) % sur tous les groupes
    for m=1:length(Mice.(MouseGroup{mg})) % sur toutes les souris du groupe
            Freez_shk=and(Fz.(MouseGroup{mg}){m},Zn.(MouseGroup{mg}){m}{1});
            Freez_saf=and(Fz.(MouseGroup{mg}){m},Zn.(MouseGroup{mg}){m}{2});
            if bloque==1
                Freez_shk=and(Freez_shk, Blk.(MouseGroup{mg}){m});
                Freez_saf=and(Freez_saf, Blk.(MouseGroup{mg}){m});
            end
        if technique=='W'
            BInst_Fz_shk=Restrict(BInstW.(MouseGroup{mg}){m},Freez_shk);
            BInst_Fz_saf=Restrict(BInstW.(MouseGroup{mg}){m},Freez_saf);
        elseif technique=='P'
            BInst_Fz_shk=Restrict(BInstP.(MouseGroup{mg}){m},Freez_shk);
            BInst_Fz_saf=Restrict(BInstP.(MouseGroup{mg}){m},Freez_saf);
        end
%         figure
%         histogram(Range(BInst_Fz_shk)/1e7,centres)
%         figure
%         histogram(Range(BInst_Fz_saf)/1e7,centres)
        [Y.(MouseGroup{mg}).shk{m},X.(MouseGroup{mg}).shk{m}]=hist(Data(BInst_Fz_shk),centres);
        [Y.(MouseGroup{mg}).saf{m},X.(MouseGroup{mg}).saf{m}]=hist(Data(BInst_Fz_saf),centres);
        if norm==1;
            Y.(MouseGroup{mg}).shk{m}=Y.(MouseGroup{mg}).shk{m}/sum(Y.(MouseGroup{mg}).shk{m});
            Y.(MouseGroup{mg}).saf{m}=Y.(MouseGroup{mg}).saf{m}/sum(Y.(MouseGroup{mg}).saf{m});
        end

       
    end
    for c=1:length(centres)
        Ssaf=0;
        Sshk=0;
        for m=1:length(Mice.(MouseGroup{mg}))
            Sshk=Sshk+Y.(MouseGroup{mg}).shk{m}(c);
            Ssaf=Ssaf+Y.(MouseGroup{mg}).saf{m}(c);
        end
        Ymean.(MouseGroup{mg}).shk(c)=Sshk/length(Mice.(MouseGroup{mg}));
        Xmean.(MouseGroup{mg}).shk(c)=X.(MouseGroup{mg}).shk{1}(c);
        Ymean.(MouseGroup{mg}).saf(c)=Ssaf/length(Mice.(MouseGroup{mg}));
        Xmean.(MouseGroup{mg}).saf(c)=X.(MouseGroup{mg}).saf{1}(c);
    end
    subplot(4,2,mg*2-1)
    bar(Xmean.(MouseGroup{mg}).saf,Ymean.(MouseGroup{mg}).saf,1,'b')
    title(strcat(technique,', fz in safe, ',num2str(MouseGroup{mg})))
    xlabel('frequencies')

    xlim([0 8.5])
    subplot(4,2,mg*2)
    bar(Xmean.(MouseGroup{mg}).shk,Ymean.(MouseGroup{mg}).shk,1,'r')
    title(strcat(technique,', fz in shock, ',num2str(MouseGroup{mg})))
    xlabel('frequencies')
    xlim([0 8.5])


    
end
annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with analyse_inst_freq_CS.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')

%% plot les distrib ensemble safe shock
% /!\ il faut que la section precedente ai tourné sans normalisation, de
% preference sur W

for mg=1:length(MouseGroup) % sur tous les groupes
    Ymean.(MouseGroup{mg}).shk=Ymean.(MouseGroup{mg}).shk/sum(Ymean.(MouseGroup{mg}).shk);
    Ymean.(MouseGroup{mg}).saf=Ymean.(MouseGroup{mg}).saf/sum(Ymean.(MouseGroup{mg}).saf);
   
end
figure
subplot(1,2,2)
line([-1 0],[-1 0],'color',[0 0 0],'linewidth',4), hold on
line([-1 0],[-1 0],'color',[0 0 1],'linewidth',4)
line([-1 0],[-1 0],'color',[0 1 0],'linewidth',4)
line([-1 0],[-1 0],'color',[1 0 0],'linewidth',4)
plot(Xmean.Sal.shk, Ymean.Sal.shk, 'color',[0 0 0], 'linewidth',2)
plot(Xmean.Mdz.shk, Ymean.Mdz.shk, 'color',[0 0 1], 'linewidth',2)
plot(Xmean.Flx.shk, Ymean.Flx.shk, 'color',[0 1 0], 'linewidth',2)
plot(Xmean.FlxChr.shk, Ymean.FlxChr.shk, 'color',[1 0 0], 'linewidth',2)
legend('Sal','Mdz','Flx','FlxChr')
xlim([0 8])
xlabel('frequencies')
ylabel('distrib - norm')
title('freezing in shock zone')
subplot(1,2,1)
line([-1 0],[-1 0],'color',[0 0 0],'linewidth',4), hold on
line([-1 0],[-1 0],'color',[0 0 1],'linewidth',4)
line([-1 0],[-1 0],'color',[0 1 0],'linewidth',4)
line([-1 0],[-1 0],'color',[1 0 0],'linewidth',4)
plot(Xmean.Sal.saf, Ymean.Sal.saf, 'color',[0 0 0], 'linewidth',2)
plot(Xmean.Mdz.saf, Ymean.Mdz.saf, 'color',[0 0 1], 'linewidth',2)
plot(Xmean.Flx.saf, Ymean.Flx.saf, 'color',[0 1 0], 'linewidth',2)
plot(Xmean.FlxChr.saf, Ymean.FlxChr.saf, 'color',[1 0 0], 'linewidth',2)
legend('Sal','Mdz','Flx','FlxChr')
xlim([0 8])
xlabel('frequencies')
ylabel('distrib - norm')
title('freezing in safe zone')
annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with analyse_inst_freq_CS.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')



%% percentage safe shock

clear mg m BInst_ep BInst_ep_dur BInst_ep_pond tech Y X Ymean Xmean xlim ylim centres Mean_percent_low Mean_percent_high Mean_percent_wrong Y_LH Count_low Count_high Count_wrong ...
    Percent_low Percent_high Percent_wrong Mean_percent_low Mean_percent_high Mean_percent_wrong Count Percent Mean_percent Freez_shk Freez_saf BInst_Fz_shk BInst_Fz_saf

bloque=1;
zone={'Saf','Shk'};
oscill={'Low','High'};
%oscill={'Low','High','Wrong'};

for mg = 1:length(MouseGroup)
    for z=1:length(zone)
        for o=1:length(oscill)
            for m=1:length(Mice.(MouseGroup{mg}))
                Y_LH.(zone{z}).(MouseGroup{mg}){m}=[];
                Count.(zone{z}).(oscill{o}).(MouseGroup{mg}){m}=0;
                Percent.(zone{z}).(oscill{o}).(MouseGroup{mg}){m}=0;
                Mean_percent.(zone{z}).(oscill{o}).(MouseGroup{mg})=0;
            end
        end    
    end
end

for mg=1:length(MouseGroup) % sur tous les groupes
    for m=1:length(Mice.(MouseGroup{mg}))
        Freez_shk=and(Fz.(MouseGroup{mg}){m},Zn.(MouseGroup{mg}){m}{1});
        Freez_saf=and(Fz.(MouseGroup{mg}){m},Zn.(MouseGroup{mg}){m}{2});
        if bloque==1
            Freez_shk=and(Freez_shk, Blk.(MouseGroup{mg}){m});
            Freez_saf=and(Freez_saf, Blk.(MouseGroup{mg}){m});
        end
        BInst_Fz_shk=Restrict(BInstW.(MouseGroup{mg}){m},Freez_shk);
        BInst_Fz_saf=Restrict(BInstW.(MouseGroup{mg}){m},Freez_saf);
        Y_LH.Shk.(MouseGroup{mg}){m}=histc(Data(BInst_Fz_shk),[-inf,1,3.5,7.5,+inf]);
        Y_LH.Saf.(MouseGroup{mg}){m}=histc(Data(BInst_Fz_saf),[-inf,1,3.5,7.5,+inf]);
        for z=1:length(zone)
            Count.(zone{z}).Low.(MouseGroup{mg}){m}=Y_LH.(zone{z}).(MouseGroup{mg}){m}(2);
            Count.(zone{z}).High.(MouseGroup{mg}){m}=Y_LH.(zone{z}).(MouseGroup{mg}){m}(3);
            %Count.(zone{z}).Wrong.(MouseGroup{mg}){m}=Y_LH.(zone{z}).(MouseGroup{mg}){m}(1)+Y_LH.(zone{z}).(MouseGroup{mg}){m}(4)+Y_LH.(zone{z}).(MouseGroup{mg}){m}(5);
            %Percent.(zone{z}).Low.(MouseGroup{mg}){m}=Count.(zone{z}).Low.(MouseGroup{mg}){m}/((Count.(zone{z}).Low.(MouseGroup{mg}){m}+Count.(zone{z}).High.(MouseGroup{mg}){m})+Count.(zone{z}).Wrong.(MouseGroup{mg}){m});
            %Percent.(zone{z}).High.(MouseGroup{mg}){m}=Count.(zone{z}).High.(MouseGroup{mg}){m}/((Count.(zone{z}).Low.(MouseGroup{mg}){m}+Count.(zone{z}).High.(MouseGroup{mg}){m})+Count.(zone{z}).Wrong.(MouseGroup{mg}){m});
            %Percent.(zone{z}).Wrong.(MouseGroup{mg}){m}=Count.(zone{z}).Wrong.(MouseGroup{mg}){m}/((Count.(zone{z}).Low.(MouseGroup{mg}){m}+Count.(zone{z}).High.(MouseGroup{mg}){m})+Count.(zone{z}).Wrong.(MouseGroup{mg}){m});
            Percent.(zone{z}).Low.(MouseGroup{mg}){m}=Count.(zone{z}).Low.(MouseGroup{mg}){m}/((Count.(zone{z}).Low.(MouseGroup{mg}){m}+Count.(zone{z}).High.(MouseGroup{mg}){m}));
            Percent.(zone{z}).High.(MouseGroup{mg}){m}=Count.(zone{z}).High.(MouseGroup{mg}){m}/((Count.(zone{z}).Low.(MouseGroup{mg}){m}+Count.(zone{z}).High.(MouseGroup{mg}){m}));
        end
    end
end
figure
for mg=1:length(MouseGroup)
    for z=1:length(zone)
        for o=1:length(oscill)
            S=0;
            for m=1:length(Mice.(MouseGroup{mg}))
                S=S+Percent.(zone{z}).(oscill{o}).(MouseGroup{mg}){1,m};
            end
            Mean_percent.(zone{z}).(oscill{o}).(MouseGroup{mg})=S/length(Mice.(MouseGroup{mg}));
        end
    end
    subplot(4,2,mg*2-1)
    %pie([Mean_percent.Saf.Low.(MouseGroup{mg}),Mean_percent.Saf.High.(MouseGroup{mg}),Mean_percent.Saf.Wrong.(MouseGroup{mg})]);
    %colormap([0 0 1;1 0 0;0.8 0.8 0.8]);
     pie([Mean_percent.Saf.Low.(MouseGroup{mg}),Mean_percent.Saf.High.(MouseGroup{mg})]);
     colormap([0 0 1;1 0 0]);
    title(strcat(MouseGroup{mg}, ', Safe'));
    subplot(4,2,mg*2)
    %pie([Mean_percent.Shk.Low.(MouseGroup{mg}),Mean_percent.Shk.High.(MouseGroup{mg}),Mean_percent.Shk.Wrong.(MouseGroup{mg})]);
    %colormap([0 0 1;1 0 0;0.8 0.8 0.8]);
     pie([Mean_percent.Shk.Low.(MouseGroup{mg}),Mean_percent.Shk.High.(MouseGroup{mg})]);
     colormap([0 0 1;1 0 0]);
    title(strcat(MouseGroup{mg}, ', Shock'));
    
end
annotation('textbox',[.50 0 .2 .06], 'String', strcat(['Figure created with analyse_inst_freq_CS.m']), 'FitBoxToText','on','EdgeColor','none','FontAngle','italic')



 