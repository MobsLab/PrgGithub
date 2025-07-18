% VmDistribSingleLROK
function [h,h2,probaH,probaH2,VmMoy,STD2,Skew2]=VmDistribSingleLROK


% -----------------------------------------------------------------------
% HistVmLR
% ------------------------------------------------------------------------
% chF:freq de sampling finale

% chF=10;


try
    load DataAdjust
catch


                                try
                                    load data
                                catch
                                    disp 'no data'
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
                                
                       
                        save DataAdjust V tps

                    % -------------------------------------------------------------------------

                    % figure
                    % hist(V,20)
                    % 
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
                        try
                            
                            V2=locdetrend(V,chF,[200,10]);



                                %             figure
                                %             hist(V2,20)
                                % 
                                %                     Num=gcf;
                                % 
                                %                     set(Num,'paperPositionMode','auto')
                                % 
                                %                     eval(['print -f',num2str(Num),' -dpng ','HistVmLoc','.png'])
                                % %                     eval(['print -f',num2str(Num),' -dpng ','HistVm2FIG','.png'])
                                %    
                                % 
                                %                     eval(['print -f',num2str(Num),' -painters',' -depsc2 ','HistVmLoc','.eps'])
                                % %                     eval(['print -f',num2str(Num),' -painters',' -depsc2 ','HistVm2FIG','.eps'])



                                % tps=[0:length(V)-1]/chF;          échelle de temps si nécecssaire

                                % save DataAjustFIG V V2 tps 

                            save DataAdjust -append V2 
                            
                        catch
                            disp 'locdetrend failed'
                        end

end
% -------------------------------------------------------------------------
try 
    
        load VmDistrib
    
catch
        try
                h=hist(V,[-90:0.05:-70]); %distribution du potentiel de mb
                probaH=h/sum(h);

                            % figure, bar([-90:0.05:-70],h/sum(h),1)
                            % xlim([-82 -78])

                            figure, area([-90:0.05:-70],smooth(h/sum(h),3))
                            % xlim([-81.7 -78.7])
                            % ylim([0 0.18])


                            Num=gcf;

                                        set(Num,'paperPositionMode','auto')

                                        eval(['print -f',num2str(Num),' -dpng ','HistVmSmooth','.png'])
                            %             eval(['print -f',num2str(Num),' -dpng ','HistVmFIG','.png'])


                                        eval(['print -f',num2str(Num),' -painters',' -depsc2 ','HistVmSmooth','.eps'])
                            %              eval(['print -f',num2str(Num),' -painters',' -depsc2
                            

                            
        catch
            disp 'HistVmSmooth failed'
        end


        % -------------------------------------------------------------------------
        try
            
                            h2=hist(V2,[-10:0.05:10]);
                            probaH2=h2/sum(h2);

                                        figure, area([-10:0.05:10],smooth(h2/sum(h2),3))
                                        % xlim([-81.7 -78.7])
                                        % ylim([0 0.18])


                                        Num=gcf;

                                                    set(Num,'paperPositionMode','auto')

                                                    eval(['print -f',num2str(Num),' -dpng ','HistVmSmoothLoc','.png'])
                                        %             eval(['print -f',num2str(Num),' -dpng ','HistVmFIG','.png'])


                                                    eval(['print -f',num2str(Num),' -painters',' -depsc2 ','HistVmSmoothLoc','.eps'])
                                        %              eval(['print -f',num2str(Num),' -painters',' -depsc2
                                        
                            
        catch
            disp 'HistVmSmoothLoc failed'
        end
        

        % -------------------------------------------------------------------------

        % save DataAjust V V2 tps   ----> plus haut 
  save VmDistrib h h2 probaH probaH2
        
%         -----------------------------------------------------------------
                try
                    
                    [m,s,e]=MeanDifNan(V);

                            % ne prend pas en compte les valeurs nan
                            % m: mean
                            % s: std
                            % e: SEM: std/racine(n)

                            VmMoy=m;
                            STD=s;
                            Error=e;

                            Skew=skewness(V);
                            
                            save AnalysisV VmMoy STD Error Skew
                end
                
                try
                            
                                 
                     [m,s,e]=MeanDifNan(V2);


                            VmMoy2=m;
                            STD2=s;
                            Error2=e;

                            Skew2=skewness(V2);

                            save AnalysisVLOC VmMoy2 STD2 Error2 Skew2
                end
%                             
                            

end