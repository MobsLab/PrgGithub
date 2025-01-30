clear all
SessionNames={'UMazeCond'};
FrezFreqlim=4;
for ss=1:length(SessionNames)
    SessionNames{ss}
    Dir=PathForExperimentsEmbReact(SessionNames{ss})
    for mouse=[16,17,18]
        AllSpec{mouse}=[];AllSpecHPC{mouse}=[];
        
        AllFzSpec{mouse}=[];
        for session=1:length(Dir.path{mouse})
            cd(Dir.path{mouse}{session})
            disp(Dir.path{mouse}{session})
            load('B_Low_Spectrum.mat')
            fLow=Spectro{3};
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            
            load('H_VHigh_Spectrum.mat')
            fhigh=Spectro{3};
            SptsdH=tsd(Spectro{2}*1e4,Spectro{1});
            
            load('behavResources.mat')
            
            %% UMaze
            %% On the safe side
            LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-intervalSet(Start(TTLInfo.StimEpoch),Start(TTLInfo.StimEpoch)+2*1e4);
            [AvSpectra.Safe{mouse,session},SpectraBySlice.Safe{mouse,session},SliceDur.Safe{mouse,session}]=CharacterizeSpectraEpoch(Sptsd,Spectro{3},LitEp,2);
            
            %% On the shock side
            LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{1},Behav.ZoneEpoch{4}))-intervalSet(Start(TTLInfo.StimEpoch),Start(TTLInfo.StimEpoch)+2*1e4);
            [AvSpectra.Shock{mouse,session},SpectraBySlice.Shock{mouse,session},SliceDur.Shock{mouse,session}]=CharacterizeSpectraEpoch(Sptsd,Spectro{3},LitEp,2);
            
            %% On the center side
            LitEp=and(Behav.FreezeEpoch,Behav.ZoneEpoch{3})-intervalSet(Start(TTLInfo.StimEpoch),Start(TTLInfo.StimEpoch)+2*1e4);
            [AvSpectra.Center{mouse,session},SpectraBySlice.Center{mouse,session},SliceDur.Center{mouse,session}]=CharacterizeSpectraEpoch(Sptsd,Spectro{3},LitEp,2);
            
            
            %% AllTogether
            LitEp=Behav.FreezeEpoch-intervalSet(Start(TTLInfo.StimEpoch),Start(TTLInfo.StimEpoch)+2*1e4);
            [AvSpectra.FZ{mouse,session},SpectraBySlice.FZ{mouse,session},SliceDur.FZ{mouse,session}]=CharacterizeSpectraEpoch(Sptsd,Spectro{3},LitEp,2);
            
            % Compare Power Above and Below 4Hz
            SpecTemp=Data(Sptsd);
            PowLow=nanmean(SpecTemp(:,find(fLow<1,1,'last'):find(fLow<4,1,'last'))')';
            PowHigh=nanmean(SpecTemp(:,find(fLow<4,1,'last'):find(fLow<8,1,'last'))')';
            ComparePowertsd=tsd(Range(Sptsd),PowLow-PowHigh);
            HighFreqFreez=and(thresholdIntervals(ComparePowertsd,0,'Direction','Below'),Behav.FreezeEpoch);
            HighFreqFreez=mergeCloseIntervals(HighFreqFreez,1*1e4);
            HighFreqFreez=dropShortIntervals(HighFreqFreez,2*1e4);
            
            LowFreqFreez=and(thresholdIntervals(ComparePowertsd,0,'Direction','Above'),Behav.FreezeEpoch);
            LowFreqFreez=mergeCloseIntervals(LowFreqFreez,1*1e4);
            LowFreqFreez=dropShortIntervals(LowFreqFreez,2*1e4);
            
            [AvSpectra.OBHighFreeze{mouse,session},SpectraBySlice.OBHighFreeze{mouse,session},SliceDur.OBHighFreeze{mouse,session}]=CharacterizeSpectraEpoch(Sptsd,Spectro{3},HighFreqFreez,2);
            [AvSpectra.OBLowFreeze{mouse,session},SpectraBySlice.OBLowFreeze{mouse,session},SliceDur.OBLowFreeze{mouse,session}]=CharacterizeSpectraEpoch(Sptsd,Spectro{3},LowFreqFreez,2);
            
            [AvSpectra.HPCHighFreeze{mouse,session},SpectraBySlice.HPCHighFreeze{mouse,session},SliceDur.HPCHighFreeze{mouse,session}]=CharacterizeSpectraEpoch(SptsdH,Spectro{3},HighFreqFreez,2);
            [AvSpectra.HPCLowFreeze{mouse,session},SpectraBySlice.HPCLowFreeze{mouse,session},SliceDur.HPCLowFreeze{mouse,session}]=CharacterizeSpectraEpoch(SptsdH,Spectro{3},LowFreqFreez,2);
            
            
            load('Ripples.mat')
            Riptsd=ts(Rip(:,2)*1e4);
            %% Fast Freezing
            if not(isempty(Start(HighFreqFreez)))
                NumRip.HighFreeze(mouse,session)=length(Range(Restrict(Riptsd,HighFreqFreez)));
                DurPer.HighFreeze(mouse,session)=nansum(Stop(HighFreqFreez,'s')-Start(HighFreqFreez,'s'));
            else
                NumRip.HighFreeze(mouse,session)=NaN;
                DurPer.HighFreeze(mouse,session)=NaN;
            end
            
            %% Slow Freezing
            if not(isempty(Start(LowFreqFreez)))
                NumRip.LowFreeze(mouse,session)=length(Range(Restrict(Riptsd,LowFreqFreez)));
                DurPer.LowFreeze(mouse,session)=nansum(Stop(LowFreqFreez,'s')-Start(LowFreqFreez,'s'));
            else
                NumRip.LowFreeze(mouse,session)=NaN;
                DurPer.LowFreeze(mouse,session)=NaN;
            end
            
            [NumRipBySlice.HighFreeze{mouse,session},SliceDur.LowFreeze{mouse,session}]=RipplesBySlice(Riptsd,HighFreqFreez,1);
            [NumRipBySlice.LowFreeze{mouse,session},SliceDur.LowFreeze{mouse,session}]=RipplesBySlice(Riptsd,LowFreqFreez,1);
            
            % Same time bins for HPC and OB
            tempdatHPC=(Data(Restrict(SptsdH,LitEp)));
            tempDatOB=Data(Restrict(Sptsd,LitEp));
            [X,Y]=meshgrid([1:size(tempDatOB,1)],[1:size(tempDatOB,2)]);
            [X2,Y2]=meshgrid([size(tempDatOB,1)/size(tempdatHPC,1):size(tempDatOB,1)/size(tempdatHPC,1):size(tempDatOB,1)],[1:size(tempDatOB,2)]);
            tempDatOBbis=(interp2(X,Y,tempDatOB',X2,Y2)');
            AllSpecHPC{mouse}=[AllSpecHPC{mouse};tempdatHPC];
            AllSpec{mouse}=[AllSpec{mouse};tempDatOBbis];
            
            
            
        end
    end
end

for mouse=[16,17,18]
    AllSpecHPC{mouse}=AllSpecHPC{mouse}./nanmean(nanmean(AllSpecHPC{mouse}));
    AllSpec{mouse}=AllSpec{mouse}./nanmean(nanmean(AllSpec{mouse}));
end
AllSpecHPCSepMice=AllSpecHPC;
AllSpecSepMice=AllSpec;
AllSpecHPC=[];AllSpecHPC=[AllSpecHPCSepMice{16};AllSpecHPCSepMice{17};AllSpecHPCSepMice{18}];
AllSpec=[];AllSpec=[AllSpecSepMice{16};AllSpecSepMice{17};AllSpecSepMice{18}];

figure
[valFreq,indFreq]=max(AllSpec');
dat=fLow(indFreq);
hist(dat,500)
hold on
plot(fLow,nanmean(AllSpec)/max(nanmean(AllSpec))*4000,'linewidth',3)
ylim([0 8000])
xlabel('Frequency Hz')
box off
title('OB freezing n=3 mice')

figure
[res,ind]=sort(dat);
ind(dat(ind)<1)=[];
ind(dat(ind)>8)=[];
subplot(411)
imagesc(1:size(AllSpec,1),fLow,log(AllSpec(ind,:)')), axis xy
title('OB Spectrum n=3 mice')
ylabel('Frequency - Hz')
subplot(412)
Bet=SmoothDec(nanmean(AllSpec(ind,find(fLow<12,1,'last'):find(fLow<15,1,'last'))'),200);
plot(Bet)
xlim([0 size(ind,2)])
title('12-15Hz n=3 mice')
ylabel('Power')
subplot(413)
imagesc(1:size(AllSpec,1),fhigh,log(AllSpecHPC(ind,:)')), axis xy
title('HPC Spectrum n=3 mice')
ylabel('Power')
subplot(414)
Rip=SmoothDec(nanmean(AllSpecHPC(ind,find(fhigh<120,1,'last'):find(fhigh<220,1,'last'))'),200);
plot(Rip)
xlim([0 size(ind,2)])
title('Ripple band n=3 mice')
ylabel('Power')

figure
dt=50;
plot3(dat(ind(1:dt:end)),Rip(1:dt:end),Bet(1:dt:end),'.')
xlabel('Freq OB')
zlabel('12-15Pow')
ylabel('Rip Pow')

figure
subplot(121)
PlotErrorBarN([nansum(DurPer.LowFreeze([16,17,18],:)');nansum(DurPer.HighFreeze([16,17,18],:)')]',0)
ylabel('Time Spent Fz -s')
set(gca,'XTick',[1,2],'XTickLabel',{'3Hz','5Hz'})
subplot(122)
PlotErrorBarN([nansum(NumRip.LowFreeze([16,17,18],:)')./nansum(DurPer.LowFreeze([16,17,18],:)');nansum(NumRip.HighFreeze([16,17,18],:)')./nansum(DurPer.HighFreeze([16,17,18],:)')]',0)
ylabel('Rip par sec')
set(gca,'XTick',[1,2],'XTickLabel',{'3Hz','5Hz'})

%Randomly subselect ripple times


for mouse=[16,17,18]
    subplot(3,1,mouse-15)
    HighFreezeTime=nansum(DurPer.HighFreeze(mouse,:));
    LowFreezeNum=nansum(NumRip.LowFreeze([mouse],:)')./nansum(DurPer.LowFreeze([mouse],:)');
    HighFreezeNum=nansum(NumRip.HighFreeze([mouse],:)')./nansum(DurPer.HighFreeze([mouse],:)');
    AllDur=[];
    AllRipCount=[];
    for session=1:5
        AllRipCount=[AllRipCount,NumRipBySlice.LowFreeze{mouse,session}'];
        AllDur=[AllDur,SliceDur.LowFreeze{mouse,session}];
    end
    
    
    for pass=1:1000
        RandOrder=randperm(length(AllRipCount));
        RandOrder=RandOrder(1:floor(HighFreezeTime));
        RipFreqRand(pass)=nansum(AllRipCount(RandOrder))./nansum(AllDur(RandOrder));
    end
    
    hist(RipFreqRand,50)
    line([HighFreezeNum HighFreezeNum],ylim)
    line([LowFreezeNum LowFreezeNum],ylim)
    xlabel('Rip per s')
end

figure


            [AvSpectra.HPCHighFreeze{mouse,session},SpectraBySlice.HPCHighFreeze{mouse,session},SliceDur.HPCHighFreeze{mouse,session}]=CharacterizeSpectraEpoch(SptsdH,Spectro{3},HighFreqFreez,2);
            [AvSpectra.HPCLowFreeze{mouse,session},SpectraBySlice.HPCLowFreeze{mouse,session},SliceDur.HPCLowFreeze{mouse,session}]=CharacterizeSpectraEpoch(SptsdH,Spectro{3},LowFreqFreez,2);

            for mouse=1:3
                HighFreezHPCAvSpec(mouse,:)=nanmean(reshape([AvSpectra.HPCHighFreeze{mouse+15,:}],94,5)');
                LowFreezHPCAvSpec(mouse,:)=nanmean(reshape([AvSpectra.HPCLowFreeze{mouse+15,:}],94,5)');
                TotPow=nanmean(nanmean(reshape([AvSpectra.HPCHighFreeze{mouse+15,:}],94,5)'))+nanmean(nanmean(reshape([AvSpectra.HPCLowFreeze{mouse+15,:}],94,5)'));
                HighFreezHPCAvSpec(mouse,:)=HighFreezHPCAvSpec(mouse,:)/TotPow;
                LowFreezHPCAvSpec(mouse,:)=LowFreezHPCAvSpec(mouse,:)/TotPow;
            end
            figure
            for mouse=1:3
                subplot(3,1,mouse)
                plot(fhigh,log(HighFreezHPCAvSpec(mouse,:)),'r')
                hold on
                plot(fhigh,log(LowFreezHPCAvSpec(mouse,:)),'b')
                
                xlabel('Frequency Hz')
            end
            
            
            