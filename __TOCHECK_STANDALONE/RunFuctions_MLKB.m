%RunFuctions_MLKB
res=pwd;
%% ------------------------------------------------------------------------
% ---------------------------  USEFUL -------------------------------------

if 0
    PathForExperimentsML.m
    listLFP_to_InfoLFP_ML.m
end


%% effet de la stim sur theta
if 0
    clear stim LFP lfp
    SetCurrentSession
    stim=GetEvents('51')*1E4;
    if issorted(stim)
        stim=tsd(stim,stim);
    end
    load('LFPData.mat')
    lfp=LFP{1};
    
    figure, [fh, rasterAx, histAx, matVal1] = ImagePETH(lfp, stim, -5000, +5000,'BinSize',1);
    rg=Range(matVal1,'s');
    dt=Data(matVal1);
    
    %figure('Color',[1 1 1]),
    plot(rg*1E3,mean(dt,2),'Linewidth',2,'Color','b')
    hold on, plot(rg*1E3,mean(dt,2)+stdError(dt')','k')
    hold on, plot(rg*1E3,mean(dt,2)-stdError(dt')','k')
    
    hold on, line([0 0],[min(mean(dt,2)),max(mean(dt,2))],'Color','r','Linewidth',2); a=0;
    for i=1:14
        a=a+72/10;
        hold on, line([a a],[min(mean(dt,2)),max(mean(dt,2))],'Color','r');
    end
    xlabel('Time around MFB stimulation (ms)')
    title(res(max(strfind(res,'Mouse')):end))
end

%% ------------------------------------------------------------------------
% -------------------------------------------------------------------------
% ------------------------      Processing     ----------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

    % 1- ComputeTrackingAndImmobility.m
    % 2- makeDataBulbe.m or (CodeBulbRespiML for plethysmo)
    % 3- Add path in PathForExperimentsML.m

if 0
    % follow those steps:
    % 1- ComputeTrackingAndImmobility.m
    a=0;
    a=a+1; PathTosave{a}='/media/DataMOBsRAID5/ProjetSommeil/ManipeManual/Mouse107/20140113/ICSS-Mouse-107-13012014-wideband';
    a=a+1; PathTosave{a}='/media/DataMOBsRAID5/ProjetSommeil/ManipeManual/Mouse109/20140113/ICSS-Mouse-109-13012014-wideband';
    a=a+1; PathTosave{a}='/media/DataMOBsRAID5/ProjetSommeil/ManipeManual/Mouse109/20140113/ICSS-Mouse-109-13012014-wideband/Ref_Tracking1to8';
    for i=1:length(PathTosave)
        
        cd(PathTosave{i})
        try 
            ComputeTrackingAndImmobility;
        catch
            disp('Problem with ComputeTrackingAndImmobility');
        end
        close all
        
        if 0
            n=input('Enter number of files.avi (loop): ');
            for i=1:n
                filename_tosave=input('filetosave: ','s');
                load([filename_tosave,'.mat']);
                Pos(:,4)=ones(size(Pos,1),1);
                Pos(isnan(Pos(:,2)),4)=zeros(sum(isnan(Pos(:,2))),1);
                save(filename_tosave,'-append','Pos')
                file = fopen([filename_tosave,'.pos'],'w');
                for i = 1:length(Pos),
                    fprintf(file,'%f\t',Pos(i,2));
                    fprintf(file,'%f\t',Pos(i,3));
                    fprintf(file,'%f\n',Pos(i,4));
                end
                fclose(file);
            end
        end
        
        
    end
                  
    

end


 
%% ------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -----------------------      SleepScoring     ---------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

%% SWS1hEpoch
if 0
    SleepPeriod=[0 60*60];%time in second
    Dir=PathForExperimentsML('BASAL');
    for man=1:length(Dir.path)
        cd(Dir.path{man})
        disp(Dir.path{man})
        clear SWSEpoch Clen ste sti index restrictPeriod SWS1hEpoch
        load('StateEpoch.mat','SWSEpoch')
        ste=Stop(SWSEpoch,'s');
        sti=Start(SWSEpoch,'s');
        Clen=cumsum(ste-sti);
        index=[min(find(Clen>SleepPeriod(1))),max(find(Clen<SleepPeriod(2)))];
        try restrictPeriod=intervalSet(sti(index(1))*1E4,ste(index(2))*1E4); catch, restrictPeriod=intervalSet([]);end
        SWS1hEpoch=and(SWSEpoch,restrictPeriod);
        save('SWS1hEpoch.mat','SWS1hEpoch','SleepPeriod')
        disp(['SWS1hEpoch = ',num2str(sum(Stop(SWS1hEpoch,'s')-Start(SWS1hEpoch,'s'))),'s'])
    end
end

%% run Compute_RatioSleepML
if 0
    Compute_RatioSleepML('None',1,1)
    Compute_RatioSleepML('None',0,1)
end

%% run ParcoursSleepStages

if 0
    ParcoursSleepStages;
end

%% Run Generate delta, Spindles and ripples 
if 0
    
    NameDir={'BASAL'};%'PLETHYSMO' 'CANAB' 'DPCPX'
    for i=1:length(NameDir)
        Dir=PathForExperimentsML(NameDir{i});
        
        for man=1:length(Dir.path)
            disp('  ')
            cd(Dir.path{man})
            GenerateDeltaSpindlesRipplesML(Dir.path{man})
        end
    end
    
end

%% Run PETHSpindlesRipplesML
if 0
    namedFoldersave='/media/DataMOBsRAID5/ProjetAstro/AnalyseSpindlesRipplesML';
    
    NameDir={'BASAL'}; %'PLETHYSMO' 'CANAB' 'DPCPX'
    for i=1:length(NameDir)
        Dir=PathForExperimentsML(NameDir{i});
        
        for man=1:length(Dir.path)
            if strcmp(NameDir{i},'PLETHYSMO')
                nameMouseDay=['Plethysmo',Dir.path{man}(max(strfind(Dir.path{man},'Mouse')):end)]; nameMouseDay(strfind(nameMouseDay,'/'))='-';
            else
                nameMouseDay=Dir.path{man}(max(strfind(Dir.path{man},'BULB'))+5:end);
            end
            
            try
                PETHSpindlesRipplesML(Dir.path{man});
                numF=gcf; saveFigure(numF,['SpindlesRipples',nameMouseDay],namedFoldersave);close
            catch
                disp(' -> problem')
            end
        end
    end
    
end


%% Run CoordineRipplesSpindles
if 0
    namedFoldersave='/media/DataMOBsRAID5/ProjetAstro/AnalyseSpindlesRipplesML';
    NameDir={'BASAL' };%'PLETHYSMO' 'CANAB' 'DPCPX'
    %NameDir={'CANAB'};
    ScriptCoordineRipplesSpindles(namedFoldersave,NameDir);
    
end


%% number of Ripples and Spindles
if 0
    
    CountRipplesSpindlesDeltaML('BASAL');
end

%% plot Ripples power hilbert...
if 0
    load('/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013/LFPData/LFP8.mat')
    epoch=IntervalSet(1E4*(89*60+14),1E4*(89*60+16));
    Filsp=FilterLFP(Restrict(LFP,epoch),[120 200],1024);
    HilRip=hilbert(Data(Restrict(Filsp,epoch)));
    PowerRip=abs(HilRip);
    
    figure('Color',[1 1 1]), plot(Range(Restrict(LFP,epoch),'s'),Data(Restrict(LFP,epoch)))
    hold on, plot(Range(Restrict(Filsp,epoch),'s'),1E4+Data(Restrict(Filsp,epoch)),'Color','k')
    hold on, plot(Range(Restrict(LFP,epoch),'s'),12E3+1.5*PowerRip,'Color','r')
    legend({'HPC row LFP','Filtered [120 200]','Hilbert transform'})
end
%% ------------------------------------------------------------------------
% -------------------------------------------------------------------------
% ------------------------      Spectrum      -----------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

%% Check on channelToAnalyze
if 0
    Dir=PathForExperimentsML('BASAL');
    Structure={'Bulb_deep','dHPC_deep','PaCx_deep','PaCx_sup','PFCx_deep','PFCx_sup'};
    for man=1:length(Dir.path)
        disp(['     * * * ',Dir.path{man}(max(strfind(Dir.path{man},'Mouse')):end),' * * *'])
        for stru=1:length(Structure)
            cd(Dir.path{man})
            try 
                
            catch
                disp([Structure{stru},'Not defined ! please enter channel to Analyse '])
                keyboard;
            end
        end
    end
    
end

%% SlowOscillationsML

if 0
    Dir=PathForExperimentsML('BASAL');
    Structure={'PaCx','PFCx','Bulb','dHPC'};
    depth={'deep','sup'};
    for man=1:length(Dir.path)
        
        disp(['     * * * ',Dir.path{man}(max(strfind(Dir.path{man},'Mouse')):end),' * * *'])
        for stru=1:length(Structure)
            for dp=1:length(depth)
                disp([Structure{stru},'_',depth{dp}])
                try
                    SlowOscillationsML(Dir.path{man},Structure{stru},depth{dp}); 
                    close
                catch
                    disp('problem')
                end
            end
        end
    end
end
%% Run LFPspectrum_StrainsML_new

if 1
    NameDir={'PLETHYSMO'};%  'BASAL''DPCPX' 'CANAB' 
    NameInjectionEpoch={'PreEpoch'};%,{'VEHEpoch' 'CPEpoch' }
    NameStructures={'Bulb'};%'dHPC' 'PaCx'  'PFCx' 'Bulb' 'NormRespiTSD'
    NameEpochs={'MovEpoch','SWSEpoch','REMEpoch'};%,'SWS1hEpoch','and(ThetaEpoch,MovEpoch)'...
        %'and(SniffEpoch,MovEpoch)','and(SniffEpoch,ImmobEpoch)','and(BasalBreathEpoch,MovEpoch)','and(BasalBreathEpoch,ImmobEpoch)',...
        %'and(ThetaEpoch,SniffEpoch)','and(ThetaEpoch,BasalBreathEpoch)'};
    
    %option={'deep' 'sup'};
    option={'deep' };
    clean=0;%clean=[0 1];
    for d=1:length(NameDir)
        for o=1:length(option)
            for i=1:length(NameStructures)
                for nn=1:length(NameInjectionEpoch)
                    for c=1:length(clean)
                        for nE=1:length(NameEpochs)
                            disp(' ');disp(' ');disp(' ')
                            disp([' * * * ',NameDir{d},' ',NameStructures{i},'_',option{o},' ',NameEpochs{nE},' * * * '])
                            LFPspectrum_StrainsML_new(NameDir{d},NameStructures{i},NameEpochs{nE},clean(c),option{o},[0 20],NameInjectionEpoch{nn});
%                             if strcmp(NameDir{d},'PLETHYSMO') && strcmp(NameEpochs{nE},'MovEpoch')
%                                 LFPspectrum_StrainsML_new(NameDir{d},NameStructures{i},'MovEpoch',clean(c),option{o},[2 3.5],NameInjectionEpoch{nn});
%                                 LFPspectrum_StrainsML_new(NameDir{d},NameStructures{i},'MovEpoch',clean(c),option{o},[5 10],NameInjectionEpoch{nn});
%                             end
                        end
                    end
                end
                %close all
            end
            
        end
    end
    
end
% LFPspectrum_StrainsStatsML

%% ComputeSpectrogram_newML
if 0
    a=0;
   a=a+1; direct{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse079/MNT/Day2/OPTO-Mouse-79-16072013';
   a=a+1; direct{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse079/MNT/Day3/OPTO-Mouse-79-17072013';
   a=a+1; direct{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse079/MNT/Day4/OPTO-Mouse-79-18072013';
   a=a+1; direct{a}='/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse079/MNT/Day5/OPTO-Mouse-79-19072013';
   [params,movingwin,suffix]=SpectrumParametersML('low');
   for a=1:length(direct)
       cd(direct{a})
       S={};cellnames={}; save SpikeData S cellnames
       clear InfoLFP setCu
       load('/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse079/MNT/Day1/OPTO-Mouse-79-15072013/LFPData/InfoLFP.mat')
       mkdir('LFPData')
       save LFPData/InfoLFP InfoLFP
       try 
           makeDataBulbe;
       catch
           disp('Problem with makeDataBulbe')
       end
       ComputeSpectrogram_newML(movingwin,params,InfoLFP,'VTA','All',suffix);
   end
end



%% ------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -----------------------      RESPIRATION      ---------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

%% run CodeBulbRespiML
if 0
    
    % in each mouse folder, run for processing:
    ComputeTrackingAndImmobility % processing, tracking
    CodeBulbRespiML % processing, Plethysmo signal + LFP mc_rack
       % fait appel à 
        PlethysmoSignalML % processing, normalize plethysmo signal
        Plot_RespiLFP_ML % plot signal respi + LFP
    
    FindRespiAndMovEpochs % after processing
    
    % on DirPath 'PLETHYSMO'
    DistributionRespiFrequency % distrib + spectre respi /strains
    CodeBulbAnalyRespiML % spectre respi + LFP /strains
    PlotBilanRespiML % bar plot + stats for respi parameters
    plotRespiLFPML % plot all signal respi + LFP
    RespiLFP_MLOneMore % spectre for PLETHYSMO path
    LFP_by_RespiFreqML
    LFP_by_RespiFreqML_bis
    LFPspectrum_StrainsML_new
end
%% run Run_ZAPRespi2_ML

if 0
    NameStates={'SWSEpoch' 'REMEpoch' 'MovEpoch' };
    NameTypeFreq={'Delta'};%'HighGamma' 'LowGamma' 
    for i=1:length(NameTypeFreq)
        for j=1:length(NameStates)
            Run_ZAPRespi2_ML(NameStates{j},NameTypeFreq{i});
            close all;
        end
    end
end

 %% run ParcoursCohPlethy
 
 % before, distinguish OB_Epochs
 if 0
     NameDir={'PLETHYSMO' 'BASAL'};
     for i=1:length(NameDir)
        Dir=PathForExperimentsML(NameDir{i});
        for man=1:length(Dir.path)
            disp(' ');disp(Dir.path{man})
            try,Distinct_OB_Epochs_SB_ML(Dir.path{man}); catch,disp(' FAILED');end
        end
     end
 end
 
 
 if 0
     nameStruct={'Bulb' 'PFCx' 'Respi'}; %'PaCx' 'dHPC' 
     nameprof={'deep', 'sup'}; 
     nameDir={'PLETHYSMO'};% 'BASAL'
     for dd=1:length(nameDir)
         for pp=1:length(nameprof)
             for s1=2:length(nameStruct)
                 for s2=1:length(nameStruct)
                     if s1~=s2
                         
                         disp([nameStruct{s1},' - ',nameStruct{s2}])
                         
                         ParcoursCohPlethy_ML(nameDir{dd},nameStruct{s1},nameStruct{s2},1,nameprof{pp});
                     end
                 end
             end
         end
     end
 end
 
 %% RespiTrigLFPML
 if 0
     nameStruct={'Bulb_deep'}; % name of ChannelsToAnalyse
     nameEpochs={'MovEpoch' 'REMEpoch' 'SWSEpoch'};
     for s=1:length(nameStruct)
         for nn=1:length(nameEpochs)
             RespiTrigLFPML('PLETHYSMO',nameStruct{s},nameEpochs{nn},500);
         end
     end
 end
 
 
 %% run RespiModulatesGamma_ML
 
 if 0
     nameStruct={'Bulb' 'PFCx' 'PaCx' 'dHPC'};
     nameprof={'deep', 'sup'};
     %nameEpochs={'MovEpoch' 'REMEpoch' 'SWSEpoch' 'S12' 'S34'};
     nameEpochs={'MovEpoch' 'WakeEpoch'};
     for p=1:length(nameprof)
         for s=1:length(nameStruct)
             for nn=1:length(nameEpochs)
                 disp(' ')
                 disp([nameStruct{s},'_',nameprof{p},'  -',nameEpochs{nn}])
                 RespiModulatesGamma_ML([nameStruct{s},'_',nameprof{p}],nameEpochs{nn},8,1);
             end
         end
     end
 
 end

 
 %% run RespiModulatesEvents_ML
 
 if 0
     
     nameStruct={'PFCx' 'PaCx'};
     nameprof={'Deep', 'Sup'};
     NameEvent={'Spindles' 'DeltaWaves'};
     
     for p=1:length(nameprof)
         for s=1:length(nameStruct)
             for e=1:length(NameEvent)
                 disp([' * * ',NameEvent{e},' ',nameStruct{s},nameprof{p},' * * '])
                 RespiModulatesEvents_ML([nameStruct{s},nameprof{p}],NameEvent{e},[2.5 3],1,0);
                 %RespiModulatesEvents_ML([nameStruct{s},nameprof{p}],NameEvent{e},[2.5 3],0,1);
             end
         end
     end
 end
 
%% look at Delta waves, average respi

if 0
    Dir=PathForExperimentsML('PLETHYSMO');
    for man=1:length(Dir.path)
        cd(Dir.path{man})
        disp(Dir.path{man}(max(strfind(Dir.path{man},'Mouse')):end))
        RespirationByDeltaML;
    end
end
 
%% ------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -----------------------      STIMULATION      ---------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

%% Run OptoStim_trigLFP_ML
if 0
    OptoStim_trigLFP_ML
end

%% Run HCStim_trigLFP_ML
% + plot Ripples VS-VTA-dHPC
if 0
    HCStim_trigLFP_ML
end

