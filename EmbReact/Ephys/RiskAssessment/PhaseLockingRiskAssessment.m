clear all
clear ZoneTime
PerDur=4*1e4; % in 1/100th seconds 
StepBackFromStart=0.5*1e4;
NumBins=80;
Smax=log(NumBins);
SessTypes={'TestPost','UMazeCond','TestPost_EyeShock','UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock'};
Structures={'B','P','H'};
StructurePairs={'B _ P','B _ H','P _ H'};
PhaseCalc={'PT','WV'};

for TypeOfEvent=2
    clear RiskAssess
    for ss=1:length(SessTypes)
        Files=PathForExperimentsEmbReact(SessTypes{ss});
        MouseToAvoid=[560,117,431]; % mice with noisy data to exclude
        Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
        disp(SessTypes{ss})
        for mm=1:length(Files.path)
            for c=1:length(Files.path{mm})
                disp(Files.path{mm}{c})
                cd(Files.path{mm}{c})
                
                clear Behav
                load('behavResources_SB.mat')
                
                if  sum(Behav.RAUser.ToShock==TypeOfEvent)>0
                    clear Phase_unwrapped
                    load('InstFreqAndPhase_B.mat')
                    % plot(Range(LocalPhase.PT,'s'),Data(LocalPhase.PT),'b'), hold on
                    Phase_unwrapped.PT.B=tsd(Range(LocalPhase.PT),unwrap(mod(Data(LocalPhase.PT)-pi/2,2*pi)-pi));
                    Phase_unwrapped.WV.B=tsd(Range(LocalPhase.WV),unwrap(mod(Data(LocalPhase.WV)-pi/2,2*pi)-pi));
                    load('InstFreqAndPhase_H.mat')
                    % plot(Range(LocalPhase.PT,'s'),Data(LocalPhase.PT),'c')
                    Phase_unwrapped.PT.H=tsd(Range(LocalPhase.PT),unwrap(mod(Data(LocalPhase.PT)-pi/2,2*pi)-pi));
                    Phase_unwrapped.WV.H=tsd(Range(LocalPhase.WV),unwrap(mod(Data(LocalPhase.WV)-pi/2,2*pi)-pi));

                    load('InstFreqAndPhase_PFCx.mat')
                    % plot(Range(LocalPhase.PT,'s'),Data(LocalPhase.PT),'r')
                    Phase_unwrapped.PT.P=tsd(Range(LocalPhase.PT),unwrap(mod(Data(LocalPhase.PT)-pi/2,2*pi)-pi));
                    Phase_unwrapped.WV.P=tsd(Range(LocalPhase.WV),unwrap(mod(Data(LocalPhase.WV)-pi/2,2*pi)-pi));

                    Strt=Start(Behav.RAEpoch.ToShock);
                    Stp=Start(Behav.RAEpoch.ToShock);
                    
                    % Trigger on the null derivative (to realign as
                    % well as possible)
                    SmooDiffLinDist=tsd(Range(Behav.LinearDist),[0;diff(runmean(Data(Behav.LinearDist),20))]);
                    EpToUse=subset(Behav.RAEpoch.ToShock,find(Behav.RAUser.ToShock==TypeOfEvent));
                    tpsout=FindClosestZeroCross(Start(EpToUse)-StepBackFromStart,SmooDiffLinDist,1);

                    
                    for int=1:length(tpsout)
                        clear PhaseDiff
                        for per=1:4
                            Period=intervalSet(tpsout(int)+(PerDur*(per-3)),tpsout(int)+(PerDur*(per-2)));
                            for st=1:length(StructurePairs)
                                for meth=1:length(PhaseCalc)
                                PhaseDiff=mod(Data(Restrict(Phase_unwrapped.(PhaseCalc{meth}).(StructurePairs{st}(1)),Period))-Data(Restrict(Phase_unwrapped.(PhaseCalc{meth}).(StructurePairs{st}(3)),Period)),2*pi);
                                [Y1,X1]=hist(PhaseDiff,NumBins);
                                Y1=Y1/sum(Y1);
                                S=(Y1.*log(Y1)); % if Y1 has zero terms these will be 0 not inf
                                S(isnan(S))=0;
                                S=-nansum(S);
                                Index.Shannon.(PhaseCalc{meth}).(StructurePairs{st}){per}(mm,ss,int)=(Smax-S)/Smax;
                                Index.VectLength.(PhaseCalc{meth}).(StructurePairs{st}){per}(mm,ss,int)=sqrt(sum(cos(PhaseDiff)).^2+sum(sin(PhaseDiff)).^2)/length(PhaseDiff);
                                clear PhaseDiff
                                end 
                                
                                % Look at quality of the oscillation
                                for st = 1:length(StructurePairs)
                                    WV = Data(Restrict(Phase_unwrapped.WV.(Structures{st}),Period));
                                    PT = Data(Restrict(Phase_unwrapped.PT.(Structures{st}),Period));
                                    if length(PT)==499, PT(500)=PT(499); end
                                    if length(WV)==499, WV(500)=WV(499); end
                                Num = sqrt(diff(WV-PT).^2);
                                Denom = (sqrt(diff(WV).^2)+sqrt(diff(PT).^2))/2;
                                Err.(Structures{st}){per}(mm,ss,int) = nanmean(Num ./ Denom );
                                end

                            end
                        end
                    end
                    
                end
            end
        end
    end
end

%% error
StructurePairs={'B_P','B_H','P_H'};
StructurePairsLegend={'B/P','B/H','P/H'};
Time = [-6,-2,2,6];
for st=1:length(Structures)
    for per=1:4
        
        temp = Err.(Structures{st}){per};
        temp(temp==0)=NaN;
        MeanErr{st}(per,:)=squeeze((nanmean(nanmean(temp,2),3)));

        
    end
end


fig=figure;
subplot(121)
for st=1:3
errorbar(Time,nanmean((MeanErr{st})'),stdError((MeanErr{st}')),'linewidth',2), hold on
end
legend(Structures)
box off
ylabel('Error btw meths')

subplot(122)
for st=1:3
errorbar(Time,nanmean(nanzscore(MeanErr{st})'),stdError(nanzscore(MeanErr{st}')),'linewidth',2), hold on
end
box off
ylabel('Error btw meths-zscore')


%% WV
clear ShanMeanVal VectMeanVal
for per=1:4
    for st=1:length(StructurePairs)
        temp=Index.Shannon.WV.(StructurePairs{st}){per};
        temp(temp==0)=NaN;
        ShanMeanVal{st}(per,:)=squeeze((nanmean(nanmean(temp,2),3)));
        temp=Index.VectLength.WV.(StructurePairs{st}){per};
        temp(temp==0)=NaN;
        VectMeanVal{st}(per,:)=squeeze((nanmean(nanmean(temp,2),3)));
    end
end

fig=figure;
set(fig,'name','WV')
subplot(2,2,1)
for st=1:3
errorbar(Time,nanmean((ShanMeanVal{st})'),stdError((ShanMeanVal{st}')),'linewidth',2), hold on
end
legend(StructurePairsLegend)
ylabel('Shannon Ent')
box off

subplot(2,2,2)
for st=1:3
errorbar(Time,nanmean(nanzscore(ShanMeanVal{st})'),stdError(nanzscore(ShanMeanVal{st}')),'linewidth',2), hold on
end
ylabel('Shannon Ent-zscore')
box off

subplot(2,2,3)
for st=1:3
errorbar(Time,nanmean((VectMeanVal{st})'),stdError((VectMeanVal{st}')),'linewidth',2), hold on
end
ylabel('VectS Str')
box off

subplot(2,2,4)
for st=1:3
errorbar(Time,nanmean(nanzscore(VectMeanVal{st})'),stdError(nanzscore(VectMeanVal{st}')),'linewidth',2), hold on
end
ylabel('VectS Str-zscore')
box off


%% PT
fig=figure;
set(fig,'name','PT')

clear ShanMeanVal VectMeanVal
for per=1:4
    for st=1:length(StructurePairs)
        temp=Index.Shannon.PT.(StructurePairs{st}){per};
        temp(temp==0)=NaN;
        ShanMeanVal{st}(per,:)=squeeze((nanmean(nanmean(temp,2),3)));
        temp=Index.VectLength.PT.(StructurePairs{st}){per};
        temp(temp==0)=NaN;
        VectMeanVal{st}(per,:)=squeeze((nanmean(nanmean(temp,2),3)));
    end
end


subplot(2,2,1)
for st=1:3
errorbar(Time,nanmean((ShanMeanVal{st})'),stdError((ShanMeanVal{st}')),'linewidth',2), hold on
end
legend(StructurePairsLegend)
ylabel('Shannon Ent'), box off

subplot(2,2,2)
for st=1:3
errorbar(Time,nanmean(nanzscore(ShanMeanVal{st})'),stdError(nanzscore(ShanMeanVal{st}')),'linewidth',2), hold on
end
ylabel('Shannon Ent-zscore'), box off

subplot(2,2,3)
for st=1:3
errorbar(Time,nanmean((VectMeanVal{st})'),stdError((VectMeanVal{st}')),'linewidth',2), hold on
end
ylabel('VectS Str')
box off

subplot(2,2,4)
for st=1:3
errorbar(Time,nanmean(nanzscore(VectMeanVal{st})'),stdError(nanzscore(VectMeanVal{st}')),'linewidth',2), hold on
end
ylabel('VectS Str-zscore')
box off
