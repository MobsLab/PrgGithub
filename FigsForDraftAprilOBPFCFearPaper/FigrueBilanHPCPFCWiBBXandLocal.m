% This code generates pannels used in april draft
clear all
% Get data
[Dir,KeepFirstSessionOnly,CtrlEphys]=GetRightSessionsFor4HzPaper('BBXAllData');

% Where to save
SaveFigFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Figure1/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];

% Get Parameters
[params,movingwin,suffix]=SpectrumParametersML('low');
order=16;
paramsGranger.trialave=0;
paramsGrangerparamsGranger.err=[1 0.0500];
paramsGranger.pad=2;
paramsGranger.fpass=[0.1 80];
paramsGranger.tapers=[3 5];
paramsGranger.Fs=250;
paramsGranger.err=[1 0.05];
movingwinGranger=[3 0.2];
Cols1=[0,109,219;146,0,0]/263;

n=1;
StrucNames={'HPC','PFCx'};
for mm=KeepFirstSessionOnly
    disp(Dir.path{mm})
    cd(Dir.path{mm})
    clear chH chB chP
    load('behavResources.mat')
    tpsmax=max(Range(Movtsd));
    try,load('StateEpochSB.mat')
        TotEpoch=intervalSet(0,tpsmax)-TotalNoiseEpoch;
    catch
        TotEpoch=intervalSet(0,tpsmax);
    end
    
    
    clear  Sptsd Spectro
    load('PFCx_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.PFC.BBX(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.PFC.BBX(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    chP=ch;
    
    clear  Sptsd Spectro
    load('H_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.HPC.BBX(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.HPC.BBX(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    chH=ch;

    
    % Coherence
    AllCombi=combnk([chP,chH],2);
    AllCombiNums=combnk([1,2,3],2);
    for st=1:size(AllCombi,1)
        NameTemp1=['CohgramcDataL/Cohgram_',num2str(AllCombi(st,1)),'_',num2str(AllCombi(st,2)),'.mat'];
        load(NameTemp1)
        Ctsd=tsd(t*1e4,C);
        ICtsd=tsd(t*1e4,imag(S12./sqrt(S1.*S2)));
        temp=nanmean(Data(Restrict(Ctsd,FreezeEpoch)));
        eval(['Coh.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'.BBX(n,:)=temp;']);
        temp=nanmean(Data(Restrict(Ctsd,TotEpoch-FreezeEpoch)));
        eval(['Coh.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'.BBX(n,:)=temp;']);
        temp=abs(nanmean(Data(Restrict(ICtsd,FreezeEpoch))));
        eval(['ICoh.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'.BBX(n,:)=temp;']);
        temp=abs(nanmean(Data(Restrict(ICtsd,TotEpoch-FreezeEpoch))));
        eval(['ICoh.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'.BBX(n,:)=temp;']);
fC=f;
        clear C
    end
    
    AllCombi=combnk([chH,chP],2);
    for st=1:size(AllCombi,1)
        NameTemp1=['GrangerData/Granger_Fz_',num2str(AllCombi(st,1)),'_',num2str(AllCombi(st,2)),'.mat'];
        load(NameTemp1)
        if not(isempty(Fx2y))
            eval(['Granger.Fz.',StrucNames{AllCombiNums(st,1)},'_',StrucNames{AllCombiNums(st,2)},'.BBX(n,:)=Fx2y;']);
            eval(['Granger.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'.BBX(n,:)=Fy2x;']);
        else
            eval(['Granger.Fz.',StrucNames{AllCombiNums(st,1)},'_',StrucNames{AllCombiNums(st,2)},'.BBX(n,:)=NaN(1,1250);']);
            eval(['Granger.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'.BBX(n,:)=nan(1,1250);']);
        end
        clear Fx2y Fy2x
        NameTemp1=['GrangerData/Granger_NoFz_',num2str(AllCombi(st,1)),'_',num2str(AllCombi(st,2)),'.mat'];
        load(NameTemp1)
        if not(isempty(Fx2y))
            eval(['Granger.NoFz.',StrucNames{AllCombiNums(st,1)},'_',StrucNames{AllCombiNums(st,2)},'.BBX(n,:)=Fx2y;']);
            eval(['Granger.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'.BBX(n,:)=Fy2x;']);
        else
            eval(['Granger.NoFz.',StrucNames{AllCombiNums(st,1)},'_',StrucNames{AllCombiNums(st,2)},'.BBX(n,:)=NaN(1,1250);']);
            eval(['Granger.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'.BBX(n,:)=nan(1,1250);']);
        end
        clear Fx2y Fy2x
    end

    
    MouseNum(n)=eval(Dir.name{mm}(end-2:end));
    chP=ch;
    fS=Spectro{3};
    
    clear FreezeEpoch TotEpoch Sptsd Spectro TotalNoiseEpoch Fx2y Fy2x Ctsd C
    n=n+1;
    
end



[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlHPCLocalOnly')
% Where to save
SaveFigFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Figure1/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];

% Get parameters
[params,movingwin,suffix]=SpectrumParametersML('low');
order=16;
paramsGranger.trialave=0;
paramsGrangerparamsGranger.err=[1 0.0500];
paramsGranger.pad=2;
paramsGranger.fpass=[0.1 80];
paramsGranger.tapers=[3 5];
paramsGranger.Fs=250;
paramsGranger.err=[1 0.05];
movingwinGranger=[3 0.2];

n=1;
StrucNames={'HPC','OB','PFCx'};
for mm=KeepFirstSessionOnly
    disp(Dir.path{(mm)})
    
    cd(Dir.path{(mm)})
    clear chH chB chP
    load('behavResources.mat')
    disp(num2str(sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))))
    
    tpsmax=max(Range(Movtsd));
    try,
        load('StateEpochSB.mat')
        TotEpoch=intervalSet(0,tpsmax)-TotalNoiseEpoch;
    catch
        TotEpoch=intervalSet(0,tpsmax);
    end
    
        
    clear  Sptsd Spectro
    try,load('HPCLoc_Low_Spectrum.mat'), catch, load('HLoc_Low_Spectrum.mat'), 
    movefile('HLoc_Low_Spectrum.mat','HPCLoc_Low_Spectrum.mat')
    end
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.HPCLoc(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.HPCLoc(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    fS=Spectro{3};
    chH=ch;
    
    load('HPC1_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.HPC1(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.HPC1(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    fS=Spectro{3};
    
    load('HPC2_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.HPC2(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.HPC2(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    fS=Spectro{3};


    % Coherence
    CoherencePairs={'PFC_HPCLoc','PFC_HPC1','PFC_HPC2','HPCLoc_OB1','HPC1_OB1','HPC2_OB1'};
    for st=1:size(CoherencePairs,2)
        load(['CohgramcDataL/Cohgram_',CoherencePairs{st},'.mat'])
        Ctsd=tsd(t*1e4,C);
        ICtsd=tsd(t*1e4,imag(S12./sqrt(S1.*S2)));
        temp=nanmean(Data(Restrict(Ctsd,FreezeEpoch)));
        eval(['Coh.Fz.',CoherencePairs{st},'(n,:)=temp;']);
        temp=nanmean(Data(Restrict(Ctsd,TotEpoch-FreezeEpoch)));
        eval(['Coh.NoFz.',CoherencePairs{st},'(n,:)=temp;']);
        temp=abs(nanmean(Data(Restrict(ICtsd,FreezeEpoch))));
        eval(['ICoh.Fz.',CoherencePairs{st},'(n,:)=temp;']);
        temp=abs(nanmean(Data(Restrict(ICtsd,TotEpoch-FreezeEpoch))));
        eval(['ICoh.NoFz.',CoherencePairs{st},'(n,:)=temp;']);
        fC=f;
        clear C
    end
    
    GrangerPairs={'HPC1_OB1','HPC2_OB1','HPCLoc_OB1','HPC1_PFC','HPC2_PFC','HPCLoc_PFC'};
    GrangerPairsInv={'OB1_HPC1','OB1_HPC2','OB1_HPCLoc','PFC_HPC1','PFC_HPC2','PFC_HPCLoc'};
    for st=1:size(GrangerPairs,2)
        load(['GrangerData/Granger_Fz_',GrangerPairs{st},'.mat'])
        Granger.Fz.(GrangerPairs{st})(n,:)=Fx2y;
        Granger.Fz.(GrangerPairsInv{st})(n,:)=Fy2x;
        clear Fx2y Fx2y
        
        load(['GrangerData/Granger_NoFz_',GrangerPairs{st},'.mat'])
        Granger.NoFz.(GrangerPairs{st})(n,:)=Fx2y;
        Granger.NoFz.(GrangerPairsInv{st})(n,:)=Fy2x;
        clear Fx2y Fx2y
    end
 
    clear FreezeEpoch TotEpoch Sptsd Spectro TotalNoiseEpoch
    n=n+1;
    
end

[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlAllData')

n=1;
StrucNames={'HPC','PFCx'};
for mm=KeepFirstSessionOnly
    disp(Dir.path{mm})
    
    cd(Dir.path{mm})
    clear chH chB chP
    load('behavResources.mat')
    disp(num2str(sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))))
    
    tpsmax=max(Range(Movtsd));
    try,
        load('StateEpochSB.mat')
        TotEpoch=intervalSet(0,tpsmax)-TotalNoiseEpoch;
    catch
        TotEpoch=intervalSet(0,tpsmax);
    end
    
     clear  Sptsd Spectro
    load('PFCx_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    chP=ch;
   
    clear  Sptsd Spectro
    load('H_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.HPC.RipOnly(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.HPC.RipOnly(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    fS=Spectro{3};
    chH=ch;
    
    % Coherence
    AllCombi=combnk([chH,chP],2);
    AllCombiNums=combnk([1,2],2);
    for st=1:size(AllCombi,1)
        NameTemp1=['CohgramcDataL/Cohgram_',num2str(AllCombi(st,1)),'_',num2str(AllCombi(st,2)),'.mat'];
        NameTemp2=['CohgramcDataL/Cohgram_',num2str(AllCombi(st,2)),'_',num2str(AllCombi(st,1)),'.mat'];
        try, load(NameTemp1);
        catch
            load(NameTemp2);
        end
        Ctsd=tsd(t*1e4,C);
        ICtsd=tsd(t*1e4,imag(S12./sqrt(S1.*S2)));
        temp=nanmean(Data(Restrict(Ctsd,FreezeEpoch)));
        eval(['Coh.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'.RipOnly(n,:)=temp;']);
        temp=nanmean(Data(Restrict(Ctsd,TotEpoch-FreezeEpoch)));
        eval(['Coh.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'.RipOnly(n,:)=temp;']);
        temp=abs(nanmean(Data(Restrict(ICtsd,FreezeEpoch))));
        eval(['ICoh.Fz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'.RipOnly(n,:)=temp;']);
        temp=abs(nanmean(Data(Restrict(ICtsd,TotEpoch-FreezeEpoch))));
        eval(['ICoh.NoFz.',StrucNames{AllCombiNums(st,2)},'_',StrucNames{AllCombiNums(st,1)},'.RipOnly(n,:)=temp;']);
        fC=f;
        clear C
    end
    
   
    clear FreezeEpoch TotEpoch Sptsd Spectro TotalNoiseEpoch
    n=n+1;
    
end


BandLimsS=[find(fC<3,1,'last'):find(fC<6,1,'last')];
OtherFreq=[1:length(fC)];OtherFreq(ismember(OtherFreq,BandLimsS))=[];
BandLimsThet=[find(fC<6,1,'last'):find(fC<9,1,'last')];
OtherFreqThet=[1:length(fC)];OtherFreqThet(ismember(OtherFreqThet,BandLimsThet))=[];

figure
%Coh PFC HPC
HPCElecs={'PFC_HPC1','PFC_HPCLoc'}
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
% [hl,hp]=boundedline(fC,nanmean(Coh.Fz.PFCx_HPC.RipOnly),[stdError(Coh.Fz.PFCx_HPC.RipOnly);stdError(Coh.Fz.PFCx_HPC.RipOnly)]','alpha'),hold on
% set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
% set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(Coh.Fz.PFC_HPCLoc),[stdError(Coh.Fz.PFC_HPCLoc);stdError(Coh.Fz.PFC_HPCLoc)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2,'linestyle',':')
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(Coh.Fz.PFCx_HPC.BBX),[stdError(Coh.Fz.PFCx_HPC.BBX);stdError(Coh.Fz.PFCx_HPC.BBX)]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Coherence')
ylim([0.4 1])
set(gca,'Layer','top')

figure
%Spec HPC
HPCElecs={'PFC_HPC1','PFC_HPCLoc'}
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.HPCLoc),[stdError(Spec.Fz.HPCLoc);stdError(Spec.Fz.HPCLoc)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2,'linestyle',':')
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.HPC.BBX),[stdError(Spec.Fz.HPC.BBX);stdError(Spec.Fz.HPC.BBX)]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power-log scale')
ylim([6 14])
set(gca,'Layer','top')


ValCtrlRip=nanmean(Coh.Fz.PFCx_HPC.RipOnly(:,BandLimsThet)');
ValCtrlLoc=nanmean(Coh.Fz.PFC_HPCLoc(:,BandLimsThet)');
ValOBX=nanmean(Coh.Fz.PFCx_HPC.BBX(:,BandLimsThet)');
ValCtrlRip4=nanmean(Coh.Fz.PFCx_HPC.RipOnly(:,BandLimsS)');
ValCtrlLoc4=nanmean(Coh.Fz.PFC_HPCLoc(:,BandLimsS)');
ValOBX4=nanmean(Coh.Fz.PFCx_HPC.BBX(:,BandLimsS)');
figure
line([0.7 1.3],[1 1]*nanmedian(ValCtrlRip4),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ValCtrlRip),'color','k','linewidth',2), hold on
line([3.7 4.3],[1 1]*nanmedian(ValCtrlLoc4),'color','k','linewidth',2)
line([4.7 5.3],[1 1]*nanmedian(ValCtrlLoc),'color','k','linewidth',2), hold on
line([6.7 7.3],[1 1]*nanmedian(ValOBX4),'color','k','linewidth',2), hold on
line([7.7 8.3],[1 1]*nanmedian(ValOBX),'color','k','linewidth',2)
handles=plotSpread({ValCtrlRip4,ValCtrlRip,ValCtrlLoc4,ValCtrlLoc,ValOBX4,ValOBX},'xValues',[1,2,4,5,7,8],'distributionColors',{Cols1(1,:),Cols1(1,:),Cols1(1,:),Cols1(1,:),Cols1(2,:),Cols1(2,:)}); hold on
set(handles{1},'MarkerSize',20)
[p(1),h(1,:),stats(1)]=ranksum(ValCtrlRip4,ValCtrlRip);
[p(2),h(2,:),stats(2)]=ranksum(ValCtrlLoc4,ValCtrlLoc);
[p(3),h(3,:),stats(3)]=ranksum(ValOBX4,ValOBX);
set(gca,'XTickLabel',{'3-6Hz','6-9Hz','3-6Hz','6-9Hz','3-6Hz','6-9Hz'})
H=sigstar({[1,2],[4,5],[7,8]},p);
set(H(1,1),'Color','w');set(H(1,2),'FontSize',14)
set(H(2,1),'Color','w');set(H(2,2),'FontSize',14)
set(H(3,1),'Color','w');set(H(3,2),'FontSize',14)

%%

% SpecHPC 
figure
Cols1=[0,109,219;146,146,146]/263;
HPCElecs={'PFC_HPC1','PFC_HPCLoc'}
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.HPC.RipOnly),[stdError(Spec.Fz.HPC.RipOnly);stdError(Spec.Fz.HPC.RipOnly)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fS,nanmean(Spec.NoFz.HPC.RipOnly),[stdError(Spec.NoFz.HPC.RipOnly);stdError(Spec.Fz.HPC.RipOnly)]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Coherence')
ylim([0.4 1])
set(gca,'Layer','top')
ylim([7 13])

figure
HPC4Hz=nanmean(Spec.Fz.HPC.RipOnly(:,BandLimsS)')./nanmean(Spec.Fz.HPC.RipOnly(:,OtherFreq)');
HPCTheta=nanmean(Spec.Fz.HPC.RipOnly(:,BandLimsThet)')./nanmean(Spec.Fz.HPC.RipOnly(:,OtherFreqThet)');
line([0.7 1.3],[1 1]*nanmedian(HPC4Hz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(HPCTheta),'color','k','linewidth',2), hold on
handles=plotSpread({HPC4Hz,HPCTheta},'xValues',[1,2],'distributionColors',{Cols1(1,:),Cols1(1,:)}); hold on
set(handles{1},'MarkerSize',20)
clear p h stats
[p(1),h(1,:),stats(1)]=ranksum(HPC4Hz,HPCTheta);
save('StatsHPC4HzvsTheta.mat','p','h','stats')
set(gca,'XTickLabel',{'3-6Hz','6-9Hz'})
H=sigstar({[1,2 ]},p);
set(H(1,1),'Color','w');set(H(1,2),'FontSize',14)



% SpecHPC BBX
figure
HPCElecs={'PFC_HPC1','PFC_HPCLoc'}
fig=figure;
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.HPC.BBX),[stdError(Spec.Fz.HPC.BBX);stdError(Spec.Fz.HPC.BBX)]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fS,nanmean(Spec.NoFz.HPC.BBX),[stdError(Spec.NoFz.HPC.BBX);stdError(Spec.Fz.HPC.BBX)]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Coherence')
set(gca,'Layer','top')
ylim([7 13])

figure
HPC4Hz=nanmean(Spec.Fz.HPC.BBX(:,BandLimsS)')./nanmean(Spec.Fz.HPC.BBX(:,OtherFreq)');
HPCTheta=nanmean(Spec.Fz.HPC.BBX(:,BandLimsThet)')./nanmean(Spec.Fz.HPC.BBX(:,OtherFreqThet)');
line([0.7 1.3],[1 1]*nanmedian(HPC4Hz),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(HPCTheta),'color','k','linewidth',2), hold on
handles=plotSpread({HPC4Hz,HPCTheta},'xValues',[1,2],'distributionColors',{Cols1(1,:),Cols1(1,:)}); hold on
set(handles{1},'MarkerSize',20)
clear p h stats
[p(1),h(1,:),stats(1)]=ranksum(HPC4Hz,HPCTheta);
save('StatsHPCBBX4HzvsTheta.mat','p','h','stats')
set(gca,'XTickLabel',{'3-6Hz','6-9Hz'})
H=sigstar({[1,2 ]},p);
set(H(1,1),'Color','w');set(H(1,2),'FontSize',14)

