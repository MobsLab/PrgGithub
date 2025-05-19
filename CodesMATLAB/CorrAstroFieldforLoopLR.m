% CorrAstroFieldforLoopLR


function [C,Cp,P,lags,CRm,CRM,r,p]=CorrAstroFieldforLoopLR(chF)


% try
%     fi;
% catch
%     fi=pwd;
% end

% eval(['cd(''',fi,''')'])


try                                       
    load Data
end

try
    load DataCompLFP10
end

try
    load DataAdjust    
end


% voie=2;
% 
% 
% if nbtraces>1
% 
%     try 
%           
%         load('fi\DataCompLFP')
%         eval(['load(',fi,'\DataCompLFP)'])
%         load(strcat(fi,'\DatacompLFP'))
%           load DataCompLFP
%         load ([fi,'\DataCompLFP'])
%     
%     catch
% %         attention il y a un 'end'!
%         
%         try
%                 disp('Calcul')
% 
%                         try
%                             chF;
%                         catch
% 
%             %               chF=50;    %freqce voulue finale en Hz, pas trop loin de la freqce qu'on veut analyser
%                             chF=1;
%                         end
% 
%                     resamp=10000/chF;
% 
% 
%                     Y=resample(data(:,2),1,resamp);
%                     %resample d'un facteur 1/resamp, doit rester un facteurs de 10, ou des
%                     %entiers
%                     F=resample(data(:,3),1,resamp);
% 
% 
%                     Y=smooth(Y,5);                      %pour enlever le 50Hz,pour virer le bruit
%                     F=smooth(F,5);
% 
%                     Y=Y(20:end-20);                     % pour éviter les effets de bords
%                     F=F(20:end-20);
%                     tps=[0:length(Y)-1]/chF;
%                     % dataRes=[[0:length(Y)-1]'/chF, Y,F];   %matrice resamplée à 50Hz, temps rééchantillonné
% 
%                     %--------------------------------------------------------------------------
%                     % Pour ajuster la baseline: moyenne locale sur une fenêtre de 200sec,
%                     % décalage de 10sec à chaque itération
% 
%                     Y=locdetrend(Y,chF,[200,10]);                                   
%                     F=locdetrend(F,chF,[200,10]);  
% 
%                     % Fs           (sampling frequency) - optional. Default 1
%                     % movingwin    (length of moving window, and stepsize) [window winstep] -
%                     % optional. Ici 200 et 10
% 
% 
%                     % dataBas=[[0:length(Y)-1]'/chF, Y,F];
%                 %----------------------------------------------------------------------
%         %     Ajustement manuel des limites de l'enregistrement à analyser
% 
% 
%                     figure('Color',[1 1 1]),
%                     plot(Y)
%                     hold on, plot(F,'r')
%                     s=input('Do you want to adjust the data (y:n)? ','s');
%                     if s=='y'
%                     limInf=input('limite inf= ');
%                     limSup=input('limite sup= ');
%                     else
%                     limInf=[];
%                     limSup=[];                
%                     end
% 
%                     if length(limInf)==0;
%                     limInf=1;
%                     end
% 
%                     if length(limSup)==0;
%                     limSup=length(F);
%                     end
% 
%                     Y=Y(limInf:limSup);
%                     F=F(limInf:limSup);
%                     tps=tps(limInf:limSup);
% 
% 
%                     save DataCompLFP Y F tps chF
%                     close
%  
%         end
% 
%     end
% end
    
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
%         Crosscorrelogramme

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
        plot(lags(lags>-delays&lags<delays),C(lags>-delays&lags<delays),'k','linewidth',2)

        Ch=hilbert(C);
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
        plot(lags(lags>-delays&lags<delays),C(lags>-delays&lags<delays),'k','linewidth',2)

        Ch=hilbert(C);
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
