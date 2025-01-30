% CorrAstroFieldforLoopLR


function [Co,Cp,P,lags,CRm,CRM,r,p]=CorrMitralField




try                                       
    load Data
end

try
    load DataMCLFP
end







            [Co,lag] = xcorr(F,Y,'coeff'); % ref: F= field
 
            
                lags=lag/chF;

%         figure('Color',[1 1 1])
%         % plot(lags(lags>-100&lags<100),C(lags>-100&lags<100),'k','linewidth',2)
%         plot(lags(lags>-tfin/3&lags<tfin/3),C(lags>-tfin/3&lags<tfin/3),'k','linewidth',2)

        %--------------------------------------------------------------------------
        %Statistiques par bootstrap

        CR=[];
        
        for i=1:100
            [Cr, lagr] = xcorr(F(randperm(length(F))),Y(randperm(length(Y))),'coeff');
            % [C, lag] = xcorr(Y,F,'coeff');
            lagsr=lagr/chF;
            CR=[CR,Cr];

        end

        CRM=max(CR')';
        CRm=min(CR')';

        Cp=Co;
        Cp(find(Co>CRm&Co<CRM))=0;

        P=ones(length(Co),1);
        P(find(Co>CRm&Co<CRM))=0;        
        
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
%         pour un lag de Zero
        
               [r, p] = corrcoef(F,Y);
               r=r(1,2);
               p=p(1,2);
               
               
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
        
        decal=2;
        
        tfin=tps(end);
        
        figure('Color',[1 1 1])
        hold on
        % plot(lags(lags>-100&lags<100),C(lags>-100&lags<100),'k','linewidth',2)
        plot(lagsr(lagsr>-tfin/decal&lagsr<tfin/decal),CRM(lagsr>-tfin/decal&lagsr<tfin/decal),'Color',[0.7 0.7 0.7],'linewidth',2)
        plot(lagsr(lagsr>-tfin/decal&lagsr<tfin/decal),CRm(lagsr>-tfin/decal&lagsr<tfin/decal),'Color',[0.7 0.7 0.7],'linewidth',2)
        plot(lags(lags>-tfin/decal&lags<tfin/decal),Co(lags>-tfin/decal&lags<tfin/decal),'k','linewidth',2)

        Ch=hilbert(Co);
        Ch=abs(Ch);
        Chs=SmoothDec(Ch,40);
        Chsp=Chs(lags>-tfin/decal&lags<tfin/decal);
        Chp=Ch(lags>-tfin/decal&lags<tfin/decal);
        
        plot(lags(lags>-tfin/decal&lags<tfin/decal),Chp,'r--')
        plot(lags(lags>-tfin/decal&lags<tfin/decal),Chsp,'r','linewidth',2)
        yl=ylim;
        line([0 0],[yl(1) yl(2)],'Color','k')
        xlim([-tfin/decal tfin/decal])
        xlabel('Delay from LFP (s)')
        title(['Correlation a zero lag=',num2str(r),',  p=',num2str(p)])
        

        
        save Crosscorr Co lag lags Cp CRm CRM Ch Chs tps r p
        % saveFigure(1,'Crosscorrelogram',pwd);

        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------

        Num=gcf;
        
        set(Num,'paperPositionMode','auto')

        eval(['print -f',num2str(Num),' -dpng ','CrossCorr','.png'])

        eval(['print -f',num2str(Num),' -painters',' -depsc2 ','CrossCorr','.eps'])
        
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
        
        delays=100;
        
        figure('Color',[1 1 1])
        hold on
        % plot(lags(lags>-100&lags<100),CRM(lags>-100&lags<100),'k','linewidth',2)
        % plot(lags(lags>-100&lags<100),CRm(lags>-100&lags<100),'k','linewidth',2)
        % plot(lags(lags>-100&lags<100),C(lags>-100&lags<100),'k','linewidth',2)
       
        plot(lagsr(lagsr>-delays&lagsr<delays),CRM(lagsr>-delays&lagsr<delays),'Color',[0.7 0.7 0.7],'linewidth',2)
        plot(lagsr(lagsr>-delays&lagsr<delays),CRm(lagsr>-delays&lagsr<delays),'Color',[0.7 0.7 0.7],'linewidth',2)
        plot(lags(lags>-delays&lags<delays),Co(lags>-delays&lags<delays),'k','linewidth',2)

        Ch=hilbert(Co);
        Ch=abs(Ch);
        Chs=SmoothDec(Ch,40);
        Chsp=Chs(lags>-delays&lags<delays);
        Chp=Ch(lags>-delays&lags<delays);
        
        plot(lags(lags>-delays&lags<delays),Chp,'r--')
        plot(lags(lags>-delays&lags<delays),Chsp,'r','linewidth',2)
        yl=ylim;
        line([0 0],[yl(1) yl(2)],'Color','k')
        xlim([-delays delays])
        xlabel('Delay from LFP (s)')
        title(['Correlation a zero lag=',num2str(r),',  p=',num2str(p)])
        
                Num=gcf;
        
        set(Num,'paperPositionMode','auto')

        eval(['print -f',num2str(Num),' -dpng ','CrossCorr2','.png'])

        eval(['print -f',num2str(Num),' -painters',' -depsc2 ','CrossCorr2','.eps'])
        
%  ------------------------------------------------------------------------
% -------------------------------------------------------------------------

     delays=200;
        
        figure('Color',[1 1 1])
        hold on
        % plot(lags(lags>-100&lags<100),CRM(lags>-100&lags<100),'k','linewidth',2)
        % plot(lags(lags>-100&lags<100),CRm(lags>-100&lags<100),'k','linewidth',2)
        % plot(lags(lags>-100&lags<100),C(lags>-100&lags<100),'k','linewidth',2)
       
        plot(lagsr(lagsr>-delays&lagsr<delays),CRM(lagsr>-delays&lagsr<delays),'Color',[0.7 0.7 0.7],'linewidth',2)
        plot(lagsr(lagsr>-delays&lagsr<delays),CRm(lagsr>-delays&lagsr<delays),'Color',[0.7 0.7 0.7],'linewidth',2)
        plot(lags(lags>-delays&lags<delays),Co(lags>-delays&lags<delays),'k','linewidth',2)

        Ch=hilbert(Co);
        Ch=abs(Ch);
        Chs=SmoothDec(Ch,40);
        Chsp=Chs(lags>-delays&lags<delays);
        Chp=Ch(lags>-delays&lags<delays);
        
        plot(lags(lags>-delays&lags<delays),Chp,'r--')
        plot(lags(lags>-delays&lags<delays),Chsp,'r','linewidth',2)
        yl=ylim;
        line([0 0],[yl(1) yl(2)],'Color','k')
        xlim([-delays delays])
        xlabel('Delay from LFP (s)')
        title(['Correlation a zero lag=',num2str(r),',  p=',num2str(p)])
        
                Num=gcf;
        
        set(Num,'paperPositionMode','auto')

        eval(['print -f',num2str(Num),' -dpng ','CrossCorr3','.png'])

        eval(['print -f',num2str(Num),' -painters',' -depsc2 ','CrossCorr3','.eps'])
        
        
% close all
               

% else
%     
%     disp('Pas de LFP')
% end

% clear fi
