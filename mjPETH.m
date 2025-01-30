function [A,B,C]=mjPETH(tref,tx,ty,binSize,nBins,smo,plo)

% [A,B,C]=mjPETH(tref,tx,ty,binSize,nBins,smo,plo)

try
    smo;
catch
    smo=0.5;
end

try
    plo;
catch
    plo=1;
end

[A,B]=JPETH(tref,tx,ty,binSize,nBins);

if plo>=1
    
    figure('color',[1 1 1]),
    
    subplot(3,3,[4 5 7 8]), hold on,
    if smo>0
        imagesc(B/1E3,B/1E3,SmoothDec(full(A),[smo smo]))%, axis xy
    else
        imagesc(B/1E3,B/1E3,full(A))%, axis xy
    end
    line([B(1) B(end)]/1E3,[0 0],'color','w'),
    line([0 0],[B(1) B(end)]/1E3,'color','w')
    xlim([B(1) B(end)]/1E3)
    ylim([B(1) B(end)]/1E3)
    
    if plo==2
        fa=(binSize*nBins)/2000;
        fa=fa/0.5;
        text(-0.48*fa,0.45*fa,'2->1->3','colo','w')
        text(0.32*fa,0.45*fa,'1->2->3','colo','w')
        text(-0.48*fa,-0.45*fa,'3->2->1','colo','w')
        text(0.32*fa,-0.45*fa,'3->1->2','colo','w')
    end
    
    
    subplot(3,3,[1 2]), hold on
    if smo>0
        plot(B/1E3,SmoothDec(mean(full(A)),smo/2),'k','linewidth',2)
    else
        plot(B/1E3,mean(full(A)),'k','linewidth',2)
    end
    xlim([B(1) B(end)]/1E3)
    yl=ylim;
    line([0 0], yl,'color',[0.7 0.7 0.7])
    subplot(3,3,[6 9]), hold on
    if smo>0
        plot(SmoothDec(mean(full(A')),smo/2),B/1E3,'k','linewidth',2)
    else
        plot(mean(full(A')),B/1E3,'k','linewidth',2)
    end
    
    ylim([B(1) B(end)]/1E3)
    xl=xlim;
    line(xl,[0 0],'color',[0.7 0.7 0.7])
    
    if 1
        [C,b]=CrossCorr(tx,ty,binSize,nBins);
        subplot(3,3,3), hold on,
        if smo>0
            plot(b/1E3,SmoothDec(full(C),smo/2),'k','linewidth',1)
        else
            plot(b/1E3,full(C),'k','linewidth',1)
        end
        xlim([B(1) B(end)]/1E3)
        yl=ylim;
        line([0 0], [0 yl(2)],'color',[0.7 0.7 0.7])
        ylim([0 yl(2)])
        
    else
        
        C=[];
    end
    
    figure('color',[1 1 1]),
    subplot(3,3,[4 5 7 8]), imagesc(B,B,SmoothDec(A(:,end:-1:1),[smo,smo])),axis xy, yl=ylim;  xl=xlim;line([0 0],yl,'color','w'),line(xl,[0 0],'color','w')
    [C,B]=CrossCorr(tx,tref,binSize,nBins);
    subplot(3,3,1:2), plot(B,SmoothDec(C,smo/2),'k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), xlim([B(1),B(end)]), ylim(yl)
    [C,B]=CrossCorr(ty,tref,binSize,nBins);
    subplot(3,3,[6 9]), plot(SmoothDec(C(end:-1:1),smo/2),B,'k','linewidth',2), xl=xlim; line(xl,[0 0],'color','r'), ylim([B(1),B(end)]), xlim(xl)
     if 0
        [C,b]=CrossCorr(ty,tx,binSize,nBins);
        subplot(3,3,3), hold on,
        if smo>0
            plot(b/1E3,SmoothDec(full(C),smo/2),'k','linewidth',1)
        else
            plot(b/1E3,full(C),'k','linewidth',1)
        end
        xlim([B(1) B(end)]/1E3)
        yl=ylim;
        line([0 0], [0 yl(2)],'color',[0.7 0.7 0.7])
        ylim([0 yl(2)])
     end
    
end

try
    C;
catch
    C=[];
end



