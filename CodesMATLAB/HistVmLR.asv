% HistVmLR
% chF:freq de sampling finale

% chF=10;

            try
                load data
            end

V=data(:,2);
V=smooth(V,5);      %pour enlever le 50Hz,pour virer le bruit

            try
                chF;
            catch
                % chF=50;    %freqce voulue finale en Hz, pas trop loin de la freqce qu'on veut analyser
                chF=1;
            end

resamp=10000/chF;
V=resample(V,1,resamp);
            %resample d'un facteur 1/resamp, doit rester un facteurs de 10, ou des
            %entiers
            
V=V(20:end-20);

tps=[0:length(V)-1]/chF;


            figure('Color',[1 1 1]),
            plot(V)

            s=input('Do you want to adjust the data (y:n)? ','s');
            if s=='y'
            limInf=input('limite inf= ');
            limSup=input('limite sup= ');
            else
            limInf=[];
            limSup=[];                
            end
            
            if length(limInf)==0;
            limInf=1;
            end

            if length(limSup)==0;
            limSup=length(V);
            end

            V=V(limInf:limSup);
            tps=tps(limInf:limSup);
            
            close all
            figure('Color',[1 1 1]),
            plot(V)
            
            

% -------------------------------------------------------------------------
            
figure
hist(V,20)

%             Num=gcf;
% 
%             set(Num,'paperPositionMode','auto')
% 
%             eval(['print -f',num2str(Num),' -dpng ','HistVm','.png'])
% %             eval(['print -f',num2str(Num),' -dpng ','HistVmFIG','.png'])
%            
% 
%             eval(['print -f',num2str(Num),' -painters',' -depsc2 ','HistVm','.eps'])
% %              eval(['print -f',num2str(Num),' -painters',' -depsc2 ','HistVmFIG','.eps']) 


% skewness??? bimodal???




% -------------------------------------------------------------------------

            V2=locdetrend(V,chF,[200,10]);



%             figure
%             hist(V2,20)
% 
%                     Num=gcf;
% 
%                     set(Num,'paperPositionMode','auto')
% 
%                     eval(['print -f',num2str(Num),' -dpng ','HistVm2','.png'])
% %                     eval(['print -f',num2str(Num),' -dpng ','HistVm2FIG','.png'])
%    
% 
%                     eval(['print -f',num2str(Num),' -painters',' -depsc2 ','HistVm2','.eps'])
% %                     eval(['print -f',num2str(Num),' -painters',' -depsc2 ','HistVm2FIG','.eps'])

            

% tps=[0:length(V)-1]/chF;          échelle de temps si nécecssaire
          
% save DataAjustFIG V V2 tps 

save DataAjust V V2 tps 