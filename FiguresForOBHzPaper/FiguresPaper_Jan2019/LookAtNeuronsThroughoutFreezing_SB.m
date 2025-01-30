clear all
Dir = PathForExperimentFEAR('Fear-electrophy');
LongLim  = [6,14,22];
LongLimEnd  = [14,22,40];

for lg = 1:length(LongLim)
    bi=2000;
    binsize=5*(LongLimEnd(lg)+LongLim(lg))/2;

    MiceDone = {};

    mousenum=0;
    for mm=1:length(Dir.path)
        
        if strcmp(Dir. group{mm},'CTRL') %%&& sum(strcmp(MiceDone,Dir.name{mm}))==0
            
            cd(Dir.path{mm})
            clear Movtsd FreezeEpoch FreezeAccEpoch
            
            if exist('SpikeData.mat')>0
                disp(Dir.path{mm})
                
                mousenum = mousenum +1;
                if mousenum ==29
                    keyboard
                end
                MiceDone{mousenum} = Dir.name{mm};
                
                % just get PFC neurons - no mua
                % Get Neurons
                load LFPData/InfoLFP.mat
                chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
                load('SpikeData.mat')
                
                %% get the n° of the neurons of PFCx
                numtt=[]; % nb tetrodes ou montrodes du PFCx
                load LFPData/InfoLFP.mat
                chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
                
                
                for cc=1:length(chans)
                    for tt=1:length(tetrodeChannels) % tetrodeChannels= tetrodes ou montrodes (toutes)
                        if ~isempty(find(tetrodeChannels{tt}==chans(cc)))
                            numtt=[numtt,tt];
                        end
                    end
                end
                
                numNeurons=[]; % neurones du PFCx
                for i=1:length(S)
                    if ismember(TT{i}(1),numtt)
                        numNeurons=[numNeurons,i];
                    end
                end
                
                numMUA=[];
                for k=1:length(numNeurons)
                    j=numNeurons(k);
                    if TT{j}(2)==1
                        numMUA=[numMUA, k];
                    end
                end
                numNeurons(numMUA)=[];
                
                S = S(numNeurons);
                
                try, load('behavResources.mat');catch,load('Behavior.mat'); end
                if exist('FreezeAccEpoch','var')
                    FreezeEpoch = FreezeAccEpoch;
                end
                
                TotEpoch = intervalSet(0,max(Range(Movtsd)));
                FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
                FreezeEpoch = dropShortIntervals(FreezeEpoch,2*1e4);
                
                
                st=Start(FreezeEpoch);
                to=End(FreezeEpoch);
                dur=End(FreezeEpoch,'s')-Start(FreezeEpoch,'s');
                
                listlong=find(dur>LongLim(lg) & dur<LongLimEnd(lg));
                
                if length(listlong)>1
                    Qt1{lg}{mousenum}=[];
                    
                    clear ti
                    
                    for k=1:length(listlong)
                        i=listlong(k);
                        ti(k,:)=[st(i)-3*(to(i)-st(i))/binsize:(to(i)-st(i))/binsize:to(i)+3*(to(i)-st(i))/binsize];
                    end
                    
                    
                    Qs = MakeQfromS(S,bi);
                    qz=zscore(Data(Qs));
                    Qz=tsd(Range(Qs),qz);
                    
                    
                    for i=1:size(ti,1)
                        Qt1{lg}{mousenum}=[Qt1{lg}{mousenum};full(Data(Restrict(Qz,ti(i,:))))'];
                    end
                    NumEpisodes{lg}(mousenum) = size(ti,1);
                    NumNeurons{lg}(mousenum) = length(S);
                    
                else
                                        
                    X = [0-3/binsize:1/binsize:1+3/binsize];
                    Qt1{lg}{mousenum}=nan(length(S),length(X));
                    
                    
                    NumEpisodes{lg}(mousenum) = 0;
                    NumNeurons{lg}(mousenum) = length(S);
                end
                
            end
        end
    end
    
end

figure
%% look at order of firing
for lg = 1:length(LongLim)
    MeanResp{lg}  = [];
    for k = 1 : length(NumNeurons{lg})
        A = (reshape(Qt1{lg}{k},[NumNeurons{lg}(k),max([NumEpisodes{lg}(k),1]),size(Qt1{lg}{k},2)]));
        MeanResp{lg} =[MeanResp{lg}, squeeze(nanmean(A(:,:,:),2))'];
%         imagesc(squeeze(nanmean(A(:,:,:),2))')
%         pause
    end
    subplot(1,3,lg)
    BadNeurons{lg} = unique([find((sum(diff(MeanResp{lg})))==0),find(sum(isnan(MeanResp{lg}))==size(MeanResp{lg},1))]);
    Temp = MeanResp{lg};
    Temp(:,BadNeurons{lg}) = [];
    [val,ind] = max(Temp(4:end-3,:));
    AllInd{lg} = ind;
    A = sortrows([ind',nanzscore(Temp)']);
    A = A(:,2:end);
    imagesc(X,1:length(A),A)
    clim([-2 2])
end

clf
AllBadNeurons = [];
for lg = 1:length(LongLim)
   AllBadNeurons = [AllBadNeurons,BadNeurons{lg}];
end
AllBadNeurons = unique(AllBadNeurons);

for lg = 1:length(LongLim)
    binsize=5*(LongLimEnd(lg)+LongLim(lg))/2;

    X = [0-3/binsize:1/binsize:1+3/binsize];

    TempRef = MeanResp{lg};
    TempRef(:,AllBadNeurons) = [];
    [val,ind] = max(TempRef(5:end-5,:));
    
    for lg2 = 1:length(LongLim)
        TempTest = MeanResp{lg2};
        TempTest(:,AllBadNeurons) = [];
        subplot(length(LongLim),length(LongLim),length(LongLim)*(lg-1)+lg2)
        A = sortrows([ind',nanzscore(TempTest)']);
        A = A(:,2:end);
        imagesc(X,1:size(A,2),A)
        clim([-2 2])
            title(['Fz dur ' num2str(LongLim(lg2)) 's'])
            xlabel('freezing time norm.')
                if lg2==1
                    ylabel(['Class. by Fz dur ' num2str(LongLim(lg)) 's'])
                end
    end
end
 
 

figure
%% look at order of firing - cross validate
for lg = 1:length(LongLim)
    MeanResp_FirstHalf{lg}  = [];
    MeanResp_SecondHalf{lg}  = [];

    for k = 1 : length(NumNeurons{lg})
        A = (reshape(Qt1{lg}{k},[NumNeurons{lg}(k),max([NumEpisodes{lg}(k),1]),size(Qt1{lg}{k},2)]));
        MeanResp_FirstHalf{lg} =[MeanResp_FirstHalf{lg}, squeeze(nanmean(A(:,1:max([1,floor(size(A,2)/2)]),:),2))'];
        MeanResp_SecondHalf{lg} =[MeanResp_SecondHalf{lg}, squeeze(nanmean(A(:,max([1,floor(size(A,2)/2+1)]):end,:),2))'];
%         imagesc(squeeze(nanmean(A(:,:,:),2))')
%         pause
    end
    BadNeurons{lg} = unique([find((sum(diff(MeanResp_FirstHalf{lg})))==0),find(sum(isnan(MeanResp_FirstHalf{lg}))==size(MeanResp_FirstHalf{lg},1))]);
    Temp_FirstHalf = MeanResp_FirstHalf{lg};
    Temp_FirstHalf(:,BadNeurons{lg}) = [];
    Temp_SecondHalf = MeanResp_SecondHalf{lg};
    Temp_SecondHalf(:,BadNeurons{lg}) = [];

    [val,ind] = max(Temp_FirstHalf(4:end-3,:));
    AllInd{lg} = ind;
    subplot(2,3,lg)
    A = sortrows([ind',nanzscore(Temp_FirstHalf)']);
    A = A(:,2:end);
    imagesc(X,1:length(A),A)
    clim([-2 2])
    
        subplot(2,3,3+lg)
            [val,ind] = max(Temp_SecondHalf(4:end-3,:));

    A = sortrows([ind',zscore(Temp_SecondHalf)']);
    A = A(:,2:end);
    imagesc(X,1:length(A),A)
    clim([-2 2])

end

clf
% Lengths = {'5-12s','15-22s'};
% session by session
for lg = 1:length(LongLim)
binsize=10*(LongLimEnd(lg)+LongLim(lg))/2;

    X = [0-3/binsize:1/binsize:1+3/binsize];
    AllRi{lg} = zeros(size(Qt1{lg}{1},2),size(Qt1{lg}{1},2));
    for mouse = 1 : length(NumNeurons{lg})
        if NumEpisodes{lg}(mouse)>1 && NumNeurons{lg}(mouse)>10
            [r1,p1]=corrcoef(Qt1{lg}{mouse});
            AllRi{lg} = AllRi{lg}+r1;
        end
    end
    AllRi{lg} = AllRi{lg}/sum(NumEpisodes{lg}(:)>1 & NumNeurons{lg}(:)>10);
    subplot(3,3,lg)
    TempRi=  AllRi{lg}-diag(diag(AllRi{lg}));
    imagesc(X,X,TempRi)
    caxis([-0.1 0.4])
    axis xy
    %     title(Lengths{i})
    title(num2str(LongLim(lg)))
    if lg ==1
        ylabel('Av. mouse by mouse corr')
    end
end


% average over repetitions then make pseudo pop
for lg = 1:length(LongLim)
     MeanResp{lg}  = [];
    for k = 1 : length(NumNeurons{lg})
        A = (reshape(Qt1{lg}{k},[NumNeurons{lg}(k),max([NumEpisodes{lg}(k),1]),size(Qt1{lg}{k},2)]));
        MeanResp{lg} =[MeanResp{lg}, squeeze(nanmean(A(:,:,:),2))'];
    end
    BadNeurons{lg} = unique([find((sum(diff(MeanResp{lg})))==0),find(sum(isnan(MeanResp{lg}))==size(MeanResp{lg},1))]);
    Temp = MeanResp{lg};
    Temp(:,BadNeurons{lg}) = [];
    
    subplot(3,3,lg+3)
    TempRi=  corrcoef(Temp');
    TempRi = TempRi-diag(diag(TempRi));
    imagesc(X,X,TempRi)
    caxis([-0.1 0.35])
    axis xy
    if lg ==1
        ylabel('Corr of psuedo pop')
    end
    
end

% make one huge correlation matrix
for lg = 1:3
    AllResp{lg}  = [];
    for k = 1 : length(NumNeurons{lg})
        AllResp{lg} = [AllResp{lg};Qt1{lg}{k}];
    end
     AllResp{lg}(sum(isnan(AllResp{lg}'))==size(AllResp{lg},2),:)=[];
    subplot(3,3,lg+6)
    TempRi=  corrcoef(AllResp{lg});
    TempRi = TempRi-diag(diag(TempRi));
    imagesc(X,X,TempRi)
    caxis([-0.1 0.2])
    axis xy
    if lg ==1
        ylabel('All data in one matrix')
    end
    size(TempRi)
end



figure
for lg = 1:2
    MeanResp{lg}  = [];
    for k = 1 : length(NumNeurons{lg})
        A = (reshape(Qt1{lg}{k},[NumNeurons{lg}(k),NumEpisodes{lg}(k),size(Qt1{lg}{1},2)]));
        MeanResp{lg} =[MeanResp{lg}, squeeze(nanmean(A(:,:,:),2))'];
    end
    
    StartVect = mean(MeanResp{lg}(1:2,:));
    StopVect = mean(MeanResp{lg}(end-1:end,:));
    StartVect = mean([StartVect;StopVect]);
    
    subplot(2,2,lg)
    TempRi=  corrcoef((MeanResp{lg}-repmat(StartVect,27,1))');
    TempRi = TempRi-diag(diag(TempRi));
    imagesc(TempRi)
    caxis([-0.5 0.7])
    axis xy
    
    
    subplot(2,2,lg+2)
    TempRi=  corrcoef((MeanResp{lg}-repmat(StopVect,27,1))');
    TempRi = TempRi-diag(diag(TempRi));
    imagesc(TempRi)
    caxis([-0.5 0.7])
    axis xy
    
end


