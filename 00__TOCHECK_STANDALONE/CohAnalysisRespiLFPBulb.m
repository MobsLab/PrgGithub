function [C,f,S1,S2,fb,Cb,S1b,S2b,fc,Cc,S1c,S2c]=CohAnalysisRespiLFPBulb(n1,n2,para)

try
para{1};
LFP=para{1};
catch
load LFPData
end

try
    para{2};
    para{3};
    para{4};
    SWSEpoch=para{2};
    REMEpoch=para{3};
    MovEpoch=para{4};
catch
    load StateEpoch
end

load listLFP
listLFP

rg=Range(LFP{1});
st=rg(1);
en=rg(end);
EpochT=intervalSet(st,en);
% Epoch2=intervalSet(en,rg(end));

Epoch1=and(SWSEpoch,EpochT);
Epoch2=and(REMEpoch,EpochT);
Epoch3=and(MovEpoch,EpochT);

params.Fs=1/median(diff(Range(LFP{2},'s')));
% params.tapers=[3,5];
params.tapers=[5,9];
params.fpass=[0 25];
params.err=[2,0.05];
params.pad=0;

%--------------------------------------------------------------------------
try
    n1;
    if n1==0
        load LFPData RespiTSD
        tsa=RespiTSD;
    else
        tsa=LFP{n1};
    end
catch
    tsa=RespiTSD;
end

try
    n2;
catch
    n2=2;
end
%--------------------------------------------------------------------------


if 0

            try
            [C,phi,S12,S1,S2,f,confC,phistd,Cerr]=coherencyc(Data(Restrict(tsa,Restrict(LFP{n2},Epoch1))),Data(Restrict(LFP{n2},Epoch1)),params);
            catch
                try
            Epoch1=subset(Epoch1,1:15);
            [C,phi,S12,S1,S2,f,confC,phistd,Cerr]=coherencyc(Data(Restrict(tsa,Restrict(LFP{n2},Epoch1))),Data(Restrict(LFP{n2},Epoch1)),params);
                catch
                    Epoch1=subset(Epoch1,1:10);
            [C,phi,S12,S1,S2,f,confC,phistd,Cerr]=coherencyc(Data(Restrict(tsa,Restrict(LFP{n2},Epoch1))),Data(Restrict(LFP{n2},Epoch1)),params);
                end

            end
                try
                [Cb,phib,S12b,S1b,S2b,fb,confCb,phistdb,Cerrb]=coherencyc(Data(Restrict(tsa,Restrict(LFP{n2},Epoch2))),Data(Restrict(LFP{n2},Epoch2)),params);
                catch
                    fb=[];
                    Cb=[];
                    S1b=[];
                    S2b=[];
                end
                try
                [Cc,phic,S12c,S1c,S2c,fc,confCc,phistdc,Cerrc]=coherencyc(Data(Restrict(tsa,Restrict(LFP{n2},Epoch3))),Data(Restrict(LFP{n2},Epoch3)),params);
                catch
                Epoch3=subset(Epoch3,1:10);
            [Cc,phic,S12c,S1c,S2c,fc,confCc,phistdc,Cerrc]=coherencyc(Data(Restrict(tsa,Restrict(LFP{n2},Epoch3))),Data(Restrict(LFP{n2},Epoch3)),params);
                end

                smo=5;
    
else
            params.tapers=[3,5];
            movingwin=[3,0.5];
            [Ctemp,phi,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr]=cohgramc(Data(Restrict(tsa,Restrict(LFP{n2},EpochT))),Data(Restrict(LFP{n2},EpochT)),movingwin,params);

            Ctsd=Restrict(tsd((t+movingwin(2)/2)*1E4,Ctemp),Epoch1);
            C=mean(Data(Ctsd));
            if length(Start(Epoch2))>0
            Ctsd=Restrict(tsd((t+movingwin(2)/2)*1E4,Ctemp),Epoch2);
            Cb=mean(Data(Ctsd));
            else
              Cb=[];
            end
            Ctsd=Restrict(tsd((t+movingwin(2)/2)*1E4,Ctemp),Epoch3);
            Cc=mean(Data(Ctsd));

            phitsd=Restrict(tsd((t+movingwin(2)/2)*1E4,phitemp),Epoch1);
            phi=mean(Data(phitsd));
            phitsd=Restrict(tsd((t+movingwin(2)/2)*1E4,phitemp),Epoch2);
            phib=mean(Data(phitsd));
            phitsd=Restrict(tsd((t+movingwin(2)/2)*1E4,phitemp),Epoch3);
            phic=mean(Data(phitsd));

            S1tsd=Restrict(tsd((t+movingwin(2)/2)*1E4,S1temp),Epoch1);
            S1=mean(Data(S1tsd));
            S1tsd=Restrict(tsd((t+movingwin(2)/2)*1E4,S1temp),Epoch2);
            S1b=mean(Data(S1tsd));
            S1tsd=Restrict(tsd((t+movingwin(2)/2)*1E4,S1temp),Epoch3);
            S1c=mean(Data(S1tsd));

            S2tsd=Restrict(tsd((t+movingwin(2)/2)*1E4,S2temp),Epoch1);
            S2=mean(Data(S2tsd));
            S2tsd=Restrict(tsd((t+movingwin(2)/2)*1E4,S2temp),Epoch2);
            S2b=mean(Data(S2tsd));
            S2tsd=Restrict(tsd((t+movingwin(2)/2)*1E4,S2temp),Epoch3);
            S2c=mean(Data(S2tsd));

            fb=f;
            fc=f;

            Pas=1;
            smo=1;
        
end



try
    Pas;pas=Pas;
catch
pas=20; %SWSEpoch
end
figure('color',[1 1 1]),
%  subplot(2,2,1), plot(f(1:pas:end),10*log10(SmoothDec(S1(1:pas:end),5)))
%  subplot(2,2,3), plot(f(1:pas:end),10*log10(SmoothDec(S2(1:pas:end),5)))
subplot(2,2,1), plot(f(1:pas:end),(SmoothDec(S1(1:pas:end),smo)),'k','linewidth',2),title([num2str(n1),' vs. ',num2str(n2)]),xlim([params.fpass(1) params.fpass(2)])
subplot(2,2,3), plot(f(1:pas:end),(SmoothDec(S2(1:pas:end),smo)),'k','linewidth',2),xlim([params.fpass(1) params.fpass(2)])
subplot(2,2,2),
try
    hold on,plot(f(1:pas:end),SmoothDec(Cerr(1,1:pas:end),smo),'color',[0.7 0.7 0.7],'linewidth',1)
hold on,plot(f(1:pas:end),SmoothDec(Cerr(2,1:pas:end),smo),'color',[0.7 0.7 0.7],'linewidth',1)
end
hold on, plot(f(1:pas:end),SmoothDec(C(1:pas:end),smo),'k','linewidth',2)
try
    line([params.fpass(1) params.fpass(2)],[confC confC],'color','r')
end
title('Epoch 1')
xlim([params.fpass(1) params.fpass(2)])
subplot(2,2,4),
try
hold on, plot(f(1:pas:end),SmoothDec(phi(1:pas:end)+phistd(1:pas:end)',smo),'color',[0.7 0.7 0.7])
hold on, plot(f(1:pas:end),SmoothDec(phi(1:pas:end)-phistd(1:pas:end)',smo),'color',[0.7 0.7 0.7])
end

try
hold on, plot(f(1:pas:end),SmoothDec(phi(1:pas:end),smo),'k','linewidth',2)
catch
    hold on, plot(f(1:pas:end),mean(SmoothDec(phi(1:pas:end),smo)),'k','linewidth',1)
end
xlim([params.fpass(1) params.fpass(2)])
ylim([-pi pi])
title(pwd)

try
    try
        Pas;pas=Pas;
    catch
pas=2; %REMEpoch
    end
figure('color',[1 1 1]), 
% subplot(2,2,1), plot(fb(1:pas:end),10*log10(SmoothDec(S1b(1:pas:end),5)))
% subplot(2,2,3), plot(fb(1:pas:end),10*log10(SmoothDec(S2b(1:pas:end),5)))
subplot(2,2,1), plot(fb(1:pas:end),(SmoothDec(S1b(1:pas:end),smo)),'k','linewidth',2),title([num2str(n1),' vs. ',num2str(n2)]),xlim([params.fpass(1) params.fpass(2)])
subplot(2,2,3), plot(fb(1:pas:end),(SmoothDec(S2b(1:pas:end),smo)),'k','linewidth',2),xlim([params.fpass(1) params.fpass(2)])
subplot(2,2,2),
try
hold on,plot(fb(1:pas:end),SmoothDec(Cerrb(1,1:pas:end),smo),'color',[0.7 0.7 0.7],'linewidth',1)
hold on,plot(fb(1:pas:end),SmoothDec(Cerrb(2,1:pas:end),smo),'color',[0.7 0.7 0.7],'linewidth',1)
end
hold on, plot(fb(1:pas:end),SmoothDec(Cb(1:pas:end),smo),'k','linewidth',2)
try
line([params.fpass(1) params.fpass(2)],[confCb confCb],'color','r')
end
xlim([params.fpass(1) params.fpass(2)])
title('Epoch 2')
subplot(2,2,4),
try
hold on, plot(fb(1:pas:end),SmoothDec(phib(1:pas:end)+phistdb(1:pas:end)',smo),'color',[0.7 0.7 0.7])
hold on, plot(fb(1:pas:end),SmoothDec(phib(1:pas:end)-phistdb(1:pas:end)',smo),'color',[0.7 0.7 0.7])
end
try
hold on, plot(fb(1:pas:end),SmoothDec(phib(1:pas:end),smo),'k','linewidth',2)
catch
    hold on, plot(fb(1:pas:end),mean(SmoothDec(phib(1:pas:end),smo)),'k','linewidth',1)
end
xlim([params.fpass(1) params.fpass(2)])
ylim([-pi pi])
end
title(pwd)


try
    Pas;pas=Pas;
catch
pas=10; %MovEpoch;
end
figure('color',[1 1 1]), 
% subplot(2,2,1), plot(fb(1:pas:end),10*log10(SmoothDec(S1b(1:pas:end),5)))
% subplot(2,2,3), plot(fb(1:pas:end),10*log10(SmoothDec(S2b(1:pas:end),5)))
subplot(2,2,1), plot(fc(1:pas:end),(SmoothDec(S1c(1:pas:end),smo)),'k','linewidth',2),title([num2str(n1),' vs. ',num2str(n2)]),xlim([params.fpass(1) params.fpass(2)])
subplot(2,2,3), plot(fc(1:pas:end),(SmoothDec(S2c(1:pas:end),smo)),'k','linewidth',2),xlim([params.fpass(1) params.fpass(2)])
subplot(2,2,2),
try
hold on,plot(fc(1:pas:end),SmoothDec(Cerrc(1,1:pas:end),smo),'color',[0.7 0.7 0.7],'linewidth',1)
hold on,plot(fc(1:pas:end),SmoothDec(Cerrc(2,1:pas:end),smo),'color',[0.7 0.7 0.7],'linewidth',1)
end
hold on, plot(fc(1:pas:end),SmoothDec(Cc(1:pas:end),smo),'k','linewidth',2)
try
line([params.fpass(1) params.fpass(2)],[confCc confCc],'color','r')
end
xlim([params.fpass(1) params.fpass(2)])
title('Epoch 3')
subplot(2,2,4),
try
hold on, plot(fc(1:pas:end),SmoothDec(phic(1:pas:end)+phistdc(1:pas:end)',smo),'color',[0.7 0.7 0.7])
hold on, plot(fc(1:pas:end),SmoothDec(phic(1:pas:end)-phistdc(1:pas:end)',5),'color',[0.7 0.7 0.7])
end
try
hold on, plot(fc(1:pas:end),SmoothDec(phic(1:pas:end),smo),'k','linewidth',2)
catch
    hold on, plot(fc(1:pas:end),mean(SmoothDec(phic(1:pas:end),smo)),'k','linewidth',1)
end
xlim([params.fpass(1) params.fpass(2)])
ylim([-pi pi])
title(pwd)
