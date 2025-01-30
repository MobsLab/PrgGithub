function [As,Aw,Ar,rs,rsZ,rr,rrZ,rw,rwZ,idx1,idx2,R1,R2,MM1,MM2,S,NumNeurons,LFPd,LFPs,SWSEpoch,REMEpoch,Wake,Down,PowTsd,DurTsd,IntTsd]=PowerDownHomeostasis(ch,plo,S,NumNeurons,LFPd,LFPs)

% [As,Aw,Ar,rs,rsZ,rr,rrZ,rw,rwZ,idx1,idx2,S,NumNeurons,LFPd,LFPs,SWSEpoch,REMEpoch,Wake]=PowerDownHomeostasis(ch,plo,S,NumNeurons,LFPd,LFPs)
% 
% PowerDownHomeostasis(ch)
% function PowerDownHomeostasis(ch)
% PowerDownHomeostasis(ch)
%
% ch=1; %Down perfect
% ch=0; %Down loose
%

try
    ch;
catch
 ch=1; %Down perfect
% ch=0; %Down loose
end

try
    plo;
catch
    plo=1;
end




% disp(' ')
% try
%     S;
%     NumNeurons;
%     LFPd
%     LFPs
% catch
%     tic
%     load StateEpochSB SWSEpoch REMEpoch
%     load SpikeData
%     try
%         tetrodeChannels;
%     catch
%         SetCurrentSession
%         global DATA
%         tetrodeChannels=DATA.spikeGroups.groups;
%         rep=input('Do you want to save tetrodechannels ? (y/n) ','s');
%         if rep=='y'
%         save SpikeData -Append tetrodeChannels
%         end
%         
%     end
%     
%     load LFPData/InfoLFP InfoLFP
%     ok=0;
%     for i=1:32
%         try
%         if InfoLFP.structure{i}=='CxPF';
%             ok=1;
%            InfoLFP.structure{i}='PFCx';
%         end
%         end
%     end
%     if ok==1
%         disp(' ')
%         disp('****** Modification of InfoLFP ******')
%         disp(' ')
%         res=pwd;
%         cd LFPData
%         save InfoLFP InfoLFP
%         cd(res)
%     end
%     clear InfoLFP
%     
% %     [Spfc,NumNeurons]=GetSpikesFromStructure('PFCx');
%     
% 
%     
%     toc
% end

  load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPd=LFP;
    clear LFP
    
   load ChannelsToAnalyse/PFCx_sup
    eval(['load LFPData/LFP',num2str(channel)])
    LFPs=LFP;
    clear LFP

load StateEpochSB SWSEpoch REMEpoch Wake

try
    load DownSpk
    load SpikeData
catch
    limSizDown=70;
    binSize=10;
    
    if ch
        [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,binSize,0.01,1,0,[0 limSizDown],1);
    else
        [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,binSize,0.01,1,0,[20 limSizDown],1);
    end
    title(pwd)
    
    if plo==2;
        close
    end
    
end

LFPdr=ResampleTSD(LFPd,100);
Fil=FilterLFP(LFPdr,[0.1 6],1024);
PowTsd=tsd(Range(Fil),abs(hilbert(Data(Fil))));
PowTsd=ResampleTSD(PowTsd,1);
po=Data(PowTsd);
po(po<10)=10;
PowTsd=tsd(Range(PowTsd),po);

st=Start(Down);en=End(Down);
DurTsd=tsd(st,(en-st)/10);
IntTsd=tsd(en(1:end-1),(st(2:end)-en(1:end-1))/10);
dur=Data(DurTsd);
in=Data(IntTsd);
Ratio=tsd(Range(IntTsd),in./dur(1:end-1));

% disp(' ')
% disp('**** Average LFP to Down ****')
enDown=End(Down,'s');
% [MLd,TLd]=PlotRipRaw(LFPd,enDown,800,1);close
% [MLs,TLs]=PlotRipRaw(LFPs,enDown,800,1);close
% AmpDelta1=tsd(enDown*1E4,(max(TLd(:,find(MLd(:,1)<0))')-min(TLs(:,find(MLs(:,1)<0))'))');
% AmpDelta2=tsd(enDown*1E4,(max(TLs(:,find(MLs(:,1)>0))')-min(TLd(:,find(MLd(:,1)>0))'))');

AmpDelta1=tsd(enDown*1E4,Data(Restrict(LFPd,enDown*1E4-0.04*1E4))-Data(Restrict(LFPs,enDown*1E4-0.04*1E4)));
AmpDelta2=tsd(enDown*1E4,Data(Restrict(LFPs,enDown*1E4+0.1*1E4))-Data(Restrict(LFPd,enDown*1E4+0.1*1E4)));

disp(' ')
% 
% 
% [M,T]=PlotRipRaw(Qt,Start(Down,'s'),800);close
% [M2,T2]=PlotRipRaw(Qt,End(Down,'s'),800);close

nb=30;
% FrAft=tsd(Start(Down),mean(T2(:,80:80+nb),2));
% FrBef=tsd(Start(Down),mean(T(:,77-nb:77),2));
% 

test1=mean([Data(Restrict(Qt,Start(Down)-0.02E4))';Data(Restrict(Qt,Start(Down)-0.05E4))';Data(Restrict(Qt,Start(Down)-0.07E4))';])';
test2=mean([Data(Restrict(Qt,Start(Down)+0.02E4))';Data(Restrict(Qt,Start(Down)+0.05E4))';Data(Restrict(Qt,Start(Down)+0.07E4))';])';
FrAft=tsd(Start(Down),test1);
FrBef=tsd(Start(Down),test2);

load newDeltaPFCx
Dpfc=ts(tDelta);
limIntDown=0.6;

[BurstDeltaEpoch2,NbD]=FindDeltaBurst(SWSEpoch,limIntDown);
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(ts(Start(Down)),limIntDown,1);
[BurstDeltaEpochB,NbD]=FindDeltaBurst2(Dpfc,limIntDown,1);


[MM1,TT1]=PlotRipRaw(LFPd,Range(Dpfc,'s'),800);close
test=max(TT1');
rg=Range(Dpfc,'s');

[rho1a,pval1a] = partialcorr(log(diff(Range(Dpfc,'s'))),test(2:end)',rg(2:end));%rho1a
[rho1b,pval1b] = corrcoef(log(diff(Range(Dpfc,'s'))),test(2:end)');%rho1b(2,1)
[rho2a,pval2a] = partialcorr(rg(2:end),test(2:end)',log(diff(Range(Dpfc,'s'))));%rho2a
[rho2b,pval2b] = corrcoef(rg(2:end),test(2:end)');%rho2b(2,1)
%[rho1a,rho1b(2,1),rho2a,rho2b(2,1)]
%[pval1a,pval1b(2,1),pval2a,pval2b(2,1)]

[MM2,TT2]=PlotRipRaw(LFPd,Range(Restrict(Dpfc,BurstDeltaEpochB),'s'),800);close
test2=max(TT2');
rg2=Range(Restrict(Dpfc,BurstDeltaEpochB),'s');
[rho1aE,pval1aE] = partialcorr(log(diff(Range(Restrict(Dpfc,BurstDeltaEpochB),'s'))),test2(2:end)',rg2(2:end));%rho1a
[rho1bE,pval1bE] = corrcoef(log(diff(Range(Restrict(Dpfc,BurstDeltaEpochB),'s'))),test2(2:end)');%rho1b(2,1)
[rho2aE,pval2aE] = partialcorr(rg2(2:end),test2(2:end)',log(diff(Range(Restrict(Dpfc,BurstDeltaEpochB),'s'))));%rho2a
[rho2bE,pval2bE] = corrcoef(rg2(2:end),test2(2:end)');%rho2b(2,1)
R1=[rho1a,rho1b(2,1),rho2a,rho2b(2,1),rho1aE,rho1bE(2,1),rho2aE,rho2bE(2,1)];
R2=[pval1a,pval1b(2,1),pval2a,pval2b(2,1),pval1aE,pval1bE(2,1),pval2aE,pval2bE(2,1)];





for i=1:length(Start(SWSEpoch))
    nbDownSWS(i)=length(Start(and(Down,subset(SWSEpoch,i))));
    FrDownSWS(i)=length(Start(and(Down,subset(SWSEpoch,i))))/(End(subset(SWSEpoch,i),'s')-Start(subset(SWSEpoch,i),'s'));    
    FrSWS(i)=mean(Data(Restrict(Qt,subset(SWSEpoch,i))));
    
    FrSWSNoUp(i)=mean(Data(Restrict(Qt,(subset(SWSEpoch,i)-Down))));
    
    FrBefSWS(i)=mean(Data(Restrict(FrBef,subset(SWSEpoch,i))));
    FrAftSWS(i)=mean(Data(Restrict(FrAft,subset(SWSEpoch,i))));
    PowSWS(i)=mean(Data(Restrict(PowTsd,subset(SWSEpoch,i))));
    DurSWS(i)=mean(Data(Restrict(DurTsd,subset(SWSEpoch,i))));
    IntSWS(i)=mean(Data(Restrict(IntTsd,subset(SWSEpoch,i)))); 
    AmpDeltaDownSWS(i)=mean(Data(Restrict(AmpDelta1,subset(SWSEpoch,i)))); 
    AmpDeltaUpSWS(i)=mean(Data(Restrict(AmpDelta2,subset(SWSEpoch,i))));      
end

for i=1:length(Start(REMEpoch))
    nbDownREM(i)=length(Start(and(Down,subset(REMEpoch,i))));
    FrDownREM(i)=length(Start(and(Down,subset(REMEpoch,i))))/(End(subset(REMEpoch,i),'s')-Start(subset(REMEpoch,i),'s')); 
    FrREM(i)=mean(Data(Restrict(Qt,subset(REMEpoch,i))));
    
    FrREMNoUp(i)=mean(Data(Restrict(Qt,(subset(REMEpoch,i)-Down))));
        
    FrBefREM(i)=mean(Data(Restrict(FrBef,subset(REMEpoch,i))));
    FrAftREM(i)=mean(Data(Restrict(FrAft,subset(REMEpoch,i))));
    PowREM(i)=mean(Data(Restrict(PowTsd,subset(REMEpoch,i))));
    DurREM(i)=mean(Data(Restrict(DurTsd,subset(REMEpoch,i))));
    IntREM(i)=mean(Data(Restrict(IntTsd,subset(REMEpoch,i)))); 
    AmpDeltaDownREM(i)=mean(Data(Restrict(AmpDelta1,subset(REMEpoch,i)))); 
    AmpDeltaUpREM(i)=mean(Data(Restrict(AmpDelta2,subset(REMEpoch,i))));     
end

for i=1:length(Start(Wake))
    nbDownWake(i)=length(Start(and(Down,subset(Wake,i))));   
    FrDownWake(i)=length(Start(and(Down,subset(Wake,i))))/(End(subset(Wake,i),'s')-Start(subset(Wake,i),'s')); 
    FrWake(i)=mean(Data(Restrict(Qt,subset(Wake,i))));
    
    FrWakeNoUp(i)=mean(Data(Restrict(Qt,(subset(Wake,i)-Down))));
        
    FrBefWake(i)=mean(Data(Restrict(FrBef,subset(Wake,i))));
    FrAftWake(i)=mean(Data(Restrict(FrAft,subset(Wake,i))));
    PowWake(i)=mean(Data(Restrict(PowTsd,subset(Wake,i))));
    DurWake(i)=mean(Data(Restrict(DurTsd,subset(Wake,i))));
    IntWake(i)=mean(Data(Restrict(IntTsd,subset(Wake,i))));
    AmpDeltaDownWake(i)=mean(Data(Restrict(AmpDelta1,subset(Wake,i)))); 
    AmpDeltaUpWake(i)=mean(Data(Restrict(AmpDelta2,subset(Wake,i))));     
end


stt=Start(SWSEpoch,'s');
enn=End(SWSEpoch,'s');

%------------------------------------------------------------------------
%------------------------------------------------------------------------

As(1,:)=Start(SWSEpoch,'s');
As(2,:)=End(SWSEpoch,'s')-Start(SWSEpoch,'s');
As(3,:)=PowSWS;
As(4,:)=nbDownSWS;
As(5,:)=FrDownSWS;
As(6,:)=DurSWS;
As(7,:)=IntSWS;
As(8,:)=IntSWS./DurSWS;
As(9,:)=AmpDeltaDownSWS;
As(10,:)=AmpDeltaUpSWS;
As(11,:)=FrSWSNoUp;
As(12,:)=FrSWS;
As(13,:)=FrBefSWS;
As(14,:)=FrAftSWS;
As(15,:)=FrAftSWS-FrBefSWS;

Ar(1,:)=Start(REMEpoch,'s');
Ar(2,:)=End(REMEpoch,'s')-Start(REMEpoch,'s');
Ar(3,:)=PowREM;
Ar(4,:)=nbDownREM;
Ar(5,:)=FrDownREM;
Ar(6,:)=DurREM;
Ar(7,:)=IntREM;
Ar(8,:)=IntREM./DurREM;
Ar(9,:)=AmpDeltaDownREM;
Ar(10,:)=AmpDeltaUpREM;
Ar(11,:)=FrREMNoUp;
Ar(12,:)=FrREM;
Ar(13,:)=FrBefREM;
Ar(14,:)=FrAftREM;
Ar(15,:)=FrAftREM-FrBefREM;

Aw(1,:)=Start(Wake,'s');
Aw(2,:)=End(Wake,'s')-Start(Wake,'s');
Aw(3,:)=PowWake;
Aw(4,:)=nbDownWake;
Aw(5,:)=FrDownWake;
Aw(6,:)=DurWake;
Aw(7,:)=IntWake;
Aw(8,:)=IntWake./DurWake;
Aw(9,:)=AmpDeltaDownWake;
Aw(10,:)=AmpDeltaUpWake;
Aw(11,:)=FrWakeNoUp;
Aw(12,:)=FrWake;
Aw(13,:)=FrBefWake;
Aw(14,:)=FrAftWake;
Aw(15,:)=FrAftWake-FrBefWake;


rs=nancorrcoef(As');
rr=nancorrcoef(Ar');
rw=nancorrcoef(Aw');

rsZ=nancorrcoef(nanzscore(As'));
rrZ=nancorrcoef(nanzscore(Ar'));
rwZ=nancorrcoef(nanzscore(Aw'));


        idx2=find(As(6,:)>130&As(7,:)<1E3);
        idx1=find(As(6,:)>130&As(7,:)<1E3);
%------------------------------------------------------------------------
%------------------------------------------------------------------------

if plo>0

    

        figure('color',[1 1 1]), 
        subplot(3,2,1), imagesc(rs), colorbar, ylabel('SWS'), title('R')
        set(gca,'ytick',1:size(As,1))
        set(gca,'yticklabel',{'Start periods','Dur periods','Power','Nb Down','Occ Down','Dur Down','ISI Down','Ratio ISI/Dur Down','Ampl Delta Down','Ampl Delta Up','Fr no Up','Fr','Fr Bef','Fr Aft','Diff Fr'})
        caxis([-0.52 1])
        
        subplot(3,2,2), imagesc(rsZ), colorbar, title('R zscore')
        caxis([-0.52 1])
        
        subplot(3,2,3), imagesc(rr), colorbar, ylabel('REM')
        set(gca,'ytick',1:size(As,1))
        set(gca,'yticklabel',{'Start periods','Dur periods','Power','Nb Down','Occ Down','Dur Down','ISI Down','Ratio ISI/Dur Down','Ampl Delta Down','Ampl Delta Up','Fr no Up','Fr','Fr Bef','Fr Aft','Diff Fr'})
        caxis([-0.52 1])
        
        subplot(3,2,4), imagesc(rrZ), colorbar
        caxis([-0.52 1])
        
        subplot(3,2,5), imagesc(rw), colorbar, ylabel('Wake')
        set(gca,'ytick',1:size(As,1))
        set(gca,'yticklabel',{'Start periods','Dur periods','Power','Nb Down','Occ Down','Dur Down','ISI Down','Ratio ISI/Dur Down','Ampl Delta Down','Ampl Delta Up','Fr no Up','Fr','Fr Bef','Fr Aft','Diff Fr'})
        caxis([-0.52 1])
        
        subplot(3,2,6), imagesc(rwZ), colorbar
        caxis([-0.52 1])
        h=esa;
        colormap(esa)

        
        
        
        figure('color',[1 1 1]), 
        subplot(2,2,1), scatter(As(3,:),As(2,:),50,As(5,:),'filled'), title('Occ Down')
        set(gca,'yscale','log')
        ylabel('Duration SWSEpoch')
        xlabel('Power')
%         hold on, plot(As(1,id1),nanzscore(As(6,id1)'),'ko','markerfacecolor','k','markersize',3)
%         plot(As(1,id2),nanzscore(As(7,id2)'),'bo','markerfacecolor','b','markersize',3)
%         plot(As(1,id3),nanzscore(As(3,id3)'),'ro','markerfacecolor','r','markersize',3)
%         xlabel('Time (s)') 
        subplot(2,2,2), scatter(As(6,:),As(7,:),50,As(3,:),'filled'), title('Power')
        set(gca,'yscale','log')
        xlabel('Duration Down (ms)')
        ylabel('ISI Down (ms)')
        subplot(2,2,3), scatter(As(9,:),As(10,:),50,As(3,:),'filled'), title('Power')
        set(gca,'yscale','log')
        xlabel('Ampl Delta Down ')
        ylabel('Ampl Delta Up')
        subplot(2,2,4), scatter(As(14,:),As(11,:),50,As(3,:),'filled'), title('Power')
        set(gca,'yscale','log')
        xlabel('Fr (Hz)')
        ylabel('Diff Aft/Bef (Hz)')
        

%         subplot(2,2,1),
%         disp('***************************************')
%         disp('selection subplot(2,2,1)')
%         idx1=SelectData;  
%         disp(' ')        
%         disp('***************************************')
%         disp('selection subplot(2,2,1)')
%         subplot(2,2,2),
%         idx2=SelectData; 
%         disp(' ') 
        
        idx2=find(As(6,:)>130&As(7,:)<1E3);
        idx1=find(As(6,:)>130&As(7,:)<1E3);
        
        figure('color',[1 1 1]), 
        subplot(2,5,1:2), hold on, 
        plot(As(1,:),'ko-','markersize',2), 
        plot(idx1,As(1,idx1),'ro','markerfacecolor','r')
        
        subplot(2,5,3), hold on, 
        plot(As(5,:),As(2,:),'ko','markerfacecolor','k','markersize',3), 
        plot(As(5,idx1),As(2,idx1),'ro','markerfacecolor','r','markersize',3)
        xlabel('Occ Down states (Hz)')
        ylabel('Duration SWSEpoch (s)')
        
        subplot(2,5,6:7), hold on,
        plot(As(1,:),'ko-','markersize',2)
        plot(idx2,As(1,idx2),'ro','markerfacecolor','r')

        subplot(2,5,8), hold on, 
        plot(As(5,:),As(2,:),'ko','markerfacecolor','k','markersize',3), 
        plot(As(5,idx2),As(2,idx2),'ro','markerfacecolor','r','markersize',3)
        xlabel('Occ Down states (Hz)')
        ylabel('Duration SWSEpoch (s)')        


        subplot(2,5,[4 5 9 10]), hold on,
        scatter(As(6,:),As(7,:),50,As(1,end)-As(1,:),'filled'), title('Time'), set(gca,'yscale','log'),xlabel('Duration Down (ms)'), ylabel('ISI Down (ms)')



%------------------------------------------------------------------------
%------------------------------------------------------------------------

if plo<2
    
%         th1=percentile(As(6,:),90);
%         id1=find(As(6,:)<th1);
%         th2=percentile(As(7,:),90);
%         id2=find(As(7,:)<th2);
%         th3=percentile(As(3,:),90);
%         id3=find(As(3,:)<th3);
        
%         figure('color',[1 1 1]), 
%         subplot(2,2,1), scatter(As(3,:),As(2,:),50,As(5,:),'filled'), title('Occ Down')
%         set(gca,'yscale','log')
%         ylabel('Duration SWSEpoch')
%         xlabel('Power')
% %         hold on, plot(As(1,id1),nanzscore(As(6,id1)'),'ko','markerfacecolor','k','markersize',3)
% %         plot(As(1,id2),nanzscore(As(7,id2)'),'bo','markerfacecolor','b','markersize',3)
% %         plot(As(1,id3),nanzscore(As(3,id3)'),'ro','markerfacecolor','r','markersize',3)
% %         xlabel('Time (s)') 
%         subplot(2,2,2), scatter(As(6,:),As(7,:),50,As(3,:),'filled'), title('Power')
%         set(gca,'yscale','log')
%         xlabel('Duration Down (ms)')
%         ylabel('ISI Down (ms)')
%         subplot(2,2,3), scatter(As(9,:),As(10,:),50,As(3,:),'filled'), title('Power')
%         set(gca,'yscale','log')
%         xlabel('Ampl Delta Down ')
%         ylabel('Ampl Delta Up')
%         subplot(2,2,4), scatter(As(14,:),As(11,:),50,As(3,:),'filled'), title('Power')
%         set(gca,'yscale','log')
%         xlabel('Fr (Hz)')
%         ylabel('Diff Aft/Bef (Hz)')


%------------------------------------------------------------------------
%------------------------------------------------------------------------

        figure('color',[1 1 1]), 
        subplot(3,2,1), plot(Range(DurTsd,'s'),Data(DurTsd),'k')
        hold on, plot(Range(Restrict(DurTsd,REMEpoch),'s'),Data(Restrict(DurTsd,REMEpoch)),'b')
        hold on, plot(Range(Restrict(DurTsd,SWSEpoch),'s'),Data(Restrict(DurTsd,SWSEpoch)),'r')
        set(gca,'yscale','log')
        ylabel('Duration Down (ms)')
        xl=xlim;
        xlim([0 xl(2)])
        line([0 xl(2)],[median(Data(DurTsd)) median(Data(DurTsd))],'color',[0.7 0.7 0.7])
        yl=ylim;
        ylim([min(Data(DurTsd)) yl(2)])

        subplot(3,2,3), plot(Range(IntTsd,'s'),Data(IntTsd),'k')
        hold on, plot(Range(Restrict(IntTsd,REMEpoch),'s'),Data(Restrict(IntTsd,REMEpoch)),'b')
        hold on, plot(Range(Restrict(IntTsd,SWSEpoch),'s'),Data(Restrict(IntTsd,SWSEpoch)),'r')
        set(gca,'yscale','log')
        ylabel('ISI Down (ms)')
        xl=xlim;
        xlim([0 xl(2)])
        line([0 xl(2)],[median(Data(IntTsd)) median(Data(IntTsd))],'color',[0.7 0.7 0.7])

        subplot(3,2,5), plot(Range(IntTsd,'s'),10*log10(Data(Ratio)),'k')
        hold on, plot(Range(Restrict(Ratio,REMEpoch),'s'),10*log10(Data(Restrict(Ratio,REMEpoch))),'b')
        hold on, plot(Range(Restrict(Ratio,SWSEpoch),'s'),10*log10(Data(Restrict(Ratio,SWSEpoch))),'r')
        % set(gca,'yscale','log')
        ylabel('Ratio')
        xl=xlim;
        xlim([0 xl(2)])
        line([0 xl(2)],[0 0],'color',[0.7 0.7 0.7])

        subplot(3,2,2), plot(Range(PowTsd,'s'),10*log10(Data(PowTsd)),'k')
        hold on, plot(Range(Restrict(PowTsd,REMEpoch),'s'),10*log10(Data(Restrict(PowTsd,REMEpoch))),'b')
        hold on, plot(Range(Restrict(PowTsd,SWSEpoch),'s'),10*log10(Data(Restrict(PowTsd,SWSEpoch))),'r')
        xl=xlim;
        xlim([0 xl(2)])
        line([0 xl(2)],[median(10*log10(Data(PowTsd))) median(10*log10(Data(PowTsd)))],'color',[0.7 0.7 0.7])
        ylabel('Power (log)')

        subplot(3,2,4), plot(Range(AmpDelta1,'s'),10*log10(Data(AmpDelta1)),'k')
        hold on, plot(Range(Restrict(AmpDelta1,REMEpoch),'s'),10*log10(Data(Restrict(AmpDelta1,REMEpoch))),'b')
        hold on, plot(Range(Restrict(AmpDelta1,SWSEpoch),'s'),10*log10(Data(Restrict(AmpDelta1,SWSEpoch))),'r')
        xl=xlim;
        xlim([0 xl(2)])
        line([0 xl(2)],[median(10*log10(Data(AmpDelta1))) median(10*log10(Data(AmpDelta1)))],'color',[0.7 0.7 0.7])
        ylabel('Amp Delta Down')

        subplot(3,2,6), plot(Range(AmpDelta2,'s'),10*log10(Data(AmpDelta2)),'k')
        hold on, plot(Range(Restrict(AmpDelta2,REMEpoch),'s'),10*log10(Data(Restrict(AmpDelta2,REMEpoch))),'b')
        hold on, plot(Range(Restrict(AmpDelta2,SWSEpoch),'s'),10*log10(Data(Restrict(AmpDelta2,SWSEpoch))),'r')
        xl=xlim;
        xlim([0 xl(2)])
        line([0 xl(2)],[median(10*log10(Data(AmpDelta2))) median(10*log10(Data(AmpDelta2)))],'color',[0.7 0.7 0.7])
        ylabel('Amp Delta Up')





        %------------------------------------------------------------------------
        %------------------------------------------------------------------------


        figure('color',[1 1 1]), 
        subplot(2,5,1), hold on,
        plot(Data(Restrict(DurTsd,REMEpoch)), Data(Restrict(PowTsd,Restrict(DurTsd,REMEpoch))),'b.','markersize',5)
        set(gca,'yscale','log')
        set(gca,'xscale','log')
        [r,p]=corrcoef(log(Data(Restrict(DurTsd,REMEpoch))), log(Data(Restrict(PowTsd,Restrict(DurTsd,REMEpoch)))));
        title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
        ylabel('Power Delta')
        xlabel('Dur Down')
        
        subplot(2,5,2), hold on,
        plot(Data(Restrict(IntTsd,REMEpoch)), Data(Restrict(PowTsd,Restrict(IntTsd,REMEpoch))),'b.','markersize',5)
        set(gca,'yscale','log')
        set(gca,'xscale','log')
        [r,p]=corrcoef(log(Data(Restrict(IntTsd,REMEpoch))), log(Data(Restrict(PowTsd,Restrict(IntTsd,REMEpoch)))));
        title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
        xlabel('ISI Down')
        
        subplot(2,5,3), hold on,
        plot(Data(Restrict(Ratio,REMEpoch)), Data(Restrict(PowTsd,Restrict(Ratio,REMEpoch))),'b.','markersize',5)
        set(gca,'yscale','log')
        set(gca,'xscale','log')
        [r,p]=corrcoef(log(Data(Restrict(Ratio,REMEpoch))), log(Data(Restrict(PowTsd,Restrict(Ratio,REMEpoch)))));
        title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
        xlabel('Ratio Dur/ISI Down')
        
        subplot(2,5,4), hold on,
        plot(Data(Restrict(AmpDelta1,REMEpoch)), Data(Restrict(PowTsd,Restrict(AmpDelta1,REMEpoch))),'b.','markersize',5)
        set(gca,'yscale','log')
        set(gca,'xscale','log')
        [r,p]=corrcoef(log(Data(Restrict(AmpDelta1,REMEpoch))), log(Data(Restrict(PowTsd,Restrict(AmpDelta1,REMEpoch)))));
        title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
        xlabel('Amp Delta wave Down')
        
        subplot(2,5,5), hold on,
        plot(Data(Restrict(AmpDelta2,REMEpoch)), Data(Restrict(PowTsd,Restrict(AmpDelta2,REMEpoch))),'b.','markersize',5)
        set(gca,'yscale','log')
        set(gca,'xscale','log')
        [r,p]=corrcoef(log(Data(Restrict(AmpDelta2,REMEpoch))), log(Data(Restrict(PowTsd,Restrict(AmpDelta2,REMEpoch)))));
        title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
        xlabel('Amp Delta wave Up')
        
        
        
        subplot(2,5,6), hold on,
        plot(Data(Restrict(DurTsd,SWSEpoch)), Data(Restrict(PowTsd,Restrict(DurTsd,SWSEpoch))),'r.','markersize',1)
        set(gca,'yscale','log')
        set(gca,'xscale','log')
        [r,p]=corrcoef(log(Data(Restrict(DurTsd,SWSEpoch))), log(Data(Restrict(PowTsd,Restrict(DurTsd,SWSEpoch)))));
        title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
        ylabel('Power Delta')
        xlabel('Dur Down')
        
        subplot(2,5,7), hold on,
        plot(Data(Restrict(IntTsd,SWSEpoch)), Data(Restrict(PowTsd,Restrict(IntTsd,SWSEpoch))),'r.','markersize',1)
        set(gca,'yscale','log')
        set(gca,'xscale','log')
        [r,p]=corrcoef(log(Data(Restrict(IntTsd,SWSEpoch))), log(Data(Restrict(PowTsd,Restrict(IntTsd,SWSEpoch)))));
        title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
        xlabel('ISI Down')
        
        subplot(2,5,8), hold on,
        plot(Data(Restrict(Ratio,SWSEpoch)), Data(Restrict(PowTsd,Restrict(Ratio,SWSEpoch))),'r.','markersize',1)
        set(gca,'yscale','log')
        set(gca,'xscale','log')
        [r,p]=corrcoef(log(Data(Restrict(Ratio,SWSEpoch))), log(Data(Restrict(PowTsd,Restrict(Ratio,SWSEpoch)))));
        title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
        xlabel('Ratio Dur/ISI Down')
        
        subplot(2,5,9), hold on,
        plot(Data(Restrict(AmpDelta1,SWSEpoch)), Data(Restrict(PowTsd,Restrict(AmpDelta1,SWSEpoch))),'r.','markersize',1)
        set(gca,'yscale','log')
        set(gca,'xscale','log')
        [r,p]=corrcoef(log(Data(Restrict(AmpDelta1,SWSEpoch))), log(Data(Restrict(PowTsd,Restrict(AmpDelta1,SWSEpoch)))));
        title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
        xlabel('Amp Delta wave Down')
        
        subplot(2,5,10), hold on,
        plot(Data(Restrict(AmpDelta2,SWSEpoch)), Data(Restrict(PowTsd,Restrict(AmpDelta2,SWSEpoch))),'r.','markersize',1)
        set(gca,'yscale','log')
        set(gca,'xscale','log')
        [r,p]=corrcoef(log(Data(Restrict(AmpDelta2,SWSEpoch))), log(Data(Restrict(PowTsd,Restrict(AmpDelta2,SWSEpoch)))));
        title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
        xlabel('Amp Delta wave Up')

        %------------------------------------------------------------------------
        %------------------------------------------------------------------------



        figure('color',[1 1 1]), hold on, 
        plot(MLd(:,1),MLd(:,2),'k','linewidth',2), 
        plot(MLs(:,1),MLs(:,2),'r','linewidth',2), 
        yl=ylim; line([0 0],yl)




        %------------------------------------------------------------------------
        %------------------------------------------------------------------------
        %FrDownHomeostasis
        %------------------------------------------------------------------------


        figure('color',[1 1 1]),
        subplot(3,1,1), hold on, 
        plot(Range(FrBef,'s'),Data(FrBef),'k')
        plot(Range(Restrict(FrBef,SWSEpoch),'s'),Data(Restrict(FrBef,SWSEpoch)),'r')
        xl=xlim;
        xlim([0 xl(2)])
        line([0 xl(2)],[median(Data(FrBef)) median(Data(FrBef))],'color',[0.7 0.7 0.7])
        ylabel('Fr before (Hz)')

        subplot(3,1,2), hold on, 
        plot(Range(FrAft,'s'),Data(FrAft),'k')
        plot(Range(Restrict(FrAft,SWSEpoch),'s'),Data(Restrict(FrAft,SWSEpoch)),'r')
        xl=xlim;
        xlim([0 xl(2)])
        line([0 xl(2)],[median(Data(FrAft)) median(Data(FrAft))],'color',[0.7 0.7 0.7])
        ylabel('Fr after (Hz)')

        subplot(3,1,3), hold on, 
        plot(Range(FrAft,'s'),Data(FrAft)-Data(FrBef),'k')
        plot(Range(Restrict(FrAft,SWSEpoch),'s'),Data(Restrict(FrAft,SWSEpoch))-Data(Restrict(FrBef,SWSEpoch)),'r')
        xl=xlim;
        xlim([0 xl(2)])
        line([0 xl(2)],[0 0],'color',[0.7 0.7 0.7])
        ylabel('Diff Fr (Hz)')



        %------------------------------------------------------------------------
        %------------------------------------------------------------------------


        figure('color',[1 1 1]), 
        subplot(4,2,1:2), hold on
        plot(Start(SWSEpoch,'s'),nbDownSWS/max(nbDownSWS)*max(FrDownSWS),'o-','color',[0.7 0.7 0.7],'markerfacecolor',[0.7 0.7 0.7],'markersize',3)
        plot(Start(SWSEpoch,'s'),FrDownSWS,'ko-','markerfacecolor','k','markersize',4)
        ylabel('Occ Down (per sec)')
        subplot(4,2,3), hold on
        plot(Start(SWSEpoch,'s'),FrSWS,'ko-','markerfacecolor','k','markersize',4)
        plot(Start(SWSEpoch,'s'),FrBefSWS,'bo-','markerfacecolor','b','markersize',4)
        plot(Start(SWSEpoch,'s'),FrAftSWS,'ro-','markerfacecolor','r','markersize',4)
        ylabel('Fr SWS (Hz)')
        subplot(4,2,5), hold on
        plot(Start(REMEpoch,'s'),FrREM,'ko-','markerfacecolor','k','markersize',4)
        plot(Start(REMEpoch,'s'),FrBefREM,'bo-','markerfacecolor','b','markersize',4)
        plot(Start(REMEpoch,'s'),FrAftREM,'ro-','markerfacecolor','r','markersize',4)
        ylabel('Fr REM (Hz)')
        subplot(4,2,7), hold on
        plot(Start(Wake,'s'),FrWake,'ko-','markerfacecolor','k','markersize',4)
        plot(Start(Wake,'s'),FrBefWake,'bo-','markerfacecolor','b','markersize',4)
        plot(Start(Wake,'s'),FrAftWake,'ro-','markerfacecolor','r','markersize',4)
        ylabel('Fr Wake (Hz)')



%        figure('color',[1 1 1]), 
%         subplot(4,2,2), hold on
%         plot(Start(SWSEpoch,'s'),nbDown/max(nbDown)*max(FrDown),'o-','color',[0.7 0.7 0.7],'markerfacecolor',[0.7 0.7 0.7],'markersize',2)
%         plot(Start(SWSEpoch,'s'),FrDown,'ko-','markerfacecolor','k','markersize',2)
%         ylabel('Occ Down (per sec)')
        subplot(4,2,4), hold on
        plot(Start(SWSEpoch,'s'),FrAftSWS-FrBefSWS,'ko','markerfacecolor','k','markersize',2)
        xl=xlim;
        xlim([0 xl(2)])
        line([0 xl(2)],[0 0],'color',[0.7 0.7 0.7])
        ylabel('Diff Fr SWS (Hz)')
        subplot(4,2,6), hold on
        plot(Start(REMEpoch,'s'),FrAftREM-FrBefREM,'ko','markerfacecolor','k','markersize',2)
        xl=xlim;
        xlim([0 xl(2)])
        line([0 xl(2)],[0 0],'color',[0.7 0.7 0.7])
        ylabel('Diff Fr REM (Hz)')
        subplot(4,2,8), hold on
        plot(Start(Wake,'s'),FrAftWake-FrBefWake,'ko','markerfacecolor','k','markersize',2)
        ylabel('Diff Fr Wake (Hz)')
        xl=xlim;
        xlim([0 xl(2)])
        line([0 xl(2)],[0 0],'color',[0.7 0.7 0.7])




        %------------------------------------------------------------------------
        %------------------------------------------------------------------------
        
        
        figure('color',[1 1 1])
        subplot(2,3,1), plot(nbDownSWS,DurSWS,'k.')
        %set(gca,'xscale','log')
        ylabel('Mean Dur Down')
        xlabel('Mean nb Down')
 
        subplot(2,3,2), plot(nbDownSWS,IntSWS,'k.')
       % set(gca,'xscale','log')
        ylabel('Mean ISI Down')
        xlabel('Mean nb Down')
         set(gca,'yscale','log')
        set(gca,'xscale','log')         
        
        subplot(2,3,3), hold on, plot(nbDownSWS,FrAftSWS-FrBefSWS,'ko','markerfacecolor','k','markersize',4)
        xl=xlim;
        xlim([1 xl(2)])
        line([1 xl(2)],[0 0],'color',[0.7 0.7 0.7])
        xlabel('Mean nb Down')
        ylabel('Diff Fr aft-Bef (Hz)')
         set(gca,'xscale','log')
          
         subplot(2,3,4), plot(FrDownSWS,DurSWS,'k.')
      %  set(gca,'xscale','log')
        ylabel('Mean Dur Down')
        xlabel('Mean Occ Down')

        subplot(2,3,5), plot(FrDownSWS,IntSWS,'k.')
       % set(gca,'xscale','log')
        ylabel('Mean ISI Down')
        xlabel('Mean Occ Down')       
        set(gca,'yscale','log')
        set(gca,'xscale','log')        
 
        subplot(2,3,6), hold on, plot(FrDownSWS,FrAftSWS-FrBefSWS,'ko','markerfacecolor','k','markersize',4)
        set(gca,'xscale','log')
        xl=xlim;
        line(xl,[0 0],'color',[0.7 0.7 0.7])
        xlabel('Mean Occ Down')
        ylabel('Diff Fr aft-Bef (Hz)')
        
        
%   keyboard      
        
end

end


%------------------------------------------------------------------------
%------------------------------------------------------------------------



%         figure('color',[1 1 1])
%         subplot(2,3,1), plot(diff(Start(SWSEpoch,'s')),nbDownSWS(2:end),'k.')
%         set(gca,'xscale','log')
%         xlabel('ISI SWS epoch (suivant)')
%         ylabel('Nb Down')
%         
%         subplot(2,3,2), plot(diff(Start(SWSEpoch,'s')),nbDownSWS(1:end-1),'k.')
%         set(gca,'xscale','log')
%         xlabel('ISI SWS epoch')
%                 
%         subplot(2,3,3), plot(stt(2:end)-enn(1:end-1),nbDownSWS(1:end-1),'k.')
%         set(gca,'xscale','log')
%         xlabel('Dur end-start SWS epoch')
%         
%         subplot(2,3,4), plot(diff(Start(SWSEpoch,'s')),FrDownSWS(2:end),'k.')
%         set(gca,'xscale','log')
%         xlabel('ISI SWS epoch (suivant)')
%          ylabel('Fr Down')
%          
%         subplot(2,3,5), plot(diff(Start(SWSEpoch,'s')),FrDownSWS(1:end-1),'k.')
%         set(gca,'xscale','log')
%         xlabel('ISI SWS epoch')
%         
%         subplot(2,3,6), plot(stt(2:end)-enn(1:end-1),FrDownSWS(1:end-1),'k.')
%         set(gca,'xscale','log')
%         xlabel('Dur end-start SWS epoch')



% 
% AmpDelta1=tsd(enDown*1E4,(max(TLd(:,find(MLd(:,1)<0))')-min(TLs(:,find(MLs(:,1)<0))'))');
% AmpDelta2=tsd(enDown*1E4,(max(TLs(:,find(MLs(:,1)>0))')-min(TLd(:,find(MLd(:,1)>0))'))');
% disp(' ')
% 
% 
% 
% %------------------------------------------------------------------------
% %------------------------------------------------------------------------
% 
% 
% 
% figure('color',[1 1 1]), 
% subplot(3,2,1), plot(Range(DurTsd,'s'),Data(DurTsd),'k')
% hold on, plot(Range(Restrict(DurTsd,REMEpoch),'s'),Data(Restrict(DurTsd,REMEpoch)),'b')
% hold on, plot(Range(Restrict(DurTsd,SWSEpoch),'s'),Data(Restrict(DurTsd,SWSEpoch)),'r')
% set(gca,'yscale','log')
% ylabel('Duration Down (ms)')
% xl=xlim;
% xlim([0 xl(2)])
% line([0 xl(2)],[median(Data(DurTsd)) median(Data(DurTsd))],'color',[0.7 0.7 0.7])
% yl=ylim;
% ylim([min(Data(DurTsd)) yl(2)])
% 
% subplot(3,2,3), plot(Range(IntTsd,'s'),Data(IntTsd),'k')
% hold on, plot(Range(Restrict(IntTsd,REMEpoch),'s'),Data(Restrict(IntTsd,REMEpoch)),'b')
% hold on, plot(Range(Restrict(IntTsd,SWSEpoch),'s'),Data(Restrict(IntTsd,SWSEpoch)),'r')
% set(gca,'yscale','log')
% ylabel('ISI Down (ms)')
% xl=xlim;
% xlim([0 xl(2)])
% line([0 xl(2)],[median(Data(IntTsd)) median(Data(IntTsd))],'color',[0.7 0.7 0.7])
% 
% subplot(3,2,5), plot(Range(IntTsd,'s'),10*log10(Data(Ratio)),'k')
% hold on, plot(Range(Restrict(Ratio,REMEpoch),'s'),10*log10(Data(Restrict(Ratio,REMEpoch))),'b')
% hold on, plot(Range(Restrict(Ratio,SWSEpoch),'s'),10*log10(Data(Restrict(Ratio,SWSEpoch))),'r')
% % set(gca,'yscale','log')
% ylabel('Ratio')
% xl=xlim;
% xlim([0 xl(2)])
% line([0 xl(2)],[0 0],'color',[0.7 0.7 0.7])
% 
% subplot(3,2,2), plot(Range(PowTsd,'s'),10*log10(Data(PowTsd)),'k')
% hold on, plot(Range(Restrict(PowTsd,REMEpoch),'s'),10*log10(Data(Restrict(PowTsd,REMEpoch))),'b')
% hold on, plot(Range(Restrict(PowTsd,SWSEpoch),'s'),10*log10(Data(Restrict(PowTsd,SWSEpoch))),'r')
% xl=xlim;
% xlim([0 xl(2)])
% line([0 xl(2)],[median(10*log10(Data(PowTsd))) median(10*log10(Data(PowTsd)))],'color',[0.7 0.7 0.7])
% ylabel('Power (log)')
% 
% subplot(3,2,4), plot(Range(AmpDelta1,'s'),10*log10(Data(AmpDelta1)),'k')
% hold on, plot(Range(Restrict(AmpDelta1,REMEpoch),'s'),10*log10(Data(Restrict(AmpDelta1,REMEpoch))),'b')
% hold on, plot(Range(Restrict(AmpDelta1,SWSEpoch),'s'),10*log10(Data(Restrict(AmpDelta1,SWSEpoch))),'r')
% xl=xlim;
% xlim([0 xl(2)])
% line([0 xl(2)],[median(10*log10(Data(AmpDelta1))) median(10*log10(Data(AmpDelta1)))],'color',[0.7 0.7 0.7])
% ylabel('Amp Delta')
% 
% subplot(3,2,6), plot(Range(AmpDelta2,'s'),10*log10(Data(AmpDelta2)),'k')
% hold on, plot(Range(Restrict(AmpDelta2,REMEpoch),'s'),10*log10(Data(Restrict(AmpDelta2,REMEpoch))),'b')
% hold on, plot(Range(Restrict(AmpDelta2,SWSEpoch),'s'),10*log10(Data(Restrict(AmpDelta2,SWSEpoch))),'r')
% xl=xlim;
% xlim([0 xl(2)])
% line([0 xl(2)],[median(10*log10(Data(AmpDelta2))) median(10*log10(Data(AmpDelta2)))],'color',[0.7 0.7 0.7])
% ylabel('Amp Delta')
% 
% 
% 
% 
% 
% 
% figure('color',[1 1 1]), 
% subplot(2,5,1), hold on,
% plot(Data(Restrict(DurTsd,REMEpoch)), Data(Restrict(PowTsd,Restrict(DurTsd,REMEpoch))),'b.','markersize',5)
% set(gca,'yscale','log')
% set(gca,'xscale','log')
% [r,p]=corrcoef(log(Data(Restrict(DurTsd,REMEpoch))), log(Data(Restrict(PowTsd,Restrict(DurTsd,REMEpoch)))));
% title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
% 
% subplot(2,5,2), hold on,
% plot(Data(Restrict(IntTsd,REMEpoch)), Data(Restrict(PowTsd,Restrict(IntTsd,REMEpoch))),'b.','markersize',5)
% set(gca,'yscale','log')
% set(gca,'xscale','log')
% [r,p]=corrcoef(log(Data(Restrict(IntTsd,REMEpoch))), log(Data(Restrict(PowTsd,Restrict(IntTsd,REMEpoch)))));
% title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
% 
% subplot(2,5,3), hold on,
% plot(Data(Restrict(Ratio,REMEpoch)), Data(Restrict(PowTsd,Restrict(Ratio,REMEpoch))),'b.','markersize',5)
% set(gca,'yscale','log')
% set(gca,'xscale','log')
% [r,p]=corrcoef(log(Data(Restrict(Ratio,REMEpoch))), log(Data(Restrict(PowTsd,Restrict(Ratio,REMEpoch)))));
% title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
% 
% subplot(2,5,4), hold on,
% plot(Data(Restrict(AmpDelta1,REMEpoch)), Data(Restrict(PowTsd,Restrict(AmpDelta1,REMEpoch))),'b.','markersize',5)
% set(gca,'yscale','log')
% set(gca,'xscale','log')
% [r,p]=corrcoef(log(Data(Restrict(AmpDelta1,REMEpoch))), log(Data(Restrict(PowTsd,Restrict(AmpDelta1,REMEpoch)))));
% title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
% 
% 
% subplot(2,5,5), hold on,
% plot(Data(Restrict(AmpDelta2,REMEpoch)), Data(Restrict(PowTsd,Restrict(AmpDelta2,REMEpoch))),'b.','markersize',5)
% set(gca,'yscale','log')
% set(gca,'xscale','log')
% [r,p]=corrcoef(log(Data(Restrict(AmpDelta2,REMEpoch))), log(Data(Restrict(PowTsd,Restrict(AmpDelta2,REMEpoch)))));
% title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
% 
% 
% 
% 
% 
% subplot(2,5,6), hold on,
% plot(Data(Restrict(DurTsd,SWSEpoch)), Data(Restrict(PowTsd,Restrict(DurTsd,SWSEpoch))),'r.','markersize',1)
% set(gca,'yscale','log')
% set(gca,'xscale','log')
% [r,p]=corrcoef(log(Data(Restrict(DurTsd,SWSEpoch))), log(Data(Restrict(PowTsd,Restrict(DurTsd,SWSEpoch)))));
% title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
% 
% subplot(2,5,7), hold on,
% plot(Data(Restrict(IntTsd,SWSEpoch)), Data(Restrict(PowTsd,Restrict(IntTsd,SWSEpoch))),'r.','markersize',1)
% set(gca,'yscale','log')
% set(gca,'xscale','log')
% [r,p]=corrcoef(log(Data(Restrict(IntTsd,SWSEpoch))), log(Data(Restrict(PowTsd,Restrict(IntTsd,SWSEpoch)))));
% title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
% 
% subplot(2,5,8), hold on,
% plot(Data(Restrict(Ratio,SWSEpoch)), Data(Restrict(PowTsd,Restrict(Ratio,SWSEpoch))),'r.','markersize',1)
% set(gca,'yscale','log')
% set(gca,'xscale','log')
% [r,p]=corrcoef(log(Data(Restrict(Ratio,SWSEpoch))), log(Data(Restrict(PowTsd,Restrict(Ratio,SWSEpoch)))));
% title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
% 
% subplot(2,5,9), hold on,
% plot(Data(Restrict(AmpDelta1,SWSEpoch)), Data(Restrict(PowTsd,Restrict(AmpDelta1,SWSEpoch))),'r.','markersize',1)
% set(gca,'yscale','log')
% set(gca,'xscale','log')
% [r,p]=corrcoef(log(Data(Restrict(AmpDelta1,SWSEpoch))), log(Data(Restrict(PowTsd,Restrict(AmpDelta1,SWSEpoch)))));
% title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
% 
% 
% subplot(2,5,10), hold on,
% plot(Data(Restrict(AmpDelta2,SWSEpoch)), Data(Restrict(PowTsd,Restrict(AmpDelta2,SWSEpoch))),'r.','markersize',1)
% set(gca,'yscale','log')
% set(gca,'xscale','log')
% [r,p]=corrcoef(log(Data(Restrict(AmpDelta2,SWSEpoch))), log(Data(Restrict(PowTsd,Restrict(AmpDelta2,SWSEpoch)))));
% title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])








