% CoherencyAstroFieldLR


function [C,CP,f,pb,phi,S1l,S2l,fl,Cerr]=CoherencyMitralField(Fup)


% try
%     fi;
% catch
%     fi=pwd;
% end
% 
% eval(['cd(''',fi,''')'])
    

    
try                                       
load Data
end

try                                       
load DataMCLFP
end



 
F=F-mean(F);
Y=Y-mean(Y);


        colorUp=[207 35 35]/255;
        colorDown=[32 215 28]/255;
        colorBox=[205 225 255]/255; %[197 246 255]/255;

% --------------------------------------------------------------------
% Début figure finale

            figure('Color',[1 1 1])
            subplot(4,1,1)
            [AX,H1,H2] = plotyy(tps,F,tps,Y,'plot');
            set(H1,'Color','b')
            set(AX,'xlim',[tps(1) tps(end)])
            %             xlim([tps(1) tps(end)])
            set(H2,'Color','r')
%             xlim([tps(1) tps(end)])
            set(AX,'xlim',[tps(1) tps(end)])
            
            %             hold on, plot(tps,Y,'b')
%             hold on, plot(tps,F,'r')

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

L = length(Y);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
yf  = fft(Y-mean(Y),NFFT)/L;
fl = chF*1/2*linspace(0,1,NFFT/2+1);

S1l=abs(yf(1:NFFT/2+1));

%-------------------------------------------------------------------------

L = length(F);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
yf  = fft(F-mean(F),NFFT)/L;
fl = chF*1/2*linspace(0,1,NFFT/2+1);

S2l=abs(yf(1:NFFT/2+1));

fl=fl';


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------



%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%--------------------------------------------------------------------------
            % Params coherency:

                try
                    chF;
                catch 
                    chF=1;
                end

            m=200; %movingwin

            % lF=5/data(end,1);
            % limitF=min(lF,0.005);
            
            %limitF=0.05;
            limitF=0;
            
            % Fup=min(1,chF/2);
            % Fup=chF/2;
            try
                Fup;
            catch
            Fup=1;
            end
            
            
            Fpass=[limitF Fup];
            % Fpass=[0 0.5];
            params.fpass = Fpass;

            params.Fs=chF;
            % params.pad=0;
            params.trialave = 0;
            params.err = [2 0.05];

%             params.tapers=[3 5];
            params.tapers=[10 19];

            params.pad=3;

   %--------------------------------------------------------------------------

            [C,phi,S12,S1,S2,f,confC,phierr,Cerr] = coherencyc(Y,F,params);
            % [C, lag] = xcorr(Y,F,'coeff');

            %params.tapers=[3 5];
            %[S1l,fl]=mtspectrumc(Y,params);
            %[S2l,fl]=mtspectrumc(L,params);
            
% figure
            % plot(f,C,'k','linewidth',2)

  %------------------------------------------------------------------------
%   suite figure finale

            subplot(4,1,4), hold on  
            plot(f,C,'r','linewidth',2)
            plot(f,Cerr)

            pb=(smooth(Cerr(1,:),5)>confC);    
            YL=ylim;    
            boxbottom = YL(1);
            boxhight = YL(2);
            tt=pb(2:end).*(1-diff(pb));
            F=f(find(tt==1));
            for i=1:length(F)-1
                rectangle('Position', [F(i) boxbottom 2*median(diff(f)) boxhight-boxbottom], 'LineStyle', 'none', 'FaceColor', colorBox);
            end             
            plot(f,C,'r','linewidth',2)
            plot(f,Cerr)
            line(Fpass,[confC confC],'Color','k')
            

            tempS1=(S1l(fl<Fup&fl>limitF))/max(S1l(fl<Fup&fl>limitF));
            tempS2=(S2l(fl<Fup&fl>limitF))/max(S2l(fl<Fup&fl>limitF));
            
            %tempS1=10*log10(S1l(fl<Fup&fl>limitF));
            %tempS2=10*log10(S2l(fl<Fup&fl>limitF));
            
            
            tempsmo=10;
            
            subplot(4,1,2)
            plot(fl(fl<Fup&fl>limitF),smooth(tempS1,tempsmo),'r','linewidth',2)
            hold on, plot(fl(fl<Fup&fl>limitF),smooth(tempS2,tempsmo),'b','linewidth',2)
            
%             plot(f,10*log10(S1),'r','linewidth',2)
%             hold on, plot(f,10*log10(S2),'b','linewidth',2)

            subplot(4,1,3), hold on
            plot(f,mod(phi,2*pi),'r.','linewidth',2)
            plot(f,mod(phi+phierr,2*pi),'g.')
            plot(f,mod(phi-phierr,2*pi),'b.')
            plot(f,2*pi+mod(phi,2*pi),'r.','linewidth',2)
            plot(f,2*pi+mod(phi+phierr,2*pi),'g.')
            plot(f,2*pi+mod(phi-phierr,2*pi),'b.')
            line(Fpass,[2*pi 2*pi],'Color','k')
            line(Fpass,[4*pi 4*pi],'Color','k')
            
            YL=ylim;    
            boxbottom = 0;
            boxhight = 4*pi;

            for i=1:length(F)-1
                rectangle('Position', [F(i) boxbottom 2*median(diff(f)) boxhight-boxbottom], 'LineStyle', 'none', 'FaceColor', colorBox);
            end
            
            plot(f,mod(phi,2*pi),'r.','linewidth',2)
            plot(f,mod(phi+phierr,2*pi),'g.')
            plot(f,mod(phi-phierr,2*pi),'b.')
            plot(f,2*pi+mod(phi,2*pi),'r.','linewidth',2)
            plot(f,2*pi+mod(phi+phierr,2*pi),'g.')
            plot(f,2*pi+mod(phi-phierr,2*pi),'b.')
            line(Fpass,[2*pi 2*pi],'Color','k')
            line(Fpass,[4*pi 4*pi],'Color','k')          
            ylim([0 4*pi])

            % saveFigure(1,'Crosscorrelogram',pwd);

            % Output:
            %         C (magnitude of coherency - frequencies x trials if trialave=0; dimension frequencies if trialave=1)
            %         phi (phase of coherency - frequencies x trials if trialave=0; dimension frequencies if trialave=1)
            %         S12 (cross spectrum -  frequencies x trials if trialave=0; dimension frequencies if trialave=1)
            %         S1 (spectrum 1 - frequencies x trials if trialave=0; dimension frequencies if trialave=1)
            %         S2 (spectrum 2 - frequencies x trials if trialave=0; dimension frequencies if trialave=1)
            %         f (frequencies)
            %         confC (confidence level for C at 1-p %) - only for err(1)>=1
            %         phierr (error bars for phi) - only for err(1)>=1
            %         Cerr  (Jackknife error bars for C - use only for Jackknife - err(1)=2)

            %--------------------------------------------------------------------------

            Num=gcf;
            
            set(Num,'paperPositionMode','auto')

            eval(['print -f',num2str(Num),' -dpng ','Cohenrency1','.png'])
            % eval(['print -f',num2str(1),' -dpng ','CrossCorr','.png'])

            eval(['print -f',num2str(Num),' -painters',' -depsc2 ','Cohenrency1','.eps'])
            % eval(['print -f',num2str(1),' -painters',' -depsc2 ','CrossCorr','.eps'])
            
            

if 0

figure('Color',[1 1 1])
hold on

plot(f,C,'r','linewidth',2)
% plot(f,Cerr)

pb=(smooth(Cerr(1,:),5)>confC);   
% p=(C>confC);    
YL=ylim;    
boxbottom = YL(1);
boxhight = YL(2);
tt=pb(2:end).*(1-diff(pb));
F=f(find(tt==1));
for i=1:length(F)-1
    rectangle('Position', [F(i) boxbottom 2*median(diff(f)) boxhight-boxbottom], 'LineStyle', 'none', 'FaceColor', colorBox);
end             
plot(f,C,'r','linewidth',2)
% plot(f,Cerr)
line(Fpass,[confC confC],'Color','k')
xlim(Fpass)


ft=f(pb==1);
Ct=C(pb==1);
Pt=phi(pb==1);
Pit=phierr(pb==1);
fac=2;

for i=1:10:length(find(pb==1))

    arrow([ft(i) Ct(i)],[ft(i)+Pit(i)/fac*cos(Pt(i)) Ct(i)+Pit(i)/fac*sin(Pt(i))],'length',5)

end

xlabel('Frequency (Hz)')
ylabel('Coherence')

Num=gcf;

set(Num,'paperPositionMode','auto')

eval(['print -f',num2str(Num),' -dpng ','Cohenrency2','.png'])
% eval(['print -f',num2str(1),' -dpng ','CrossCorr','.png'])

eval(['print -f',num2str(Num),' -painters',' -depsc2 ','Cohenrency2','.eps'])
         
% close all

end


  CP=C;
  CP(pb==0)=0;
  
  
  
%-------------------------------------------------------------------------  
%-------------------------------------------------------------------------  



%-------------------------------------------------------------------------
%-------------------------------------------------------------------------


% S1l=10*log10(S1);
% S2l=10*log10(S2);

  
  save Coherency C CP pb phi S12 S1 S2 S1l S2l f confC phierr Cerr params  
            
%    else
%     
%     disp('Pas de LFP')
% end

% clear fi
