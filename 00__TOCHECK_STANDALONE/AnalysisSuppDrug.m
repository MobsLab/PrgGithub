function [BilanWt,BilanKO]=AnalysisSuppDrug(RT)


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

wt=[2 4 6 11 19];
ko=[1 3 5 15];

%nu=nu+1; id=find(RT{nu}{34}(:,1)<85&RT{nu}{34}(:,2)<20&RT{nu}{34}(:,3)<20&RT{nu}{34}(:,4)<20); plotCorrel(RT{nu}{34}(id,2),RT{nu}{34}(id,3),40,1);close,
filename{1}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse047\20121012\BULB-Mouse-47-12102012'; %basal
filename{2}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse051\20121017\BULB-Mouse-51-17102012'; %basal
filename{3}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse052\20121113\BULB-Mouse-52-13112012'; %basal
filename{4}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse060\20130415\BULB-Mouse-60-15042013'; %basal
filename{5}='\\NASDELUXE\DataMOBs\ProjetDPCPX\Mouse061\20130415\BULB-Mouse-61-15042013'; %basal

%--------------------------------------------------------------------------

%nu=nu+1;
%     a=a+1; R{a}=tPeaksT;         %28
%     a=a+1; R{a}=peakValue;       %29
%     a=a+1; R{a}=peakMeanValue;     %30
%     a=a+1; R{a}=zeroCrossT;        %31
%     a=a+1; R{a}=zeroMeanValue;     %32
%     a=a+1; R{a}=reliab;;           %33
%     a=a+1; R{a}=Bilan;;            %34   
    
clear Cwty
clear Cko
clear Cwty1
clear Cko1

BilanWt=[];
BilanKO=[];
ref1=1;ref2=2;
tbinsize=40;
tbin=200;
for nu=wt
    id=find(RT{nu}{34}(:,1)<85&RT{nu}{34}(:,2)<20&RT{nu}{34}(:,3)<20&RT{nu}{34}(:,4)<20); 
    spi{nu}=RT{nu}{49}(id,:);
    rip{nu}=RT{nu}{50};
    Epoch1{nu}=RT{nu}{1};
    Epoch2{nu}=RT{nu}{4};
    %eval(['cd ',filename{nu}])
    %load SpindlesRipples LFPp num
    %[tPeaksT,peakValue,peakMeanValue,zeroCrossT,zeroMeanValue,reliab,Bilan,ST,freq,Filt_EEGd,params]=FineAnalysisSpindes(LFPp,num,spi{nu});
    tPeaksT=RT{nu}{28};
    peakValue=RT{nu}{29};
    zeroCrossT=RT{nu}{31};
    zeroMeanValue=RT{nu}{32};
    Bilan=RT{nu}{34};
    BilanWt=[BilanWt;Bilan(id,:)];
   % figure('color',[1 1 1]), 
   % subplot(3,1,1), hold on
    [C,B]=CrossCorr(spi{nu}(:,ref1)*1E4,rip{nu}(:,ref2)*1E4,tbinsize,tbin);%plot(B/1E3,C,'b')
%     yl=ylim;
%     line([0 0],yl,'color','r')
%     subplot(3,1,2), hold on
    [C1,B1]=CrossCorr(tPeaksT(find(abs(peakValue)>2500))*1E4,rip{nu}(:,ref2)*1E4,tbinsize,tbin);%plot(B/1E3,C,'b')
   % yl=ylim;
   % line([0 0],yl,'color','r')
   % subplot(3,1,3), hold on
    [C,B]=CrossCorr(zeroCrossT(find(abs(zeroMeanValue)>2500))*1E4,rip{nu}(:,ref2)*1E4,tbinsize,tbin);%plot(B/1E3,C,'b')
%     yl=ylim;
%     line([0 0],yl,'color','r')
    try
    Cwty=[Cwty;C'];
    catch
    Cwty=(C');
    end
    
        try
    Cwty1=[Cwty;C1'];
    catch
    Cwty1=(C1');
        end
    
        
end

for nu=ko
    id=find(RT{nu}{34}(:,1)<85&RT{nu}{34}(:,2)<20&RT{nu}{34}(:,3)<20&RT{nu}{34}(:,4)<20); 
    spi{nu}=RT{nu}{49}(id,:);
    rip{nu}=RT{nu}{50};
    Epoch1{nu}=RT{nu}{1};
    Epoch2{nu}=RT{nu}{4};
    %eval(['cd ',filename{nu}])
    %load SpindlesRipples LFPp num
    %[tPeaksT,peakValue,peakMeanValue,zeroCrossT,zeroMeanValue,reliab,Bilan,ST,freq,Filt_EEGd,params]=FineAnalysisSpindes(LFPp,num,spi{nu});
    tPeaksT=RT{nu}{28};
    peakValue=RT{nu}{29};
    zeroCrossT=RT{nu}{31};
    zeroMeanValue=RT{nu}{32};
    Bilan=RT{nu}{34};
    BilanKO=[BilanKO;Bilan(id,:)];
    %figure('color',[1 1 1]), 
    %subplot(3,1,1), hold on
    [C,B]=CrossCorr(spi{nu}(:,ref1)*1E4,rip{nu}(:,ref2)*1E4,tbinsize,tbin);%plot(B/1E3,C,'k')
    %yl=ylim;
   % line([0 0],yl,'color','r')
   % subplot(3,1,2), hold on
    [C1,B1]=CrossCorr(tPeaksT(find(abs(peakValue)>2500))*1E4,rip{nu}(:,ref2)*1E4,tbinsize,tbin);%plot(B/1E3,C,'k')
   % yl=ylim;
   % line([0 0],yl,'color','r')
   % subplot(3,1,3), hold on
    [C,B]=CrossCorr(zeroCrossT(find(abs(zeroMeanValue)>2500))*1E4,rip{nu}(:,ref2)*1E4,tbinsize,tbin);%plot(B/1E3,C,'k')
   % yl=ylim;
    %line([0 0],yl,'color','r')
    try
    Cko=[Cko;C'];
    catch
    Cko=(C');
    end
    try
    Cko1=[Cko1;C1'];
    catch
    Cko1=(C1');
    end    
end


smo=1;

% figure
% subplot(2,2,1), imagesc(Cwty)
% subplot(2,2,2), imagesc(Cko)

Cwty=SmoothDec(Cwty,[0.005 smo]);
Cko=SmoothDec(Cko,[0.005 smo]);
Cwty=zscore(Cwty')';
Cko=zscore(Cko')';

% subplot(2,2,3), imagesc(Cwty)
% subplot(2,2,4), imagesc(Cko)

figure('color',[1 1 1]),subplot(2,1,1), hold on
plot(B/1E3,mean(Cwty),'k','linewidth',2)
plot(B/1E3,mean(Cwty)+stdError(Cwty),'k')
plot(B/1E3,mean(Cwty)-stdError(Cwty),'k')
plot(B/1E3,mean(Cko),'r','linewidth',2)
plot(B/1E3,mean(Cko)+stdError(Cko),'r')
plot(B/1E3,mean(Cko)-stdError(Cko),'r')
yl=ylim;
line([0 0],yl,'color','b')
xlim([-1.5 1.5])
ylim([-1 3.5])
[h,p]=ttest2(Cwty,Cko);
subplot(2,1,2), hold on
plot(B(h==1)/1E3,h(h==1),'bo')
hold on, plot(B/1E3,p,'k')
yl=ylim;
line([0 0],yl,'color','r')
xlim([-1.5 1.5])


%--------------------------------------------------------------------------
% 
% figure
% subplot(2,2,1), imagesc(Cwty1)
% subplot(2,2,2), imagesc(Cko1)

Cwty1=SmoothDec(Cwty1,[0.005 smo]);
Cko1=SmoothDec(Cko1,[0.005 smo]);
Cwty1=zscore(Cwty1')';
Cko1=zscore(Cko1')';

% subplot(2,2,3), imagesc(Cwty1)
% subplot(2,2,4), imagesc(Cko1)

figure('color',[1 1 1]),subplot(2,1,1), hold on
plot(B1/1E3,mean(Cwty1),'k','linewidth',2)
plot(B1/1E3,mean(Cwty1)+stdError(Cwty1),'k')
plot(B1/1E3,mean(Cwty1)-stdError(Cwty1),'k')
plot(B1/1E3,mean(Cko1),'r','linewidth',2)
plot(B1/1E3,mean(Cko1)+stdError(Cko1),'r')
plot(B1/1E3,mean(Cko1)-stdError(Cko1),'r')
yl=ylim;
line([0 0],yl,'color','b')
xlim([-1.5 1.5])
ylim([-1 3.5])
[h1,p1]=ttest2(Cwty1,Cko1);
subplot(2,1,2), hold on
plot(B1(h1==1)/1E3,h1(h1==1),'bo')
hold on, plot(B1/1E3,p1,'k')
yl=ylim;
line([0 0],yl,'color','r')
xlim([-1.5 1.5])


% Ms=PlotRipRaw(LFPp{num(1)},spi{nu},500);
% Mr=PlotRipRaw(LFPp{num(2)},rip{nu},80);

%--------------------------------------------------------------------------

% [MatricWt,RcWt]=plotCorrel([2;BilanWt(:,2);20],[2;BilanWt(:,4);20],100,1,100);title('Wt, 2 versus 4')
% [MatricKO,RcKO]=plotCorrel([2;BilanKO(:,2);20],[2;BilanKO(:,4);20],100,1,100);title('KO, 2 versus 4')
% 

% [MatricWt,RcWt]=plotCorrel([2;BilanWt(:,3);20],[2;BilanWt(:,4);20],100,1,100);title('Wt, 3 versus 4')
% [MatricKO,RcKO]=plotCorrel([2;BilanKO(:,3);20],[2;BilanKO(:,4);20],100,1,100);title('KO, 3 versus 4')

limFreq=8;
propWt(1)=length(find(BilanWt(:,3)<limFreq&BilanWt(:,4)<limFreq))/length(BilanWt)*100;
propWt(2)=length(find(BilanWt(:,3)>limFreq&BilanWt(:,4)<limFreq))/length(BilanWt)*100;
propWt(3)=length(find(BilanWt(:,3)<limFreq&BilanWt(:,4)>limFreq))/length(BilanWt)*100;
propWt(4)=length(find(BilanWt(:,3)>limFreq&BilanWt(:,4)>limFreq))/length(BilanWt)*100;

propKO(1)=length(find(BilanKO(:,3)<limFreq&BilanKO(:,4)<limFreq))/length(BilanKO)*100;
propKO(2)=length(find(BilanKO(:,3)>limFreq&BilanKO(:,4)<limFreq))/length(BilanKO)*100;
propKO(3)=length(find(BilanKO(:,3)<limFreq&BilanKO(:,4)>limFreq))/length(BilanKO)*100;
propKO(4)=length(find(BilanKO(:,3)>limFreq&BilanKO(:,4)>limFreq))/length(BilanKO)*100;


[propWt;propKO]


figure, plot(BilanWt(:,2),BilanWt(:,3),'k.'), hold on, plot(BilanKO(:,2),BilanKO(:,3),'r.'),
hold on, line([2 20],[2 20],'color','b')

%--------------------------------------------------------------------------


if 0
    
        ref1=1;ref2=2;
        clear Cwty
        clear Cko
        figure('color',[1 1 1]), subplot(2,1,1), hold on
        for nu=wt
            [C,B]=CrossCorr(RT{nu}{49}(:,ref1)*1E4,RT{nu}{50}(:,ref2)*1E4,40,100);plot(B/1E3,C,'k')
            % C=zscore(C);
        try
            Cwty=[Cwty;C'];
            catch
            Cwty=(C');
            end
        end
        for nu=ko
            [C,B]=CrossCorr(RT{nu}{49}(:,ref1)*1E4,RT{nu}{50}(:,ref2)*1E4,40,100);plot(B/1E3,C,'r')
            % C=zscore(C);
        try
            Cko=[Cko;C'];
            catch
            Cko=(C');
            end
        end
        subplot(2,1,2), hold on
        plot(B/1E3,mean(Cwty),'k')
        plot(B/1E3,mean(Cko),'r')
        yl=ylim;
        line([0 0],yl,'color','b')
        [h,p]=ttest2(Cwty,Cko);
        subplot(2,1,1),plot(B(h==1)/1E3,h(h==1),'bo')
        hold on, plot(B/1E3,p)
        yl=ylim;
        line([0 0],yl,'color','b')


end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

