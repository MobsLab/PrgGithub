


%  ParcoursFilesLisaAstroInOut
% -------------------------------------------------------------------------


%InOut='In'
InOut='Ou'

%In

if InOut=='In'
filename='/Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/Data_Astros_Field_KarimLaaaassssttttt/Data_Astros_Field';
else
%Out
% filename='/Users/karimbenchenane/Dropbox/Lisa/Data_Astros/Astros_OUT';
filename='/Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/DataInOut/DataAstro_OUT'; 
end



% -------------------------------------------------------------------------

eval(['cd(''',filename,''')'])

% try
%     
%     cd /Users/karimbenchenane/Dropbox/Lisa/Data_Astros
%     
%     %load AnalysisAstro_In_Out_Mai2011_IN_Filter
%     mload AnalysisAstro_In_Out_Mai2011_OUT_Filter
% 
%         %load AnalysisAstro_In_Out_Mai2011_IN
%     %load AnalysisAstro_In_Out_Mai2011_OUT
%     
%     
%     eval(['cd(''',filename,''')'])
%     
% catch

        eval(['cd(''',filename,''')'])
        Fup=3;
        chF=10;
        binSpectTotal=[];
        binSpectTotal2=[];
        cellnames={};
        j=1;
        listdir=dir;

        for i=1:length(listdir)

                eval(['cd(''',filename,''')'])

                if listdir(i).isdir==1&listdir(i).name(1)~='.'

                            eval (['cd ',listdir(i).name])
                            nom=listdir(i).name;
                            le=length(listdir(i).name);

                                %% -------------------------------------------------------------------------                                        
                                % -------------------------------------------------------------------------                                        
                                % A faire dans la boucle
                                % -------------------------------------------------------------------------
                                % -------------------------------------------------------------------------                                        

%                                 try

                                    if InOut=='In'
                                        try
                                            load DataCompLFP10
                                            Y;
                                            L = length(Y);
                                            NFFT = 2^nextpow2(L); % Next power of 2 from length of y
                                            yf  = fft(Y,NFFT)/L;
                                            f = chF*1/2*linspace(0,1,NFFT/2+1);
                                            spe=abs(yf(1:NFFT/2+1));
                                            Fup=3;

                                            Fpass=[0 Fup];
                                            % Fpass=[0 0.5];
                                            params.Fs=chF;
                                            params.tapers=[3 5];
                                            params.err = [2 0.01];
                                            params.fpass = Fpass;
                                            if length(Y)>5E5
                                                [S2,f2,Serr2]=mtspectrumc(Y(1:5E5),params);
                                            else
                                                [S2,f2,Serr2]=mtspectrumc(Y,params);
                                            end
                                        end
                                    else
                                                try
                                                    load DataAdjust10
                                                    Y=V2;
                                                    L = length(Y);
                                                    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
                                                    yf  = fft(Y,NFFT)/L;
                                                    f = chF*1/2*linspace(0,1,NFFT/2+1);
                                                    spe=abs(yf(1:NFFT/2+1));
                                                    Fup=3;

                                                    Fpass=[0 Fup];
                                                    % Fpass=[0 0.5];
                                                    params.tapers=[3 5];
                                                    params.Fs=chF;
                                                    params.err = [2 0.01];
                                                    params.fpass = Fpass;
                                                    if length(Y)>5E5
                                                        [S2,f2,Serr2]=mtspectrumc(Y(1:5E5),params);
                                                    else
                                                        [S2,f2,Serr2]=mtspectrumc(Y,params);
                                                    end
        
                                    
                                                catch
                                            
                                                    [yf,f,spe,f2,S2,Serr2,Serr2a,Serr2b,S3,t3,f3,C,lag,lags]=PowerSpectrumLR011010(chF);
                                                    load DataAdjust10
                                                    Y=V2;
                                  
                                                end
                                                
                                    end

%                                     try  
                                    %MeanVm=mean(V);
                                    StandDev=std(Y);
                                    
                                    [m,s,e]=MeanDifNan(Y);
                                    StandDev=m;
                                    
                                    MaxAmp=max(Y)-min(Y);
                                    
                                    %MeanVmTotal(j)=mean(V);
                                    
                                    
                                    Freq=[0:0.005:Fup];
                                    %Freq=[0:0.01:Fup];
                                    
                                    [binSpect,lSpect]=PoolData(spe(f<Fup),f(f<Fup),Freq);
                                    [binSpect2,lSpect2]=PoolData(S2(f2<Fup),f2(f2<Fup),Freq);
                                    
                                    
                                    if length(binSpect)>1
                                        binSpectTotal=[binSpectTotal;binSpect];
                                        binSpectTotal2=[binSpectTotal2;binSpect2];
                                        cellnames{j}=nom;
                                        StandDevTotal(j)=std(Y);
                                        MaxAmpTotal(j)=max(Y)-min(Y);
                                        j=j+1; 
                                    
                                    end
                                    
                                    %save SpectrumInOut f yf spe StandDev MaxAmp binSpect lSpect Freq chF
                                    
                                   save SpectrumInOutMai2010 f yf spe f2 S2 StandDev MaxAmp binSpect lSpect binSpect2 lSpect2 Freq chF
                                                  
%                                     end
                                     
                                    
                                    
%                                 catch
%                                     
%                                     keyboard
                                 
                end
                                



        % -------------------------------------------------------------------------                                        
        % -------------------------------------------------------------------------
        % -------------------------------------------------------------------------



        end
                
        


%         cd /Users/karimbenchenane/Dropbox/Lisa/Data_Astros/ 
    cd /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/DataInOut/

    if InOut=='In'
    
        save AnalysisAstro_In_Out_Mai2011_In
    else
        save AnalysisAstro_In_Out_Mai2011_Out
        
    end

        
%         eval(['cd(''',filename,''')'])

% end



%% -----------------------------------------------------------------------
% ------------------------------------------------------------------------
% Modification Karim
% ------------------------------------------------------------------------
% ------------------------------------------------------------------------


figure, imagesc(Freq,[1:size(binSpectTotal,1)],zscore(binSpectTotal')')
hold on, plot(StandDevTotal/10,[1:size(binSpectTotal,1)],'k','linewidth',2)

% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
% ------------------------------------------------------------------------





            %save AnalysisAstro_In_Out_Mai2011_IN
%         save AnalysisAstro_In_Out_Mai2011_OUT
    %save AnalysisAstro_In_Out_Mai2011_IN_Filter
        %save AnalysisAstro_In_Out_Mai2011_OUT_Filter

        %save AnalysisAstro_In_Out_Mai2011_IN_FilterUH
        %save AnalysisAstro_In_Out_Mai2011_OUT_FilterUH


                                    %Filter
                                    
%                                     if 1
%                                         
% %                                         freqCh=[0.05 0.5];
%                                         freqCh=[[0.02 0.2]];
%                                             try
%                                                 Yf=FilterLFP(tsd(tps*1E4,Y),freqCh,96);
%                                             end
% 
%                                             try
%                                                 Yf=FilterLFP(tsd(tps*1E4,Y),freqCh,128);
%                                             end
%                                             try
%                                                 Yf=FilterLFP(tsd(tps*1E4,Y),freqCh,512);
%                                             end
%                                             try
%                                                 Yf=FilterLFP(tsd(tps*1E4,Y),freqCh,1024);
%                                             end    
% 
%                                             try
%                                                 Y=Data(Yf);
%         %                                     catch
%         %                                         keyboard
%                                             end
% 
%                                     
%                                     
%                                     end





