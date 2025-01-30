clear all,
Files=PathForExperimentsEmbReact('UMazeCond');
SessionType{1} =  GetRightSessionsUMaze_SB('AllFreezingSessions');

MouseToAvoid=[431,117]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);

% Get average spectra
clear SaveSpec
Struc={'B','H','PFCx'};
StrucName={'Bulb','dHPC','PFCx'};
WndwSz=2*1e4; % size of little window to extract frequency data
LimFreq=20;
SaveFigName='/media/DataMOBsRAID/ProjectEmbReact/Figures/Sept2016/20160913/';

for ss=1
    clear SaveSpecNoShck SaveSpecShck SaveSpec
    for mm=1:size(Files.path,2)
        mm
        MouseName{mm}=num2str(Files.ExpeInfo{mm}{1}.nmouse);
        AvailStruc=Files.ExpeInfo{mm}{1}.RecordElecs.structure;AvailStruc=[AvailStruc{:}];
        if  not(isempty(findstr(AvailStruc,StrucName{ss})))
            for c=1:size(Files.path{mm},2)
                count1=1;count2=1;
                % Go to folder and load everything
                cd( Files.path{mm}{c})
                clear StimEpoch SleepyEpoch TotalNoiseEpoch
                load('behavResources_SB.mat')
                load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
                RemovEpoch=or(or(TTLInfo.StimEpoch,SleepyEpoch),TotalNoiseEpoch);
                load([Struc{ss},'_Low_Spectrum.mat'])
                Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                
                % On the safe side
                LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch;
                % Average Spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        SaveSpec{mm,1}(c,:)=nanmean((Data(Restrict(Sptsd,LitEp))));
                    else
                        SaveSpec{mm,1}(c,:)=nan(1,length(Spectro{3}));
                    end
                else
                    SaveSpec{mm,1}(c,:)=nan(1,length(Spectro{3}));
                    
                end
                
                %Individual Spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        for s=1:length(Start(LitEp))
                            dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                            Str=Start(subset(LitEp,s));
                            if  dur<3.5*1e4 & dur>1.5*1e4
                                SaveSpecNoShck{mm,c}(count1,:)=nanmean(Data(Restrict(Sptsd,subset(LitEp,s))));
                                count1=count1+1;
                            else
                                numbins=round(dur/WndwSz);
                                epdur=dur/numbins;
                                for nn=1:numbins
                                    SaveSpecNoShck{mm,c}(count1,:)=nanmean(Data(Restrict(Sptsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
                                    count1=count1+1;
                                end
                                
                            end
                        end
                    end
                end
                
                % On the shock side
                LitEp=and(Behav.FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch;
                % Average Spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        SaveSpec{mm,2}(c,:)=nanmean((Data(Restrict(Sptsd,LitEp))));
                    else
                        SaveSpec{mm,2}(c,:)=nan(1,length(Spectro{3}));
                    end
                else
                    SaveSpec{mm,2}(c,:)=nan(1,length(Spectro{3}));
                    
                    
                end
                
                % Individual spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        for s=1:length(Start(LitEp))
                            dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                            Str=Start(subset(LitEp,s));
                            if  dur<3.5*1e4 & dur>1.5*1e4
                                SaveSpecShck{mm,c}(count2,:)=nanmean(Data(Restrict(Sptsd,subset(LitEp,s))));
                                count2=count2+1;
                            else
                                numbins=round(dur/WndwSz);
                                epdur=dur/numbins;
                                for nn=1:numbins
                                    SaveSpecShck{mm,c}(count2,:)=nanmean(Data(Restrict(Sptsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
                                    count2=count2+1;
                                end
                                
                            end
                        end
                    end
                end
                
                
            end
        else
            SaveSpec{mm,1}=[];
            SaveSpec{mm,2}=[];
            for c=1:size(Files.path{mm},2)
                SaveSpecShck{mm,c}=[];
                SaveSpecNoShck{mm,c}=[];
            end
        end
    end
    keyboard
    
    % Look at distributions of peak frequencies
    f=Spectro{3};
    ValsToTest=[1:0.5:8];
    clear ROCBeta ROCAlpha 
    for mm=1:size(Files.path,2)
        fShck=[];fNoShck=[];
        mm
        for c=1:size(Files.path{mm},2)
            if not(isempty(SaveSpecNoShck{mm,c}))
                for k=1:size(SaveSpecNoShck{mm,c},1)
                    [val,ind]=max(SaveSpecNoShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                    fNoShck=[fNoShck,f(ind)];
                end
            end
        end
        for c=1:size(Files.path{mm},2)
            try
                if not(isempty(SaveSpecShck{mm,c}))
                    for k=1:size(SaveSpecShck{mm,c},1)
                        [val,ind]=max(SaveSpecShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                        fShck=[fShck,f(ind)];
                    end
                end
            end
        end
        fShck = fShck';
        fNoShck = fNoShck';
        if length(fShck)>10 & length(fNoShck)>10
            
            alpha=[];
            beta=[];
            minval=min([fShck;fNoShck]);
            maxval=max([fShck;fNoShck]);
            delval=(maxval-minval)/20;
            for z=ValsToTest
                alpha=[alpha,sum(fShck>z)/length(fShck)];
                beta=[beta,sum(fNoShck>z)/length(fNoShck)];
            end
            [val,ind]=min(alpha-beta);
            RocVal(mm)=sum(alpha-beta)/length(beta)+0.5;
            ROCAlpha(mm,:)=alpha;
            ROCBeta(mm,:)=beta;
        else
            RocVal(mm) = NaN;
        end
    end
    
end

figure
NewBeta=[0:0.01:1];

for m=1:size(ROCBeta,1)
    if RocVal(m)>0
    OldBeta=ROCBeta(m,:);
    OldAlpha=ROCAlpha(m,:);
    
    while sum(OldBeta==1)>1
        OldAlpha(find(OldBeta==1,1,'last'))=[];
        OldBeta(find(OldBeta==1,1,'last'))=[];
    end
    
    while sum(OldBeta==0)>1
        OldAlpha(find(OldBeta==0,1,'first'))=[];
        OldBeta(find(OldBeta==0,1,'first'))=[];
    end
    
    [C,IA,IC] = unique(OldBeta);
    OldAlpha=OldAlpha(IA);
    OldBeta=OldBeta(IA);
    NewAlpha(m,:)=interp1(OldBeta,OldAlpha,NewBeta);
    else
        NewAlpha(m,:) = nan(1,length(NewBeta));
    end
end

[hl,hp]=boundedline(NewBeta,nanmean(NewAlpha),[stdError(NewAlpha);stdError(NewAlpha)]','k');
xlabel('False Positive rate')
ylabel('False Negative rate')
line(xlim,ylim,'linewidth',1,'color','k','linestyle',':')
set(gca,'Linewidth',2,'FontSize',20)

A = {RocVal};
MakeSpreadAndBoxPlot_SB(A,{[0.6 0.6 0.6]},1)
hold on
line(xlim,[0.5 0.5],'linewidth',1,'color','k','linestyle',':')
ylim([0 1])
xlim([0.5 1.5])
[p,h,stats] = signrank(A{1})
sigstar({{0.8,1.2}},p)
set(gca,'Linewidth',2,'FontSize',20)

