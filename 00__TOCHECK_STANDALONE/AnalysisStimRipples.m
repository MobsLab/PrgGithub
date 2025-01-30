
function [ripStim, STIMRIP]=AnalysisStimRipples(LFP,v,Epoch, v2)


FilRip=FilterLFP(Restrict(LFP{v},Epoch),[130 200],96);
rgFil=Range(FilRip,'s');
filtered=[rgFil-rgFil(1) Data(FilRip)];


%filtered=[Range(FilRip,'s') Data(FilRip)];

[ripples,stdev,noise] = FindRipples(filtered,'thresholds',[3 5]);
%[maps,data,stats] = RippleStats(filtered,ripples);
%PlotRippleStats(ripples,maps,data,stats)

ripEvt=intervalSet((ripples(:,2)+rgFil(1)-0.1)*1E4,(ripples(:,2)+rgFil(1)+0.1)*1E4);

 try
        v2;
        
    PlotRipRaw(Restrict(LFP{v},Epoch),ripples)
    PlotRipRaw(Restrict(LFP{v2},Epoch),ripples)
    
        FilRip2=FilterLFP(Restrict(LFP{v2},Epoch),[130 200],96);
        rgFil2=Range(FilRip2,'s');
        filtered2=[rgFil2-rgFil2(1) Data(FilRip2)];

        figure('Color',[1 1 1]),
    num=gcf;
    for k=1:length(Start(ripEvt))
        
        figure(num), clf
        subplot(2,1,1),
        rgg1=Range(Restrict(FilRip,subset(ripEvt,k)),'s');
        hold on, plot(rgg1-rgg1(1),5*Data(Restrict(FilRip,subset(ripEvt,k))),'r','linewidth',2)
        rgg2=Range(Restrict(LFP{v},subset(ripEvt,k)),'s');
        plot(rgg2-rgg2(1),Data(Restrict(LFP{v},subset(ripEvt,k))),'k','linewidth',3)
%	ca=caxis;
%	xl=xlim;
%	yl=ylim;
%	line([Range(Restrict(stim,Epoch))-rgg1(1)-rgFil(1) Range(Restrict(stim,Epoch))-rgg1(1)-rgFil(1)], yl,'color','k')
%	xlim(xl)
        title(num2str(k))

        subplot(2,1,2),
        rgg3=Range(Restrict(FilRip2,subset(ripEvt,k)),'s');
        hold on, plot(rgg3-rgg3(1),5*Data(Restrict(FilRip2,subset(ripEvt,k))),'b','linewidth',2)
        rgg4=Range(Restrict(LFP{v2},subset(ripEvt,k)),'s');
        plot(rgg4-rgg4(1),Data(Restrict(LFP{v2},subset(ripEvt,k))),'k','linewidth',3)
        %pause(1)
%    	ca=caxis;
%	xl=xlim;
%	yl=ylim;
%	line([Range(Restrict(stim,Epoch))-rgg3(1)-rgFil(1) Range(Restrict(stim,Epoch))-rgg3(1)-rgFil(1)], yl,'color','k')
%	xlim(xl)
        
    ripStim(k)=input('No Ripples (0), Ripples sans stim (1), ou avec Stim (2) : ');
        
    end
    
    
       
    
    
    
catch
    
    PlotRipRaw(Restrict(LFP{v},Epoch),ripples)
    
    figure('Color',[1 1 1]),
    num=gcf;
    for k=1:length(Start(ripEvt))
    figure(num),clf
    rgg5=Range(Restrict(FilRip,subset(ripEvt,k)),'s');
    hold on, plot(rgg5,5*Data(Restrict(FilRip,subset(ripEvt,k))),'r','linewidth',2)
    rgg6=Range(Restrict(LFP{v},subset(ripEvt,k)),'s');
    plot(rgg6,Data(Restrict(LFP{v},subset(ripEvt,k))),'k','linewidth',3)
    title(num2str(k))
    
    %pause(1)
    ripStim(k)=input('No Ripples : 0, Ripples sans stim (1) ou avec Stim (2) : ');
        
    end
    
 end

 
 ripEvt=subset(ripEvt,find(ripStim>0));
 
 nbSTIMrip=0;
 nbRIPstim=0;
for i=1:length(Start(ripEvt))

a=length(Range(Restrict(stim3,subset(ripEvt,i))));
if a>1
    nbRIPstim=nbRIPstim+1;
    nbSTIMrip=nbSTIMrip+a;
end

end
 
nbRip=length(Start(ripEvt));
nbStim=length(Range(stim3));


STIMRIP=[nbRip nbRIPstim nbStim nbSTIMrip];
