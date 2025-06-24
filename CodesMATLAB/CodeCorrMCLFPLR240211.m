load DataVM10512002

       
       
       
lfp=data(:,3);

% --------------------------------------------------------------------
temp=[lfp(1)*ones(500000,1); lfp(:); lfp(end)*ones(500000,1)];
LFP=resample(temp,1,100);
LFP=LFP(5001:end-5000);
 [b,a]=butterlow1(2/100);
    LFPf = filtfilt(b,a,[LFP(1)*ones(5000,1); LFP; LFP(end)*ones(5000,1)]);
                %pour virer la baseline
                %filtre passe bas (0,005Hz)
                if tps(end)>500
                [b,a]=butterlow1(0.05/100);
                else if tps(end)>100&tps(end)<500
                        [b,a]=butterlow1(0.5/100);
                    else
                        [b,a]=butterlow1(1/100);
                    end
                end
                LFPf2 = filtfilt(b,a,LFPf);
                %valeurs filtrées: dEeg
                %échelle de temps recalculée
LFPf=LFPf(5001:end-5000);
LFPf2=LFPf2(5001:end-5000);
nomL='10512002';
[b,a]=butterlow1(2/100);
    LFPf = filtfilt(b,a,[LFP(1)*ones(5000,1); LFP; LFP(end)*ones(5000,1)]);
                %pour virer la baseline
                %filtre passe bas (0,005Hz)
                if tps(end)>500
                [b,a]=butterlow1(0.05/100);
                else if tps(end)>100&tps(end)<500
                        [b,a]=butterlow1(0.5/100);
                    else
                        [b,a]=butterlow1(1/100);
                    end
                end
                LFPf2 = filtfilt(b,a,LFPf);
                %valeurs filtrées: dEeg
                %échelle de temps recalculée
LFPf=LFPf(5001:end-5000);
LFPf2=LFPf2(5001:end-5000);
%eval(['save DataLFP',nomL,' LFP lfp LFPf LFPf2'])


% ----------------------------------------------------------------------
F=LFPf2;
Y=dEeg2;
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
        
        
  %      save Crosscorr C lag lags Cp CRm CRM Ch Chs tps r p
        % saveFigure(1,'Crosscorrelogram',pwd);
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
        Num=gcf;
        
%        set(Num,'paperPositionMode','auto')
%        eval(['print -f',num2str(Num),' -dpng ','CrossCorr','.png'])
%        eval(['print -f',num2str(Num),' -painters',' -depsc2 ','CrossCorr','.eps'])

