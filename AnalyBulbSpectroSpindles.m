res=pwd;
scrsz = get(0,'ScreenSize');
color={'g' 'm' 'b' 'r' };

%% ------------- inputs -------------
compspectro=0;
compspectroBulb=0;
compspectroAuTh=1;
nameFolderSave='Figures20130212';

% Dir.path{1}='/media/Nouveau nom/ProjetBulbe/Mouse051/20121227/BULB-Mouse-51-27122012'; 
% Dir.path{2}='/media/Nouveau nom/ProjetBulbe/Mouse047/20121220/BULB-Mouse-47-20122012'; 
% Dir.path{3}='/media/Nouveau nom/ProjetBulbe/Mouse052/20121221/BULB-Mouse-52-21122012'; 
 Dir.path{1}='/media/Nouveau nom/ProjetBulbe/Mouse051/20121109/BULB-Mouse-51-09112012';Dir.group{1}='WT';
 Dir.path{2}='/media/Nouveau nom/ProjetBulbe/Mouse047/20121108/DPCPX/BULB-Mouse-47-08112012';Dir.group{2}='KO';
 Dir.path{3}='/media/Nouveau nom/ProjetBulbe/Mouse052/20121114/BULB-Mouse-52-14112012';Dir.group{3}='KO';

supposednameLFPA={'LFPbulb' 'LFPCx' 'EEGCx' 'LFPpfc' 'EEGpfc' 'LFPThAu'};

params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 20];
movingwin=[3 0.2];
params.tapers=[3 5];

%% Spectrogram comparison between regions

if compspectro
    for i=1:length(Dir.path)
        cd(Dir.path{i})
        figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)]),hold on, Ff{i}=gcf;
        clear Sp f t SWSEpoch
        load('StateEpoch.mat','SWSEpoch')
        load('AnalyBulb.mat','Sp','f','t')
        allSp=Sp; allf=f; allt=t;
        name={};
        for j=1:4
            clear Sp f t
            
            if j==3
                load('StateEpoch.mat','Spectro')
                Sp=Spectro{1}; t=Spectro{2}; f=Spectro{3};
                name{j}='LFPhpc ';
            else
                Sp=allSp{j}; f=allf{j}; t=allt{j};
                name{j}=supposednameLFPA{j};
            end
            
            sta=Start(SWSEpoch,'s');
            stp=Stop(SWSEpoch,'s');
            TempDispSp=[];TempDispt=[];
            
            for ss=1:length(sta)
                I=find(t>=sta(ss) & t<stp(ss));
                TempDispSp=[TempDispSp;Sp(I,:)];
                if isempty(TempDispt), tmax=0; else tmax=max(TempDispt); end
                TempDispt=[TempDispt,tmax+[1:length(I)]*movingwin(2)];
            end
            
            subplot(4,5,5*(j-1)+1:5*j-1), imagesc(TempDispt,f,10*log10(TempDispSp)'), axis xy, caxis([20 65]);
            title(['Spectrogramm SWS ',name{j}])
            try subplot(4,5,[5,10]), hold on, plot(f,mean(10*log10(TempDispSp)),color{j},'linewidth',2); end
        end
        subplot(4,5,[5,10]), legend(name)
        title([Dir.group{i},Dir.path{i}(end-17:end)])
        
        nameFigF=['CompSpectro-',Dir.group{i},Dir.path{i}(end-17:end)];
        saveFigure(Ff{i},nameFigF,[res,'/',nameFolderSave])
    end
end

if compspectroBulb
    figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]),hold on,Gf=gcf;
    color={'r' 'm' 'b' 'c' 'g' 'k' 'r' 'm' 'b' 'c' 'g' 'k' 'r' 'm' 'b' 'c' };
    typo=[3 2 1];
    for i=1:length(Dir.path)
        cd(Dir.path{i})
        disp(['      ',Dir.group{i},Dir.path{i}(end-17:end)])
        clear LFP SWSEpoch PreEpoch; 
        load('LFPBulb.mat')
        load('behavResources.mat','PreEpoch')
        load('StateEpoch.mat','SWSEpoch','NoiseEpoch')
        for j=1:length(LFP)
            clear Sp t f Datae
            try
                Datae=Data(Restrict(LFP{j},and(PreEpoch,SWSEpoch)-NoiseEpoch));
                [Sp,t,f]=mtspecgramc(Datae(1:100*1E4),movingwin,params); %Datae(1:100*1E4)
                subplot(1,3,i), hold on, plot(f,mean(10*log10(Sp)),color{j},'linewidth',typo(ceil(j/6))),ylim([35 70]);
                legend;
            catch
                disp(['problem channel ',num2str(j)])
            end
        end
        title(['SWS ',Dir.group{i},Dir.path{i}(end-17:end)])
    end
    nameFigG='CompSpectroBulbSWS';
    saveFigure(Gf,nameFigG,[res,'/',nameFolderSave])
end

if compspectroAuTh
    figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]),hold on,Gf=gcf;
    color={'r' 'm' 'b' 'c' 'g' 'k' 'r' 'm' 'b' 'c' 'g' 'k' 'r' 'm' 'b' 'c' };
    typo=[3 2 1];
    for i=1:length(Dir.path)
        cd(Dir.path{i})
        disp(['      ',Dir.group{i},Dir.path{i}(end-17:end)])
        clear LFP MovEpoch PreEpoch; 
        load('LFPAuTh.mat')
        load('behavResources.mat','PreEpoch')
        load('StateEpoch.mat','MovEpoch','GndNoiseEpoch')
        for j=1:length(LFP)
            clear Sp t f Datae
            try
                Datae=Data(Restrict(LFP{j},and(PreEpoch,MovEpoch)-GndNoiseEpoch));
                [Sp,t,f]=mtspecgramc(Datae(1:min(100*1E4,length(Datae))),movingwin,params); %Datae(1:100*1E4)
                subplot(1,3,i), hold on, plot(f,mean(10*log10(Sp)),color{j},'linewidth',typo(ceil(j/6))),ylim([35 70]);
                legend;
            catch
                keyboard
                disp(['problem channel ',num2str(j)])
            end
        end
        title(['Wake ',Dir.group{i},Dir.path{i}(end-17:end)])
    end
    nameFigG='CompSpectroAuThWake-RMNoise';
    saveFigure(Gf,nameFigG,[res,'/',nameFolderSave])
end
cd(res)




%% Analyse Spectro parameters influence
% 
% % ------------- params -------------
% %Analyse='tapers'; Testparam={[1 2] [1 3] [2 3] [1 4] [2 4] [2 5] [3 4] [3 5]};
% Testparam={[1 0.2] [2 0.2] [3 0.2] [4 0.2] [5 0.2] [6 0.2] [7 0.2] [8 0.2]};
% lfpName='LFPPFCx';%'LFPdHPC';
% 
% 
% % ------------- LFP + epochs -------------
% try 
%     AnalyLFP{1};
% catch
%     clear LFP; load('LFPdHPC.mat'); AnalyLFP{1}=FilterLFP(LFP{1},[5 14],1024);%LFP{1};%
%     clear LFP; load('LFPPFCx.mat'); AnalyLFP{2}=FilterLFP(LFP{2},[5 14],1024);%LFP{2};%
%     clear LFP; load('LFPBulb.mat'); AnalyLFP{3}=FilterLFP(LFP{4},[5 14],1024);%LFP{4};%
% end
% sta=10835;
% stp=10963;
% % sta=[10841.54 10853.55 10863.13 10869.38 10886.42 10905.95 10911.2]; 
% % stp=[10842.46 10854.21 10864.03 10870.39 10887.36 10907.59 10911.78];
% lengthTime=sum(stp-sta);
% Epoch=intervalSet(sta*1E4,stp*1E4);
% 
% 
% 
% figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]), hold on,
% for i=1:length(AnalyLFP)
% %     subplot(3,3,1:3), hold on, plot([1:length(Data(Restrict(AnalyLFP{i},Epoch)))]/1250,i*1E4+Data(Restrict(AnalyLFP{i},Epoch)),color{i}); 
% %     xlim([0 length(Data(Restrict(AnalyLFP{i},Epoch)))/1250]); ylim([0 (length(AnalyLFP)+1)*1E4]);
%     clear Sp t f
%     [Sp,t,f]=mtspecgramc(Data(Restrict(AnalyLFP{i},Epoch)),movingwin,params);
%     subplot(3,3,[1,4,7]), hold on, plot(f,mean(10*log10(Sp)),color{i},'linewidth',2)
%     plot(f,mean(10*log10(Sp))+stdError(10*log10(Sp)),color{i})
%     plot(f,mean(10*log10(Sp))-stdError(10*log10(Sp)),color{i}), ylim([45 60]);
%     
%     subplot(3,3,2+(i-1)*3:3+(i-1)*3), imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 65]);
%     hold on, plot([1:length(Data(Restrict(AnalyLFP{i},Epoch)))]/1250,10+Data(Restrict(AnalyLFP{i},Epoch))/1E3,'k')
%     
% end
% subplot(3,3,[1,4,7]),legend({'LFPdHPC' '+std' '-std' 'LFPPFCx' '+std' '-std' 'LFPBulb' '+std' '-std'})
% title(['movinwin [',num2str(movingwin(:)'),'] tapers [',num2str(params.tapers(:)'),']'])

% figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)]), hold on, Ff=gcf;
% figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)]), hold on, Gf=gcf;
% 
% 
% 
% disp(['Analyse ',Analyse]) 
% 
% for i=1:length(Testparam)
%     %params.tapers=Testparam{i};
%     movingwin=Testparam{i};
%     clear Sp t f
%     [Sp,t,f]=mtspecgramc(Data(Restrict(LFP,Epoch)),movingwin,params);
%     
%     figure(Ff),subplot(3,3,i), imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 65]);
%     title([Analyse,' : ',num2str(Testparam{i})])
%     
%     figure(Gf),subplot(3,3,i), plot(f,mean(10*log10(Sp))), ylim([45 60]);
%     title([Analyse,' : ',num2str(Testparam{i})])
% end
% 
% 
% nameFigF=['SpectroAnalyse',Analyse,lfpName];
% nameFigG=['MeanSpecAnalyse',Analyse,lfpName];
% saveFigure(Ff,nameFigF,[res,'/',nameFolderSave])
% saveFigure(Gf,nameFigG,[res,'/',nameFolderSave])