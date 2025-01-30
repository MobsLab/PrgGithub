%          Crosscorrelogramme

            [C,lag] = xcorr(F,Y,'coeff'); % ref: F= field
            try   
                chF;
            catch
            chF=1;
            end
            
                lags=lag/chF;

%         figure('Color',[1 1 1])
%         % plot(lags(lags>-100&lags<100),C(lags>-100&lags<100),'k','linewidth',2)
%         plot(lags(lags>-tfin/3&lags<tfin/3),C(lags>-tfin/3&lags<tfin/3),'k','linewidth',2)

        %--------------------------------------------------------------------------
        %Statistiques par bootstrap

        CR=[];
        
        for i=1:1000
            [Cr, lagr] = xcorr(F(randperm(length(F))),Y(randperm(length(Y))),'coeff');
            % [C, lag] = xcorr(Y,F,'coeff');
            lagsr=lagr/chF;
            CR=[CR,Cr];

        end

        CRM=max(CR')';
        CRm=min(CR')';

        Cp=C;
        Cp(find(C>CRm&C<CRM))=0;

        P=ones(length(C),1);
        P(find(C>CRm&C<CRM))=0;        
        
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
        plot(lags(lags>-tfin/decal&lags<tfin/decal),C(lags>-tfin/decal&lags<tfin/decal),'k','linewidth',2)

        Ch=hilbert(C);
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
        

        
        save Crosscorr C lag lags Cp CRm CRM Ch Chs tps r p
        % saveFigure(1,'Crosscorrelogram',pwd);

        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------

        Num=gcf;
        
        set(Num,'paperPositionMode','auto')

        eval(['print -f',num2str(Num),' -dpng ','CrossCorr','.png'])

        eval(['print -f',num2str(Num),' -painters',' -depsc2 ','CrossCorr','.eps'])