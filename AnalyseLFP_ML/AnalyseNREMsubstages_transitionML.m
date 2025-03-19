%AnalyseNREMsubstages_transitionML.m

% list of related scripts in NREMstages_scripts.m 

%%
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    Dir1=PathForExperimentsDeltaSleepNew('BASAL');
    Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/AvSpectrum';
analyname='AnalySubStagesTransML.mat';
freq=0.1:20/200:20; %200 values
varNames={'SpPF','SpOB','SpHPC'};

do_dKO=0;
if do_dKO
    Dir=PathForExperimentsML('BASAL');
    Dir=RestrictPathForExperiment(Dir2,'Group','WT');
    analyname='AnalySubStagesTransML-dKO.mat';
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< LOAD SPECTRUM <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
try
    load([res,'/',analyname],'MATz','MAT','freq','varNames','NamesStages','tb');
    disp([analyname,' already exists... has been loaded'])
    SPtrans;
    
catch
    MAT={};
    
    for man=1:length(Dir.path);%length(Dir.path)
        cd(Dir.path{man})
        disp(Dir.path{man})
        
         %%%%%%%%%%%%%%%%%%%% GET Substages %%%%%%%%%%%%%%%%%%%%%%%%
        clear WAKE REM N1 N2 N3
        disp('Gettinf Substages...')
        try
        [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;close
        resNamesEp={'WAKE','REM','N1','N2','N3'};
        Stages=[];
        for n=1:length(resNamesEp)
            eval(['epoch=',resNamesEp{n},';'])
            Stages=[Stages; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];
        end
        Stages=sortrows(Stages,1);
        s_mat=[Stages,[0;Stages(1:end-1,3)]];
        end
        
        %%%%%%%%%%%%%%%%%%%% GET PFCx spectrum %%%%%%%%%%%%%%%%%%%%%%%%
        clear SpPF channel Sp t f
        disp('Loading PFCx SpectrumDataL, WAIT...')
        load('ChannelsToAnalyse/PFCx_deep.mat','channel');
        eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'',''Sp'',''t'',''f'')'])
        SpPF=tsd(t*1E4,Data(Restrict(tsd(f,Sp'),ts(freq)))');
        
        %%%%%%%%%%%%%%%%%%%% GET OB spectrum %%%%%%%%%%%%%%%%%%%%%%%%
        clear SpOB channel Sp t f
        disp('Loading OB SpectrumDataL, WAIT...')
        load('ChannelsToAnalyse/Bulb_deep.mat','channel');
        eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'',''Sp'',''t'',''f'')'])
        SpOB=tsd(t*1E4,Data(Restrict(tsd(f,Sp'),ts(freq)))');
        
        %%%%%%%%%%%%%%%%%%%% GET HPC spectrum %%%%%%%%%%%%%%%%%%%%%%%%
        clear SpHPC channel Sp t f
        disp('Loading HPC SpectrumDataL, WAIT...')
        try
            load('ChannelsToAnalyse/dHPC_rip.mat','channel');
        catch
            channel=[];
        end
        try
            if isempty(channel), load('ChannelsToAnalyse/dHPC_deep.mat','channel');end
            eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'',''Sp'',''t'',''f'')'])
            SpHPC=tsd(t*1E4,Data(Restrict(tsd(f,Sp'),ts(freq)))');
        catch
            SpHPC=tsd([],[]);
        end
        
        %%%%%%%%%%%%%%%%%%%% Compute %%%%%%%%%%%%%%%%%%%%%%%%
        clear SleepVar
        for v=1:length(varNames)
            eval(['SleepVar{',num2str(v),'}=',varNames{v},';'])
            figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.05 0.4 0.8]); num(v)=gcf;
            cl{v}=[];
        end
        disp('Calculating spectrum on all transition...')
        
        for n_i=1:length(resNamesEp)
            for n_j=1:length(resNamesEp)
                if n_i~=n_j
                    ind=find(s_mat(:,4)==n_i & s_mat(:,3)==n_j);
                    if length(ind)>3
                        for v=1:length(varNames)
                            try
                            [M,S,tb]=AverageSpectrogram(SleepVar{v},freq,ts(s_mat(ind,1)*1E4),200,100,0);
                            MAT{n_i,n_j,v,man}=M;
                            %display
                            figure(num(v)), subplot(length(resNamesEp),length(resNamesEp),(n_i-1)*length(resNamesEp)+n_j)
                            imagesc(tb/1E3,freq,M), axis xy; title(sprintf([resNamesEp{n_i},' -> ',resNamesEp{n_j},' n=%d'],length(ind)))
                            cl{v}=[cl{v},caxis]; hold on, line([0 0],ylim,'Color','w'); 
                            if n_i==1 && n_j==3, title({Dir.path{man},' ',[resNamesEp{n_i},' -> ',resNamesEp{n_j}]});end
                            end
                        end
                    end
                end
            end
        end
        for v=1:length(varNames)
            figure(num(v)), 
            for n_i=1:length(resNamesEp)
                for n_j=1:length(resNamesEp)
                    subplot(length(resNamesEp),length(resNamesEp),(n_i-1)*length(resNamesEp)+n_j)
                    try, caxis([min(cl)*1.2,max(cl)*0.8]);  end
                end
            end
            colorbar;
            saveFigure(gcf,['NREMSubStagesTansition',num2str(man),'_',Dir.name{man},varNames{v}],FolderToSave)
            close;
        end
        disp('Done')
    end
    disp(['Saving in ',res,'/',analyname])
    save([res,'/',analyname],'MAT','freq','varNames','NamesStages','tb');
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< SUBSTAGES mean SPECTRUM <<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
figure('Color',[1 1 1]) 
L=length(resNamesEp);
v=1;cl=[];
for n_i=1:L
    for n_j=1:L
        Msum=zeros(200,101);
        for man=1:13%length(Dir.path)
            try
                M=MAT{n_i,n_j,v,man};
                %Msum=Msum+zscore(M);
                Msum=Msum+M;
            end
        end
        %subplot(L,L,L*(n_i-1)+n_j);imagesc(tb/1E3,freq,zscore(Msum)); axis xy
        %subplot(L,L,L*(n_i-1)+n_j);imagesc(tb/1E3,freq,zscore(Msum')'); axis xy 
        %subplot(L,L,L*(n_i-1)+n_j);imagesc(tb/1E3,freq,Msum); axis xy
        subplot(L,L,L*(n_i-1)+n_j);imagesc(tb/1E3,freq,10*log10(Msum)); axis xy
        title([resNamesEp{n_i},'->',resNamesEp{n_j}])
        xlim([-5 5])
        if n_i~=n_j
        cl=[cl,caxis];
        end
    end
end
%%
for n_i=1:length(resNamesEp)
    for n_j=1:length(resNamesEp)
        subplot(L,L,L*(n_i-1)+n_j)
        try, caxis([min(cl)*0.9,max(cl)*0.95]);  end
        hold on, line([0 0],ylim,'Color','k')
    end
end

%%
L=5; % first five nameEpochs
colori=[0.7 0.2 0.8; 1 0 1 ;0.8 0 0.7 ; 0.1 0.7 0 ; 0.5 0.2 0.1];
for ss=1:length(StructureName)
    figure('Color',[1 1 1]); numF(ss)=gcf;
    for i=1:L
        
        figure(numF(1)), subplot(2,3,i), hold on,
        temp1=SP{i};
        temp1(abs(temp1)==inf)=NaN;
        for man=1:length(Dir.path)
            plot(freq,temp1(man,:),'k')
        end
        plot(freq,nanmean(temp1,1),'r','Linewidth',2)
        title(nameEpochs{i})
        
        
        subplot(2,3,6), hold on,
        plot(freq,nanmean(temp1,1),'Linewidth',2,'Color',colori(i,:))
    end
    legend(nameEpochs{1:L})
    title(['Mean ',StructureName{ss},' spectrum across stages'])
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< Transition SPECTRUM <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
L=5;
ttim=-win_transi:2*win_transi/(5*2*win_transi-1):win_transi;
for ss=1:length(StructureName)
    %for man=1:length(Dir.path),  figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.05 0.4 0.8]); numF(man)=gcf;end
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.05 0.4 0.8]); Fall=gcf;
    for i=1:L
        for j=1:L
            DT=nan(win_transi*10,261);a=0;
            for man=1:length(Dir.path)
                DTep=SPtrans{i,j,man};
                DTep(abs(DTep)==inf)=NaN;
                % plot mean sp for each mouse
                if 0
                figure(numF(man)),subplot(L,L,L*(j-1)+i),
                imagesc(ttim,f,DTep(:,1:261)'), axis xy,
                title([nameEpochs{i},'->',nameEpochs{j},', n=',num2str(num{i,j,man})])
                line([0 0],ylim,'Color',[0.5 0.5 0.5])
                if i+j==2, text(0,30,Dir.path{man});end
                end
                for li=1:size(DT,1)
                    if size(DTep,2)==326
                    else
                        DT(li,:)=nansum([DT(li,1:261);DTep(li,1:261)],1);
                    end
                end
                a=a+1;
            end
            figure(Fall),subplot(L,L,L*(j-1)+i),
            imagesc(ttim,f,DT(:,1:261)'), axis xy,
            title([nameEpochs{i},'->',nameEpochs{j}])
            line([0 0],ylim,'Color',[0.5 0.5 0.5])
        end
    end
    
%     saveFigure(Fall,['NREMSubStagesTansitionALL_',date],res)
%     saveFigure(Fall,['NREMSubStagesTansitionALL_',date],FolderToSave)
%     for man=1:length(Dir.path)
%         saveFigure(Fall,['NREMSubStagesTansition_',date,'_',num2str(man)],res)
%     end
end








% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< SUBSTAGES DURATION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
disp(' '); disp('...Calculating Stage duration')
% compare with sws
isws=find(strcmp('SWS',nameEpochs));
is=find(strcmp('TOTSleep',nameEpochs));
indsws=[]; 
for op=1:length(nameEpochs)
    if sum(strcmp({'N','R'},nameEpochs{op}(1))), indsws=[indsws,op];end
end

% length of substage epochs
MATDUR=nan(length(Dir.path),length(nameEpochs));
MATDURsws=MATDUR; MATDURs=MATDUR;
for man=1:length(Dir.path)
    clear tempsws temp temptot temps
    try
        tempsws=sum(Stop(MATEP{man,isws},'s')-Start(MATEP{man,isws},'s'));
        temps=sum(Stop(MATEP{man,is},'s')-Start(MATEP{man,is},'s'));
        for op=1:length(nameEpochs)
            temp=sum(Stop(MATEP{man,op},'s')-Start(MATEP{man,op},'s'));
            
            temptot=MATZT(man,2)-MATZT(man,1);
            if temptot>0
                MATDUR(man,op)=100*temp/temptot;
                if tempsws>0, MATDURsws(man,op)=100*temp/tempsws;end
                if temps>0, MATDURs(man,op)=100*temp/temps;end
            end
        end
    end
end
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



