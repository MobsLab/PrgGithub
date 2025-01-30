%  ParcoursFilesLisa
% -------------------------------------------------------------------------

try
    cd H:\Data_Astros_Field
    catch
    cd /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/Data_Astros_Field_KarimLaaaassssttttt/Data_Astros_Field
%     cd /Users/karimbenchenane/Dropbox/Lisa/Data_Astros/Astros_OUT
end

Fup=1;


try

    %load AnalysisCrossCorrPartFreqMai2010NewFiler_005_01
       %load AnalysisCrossCorrPartFreqFinal
   % load AnalysisCrossCorrPartFreqMai2010NewFiler
%     load AnalysisCrossCorrPartFreq
load AnalysisCrossCorrPartFreqJuly2010AstroNewPaper  % filtre high 0.02 0.5
    
catch

        binCohrT=[];
        binS1T=[];
        binS2T=[];

        binClT=[];
        binCmT=[];                    
        binChT=[];                    
        binCuhT=[];


        cellnames={};

        j=1;


        listdir=dir;

        for i=1:length(listdir)

                try
                    cd H:\Data_Astros_Field
                catch
                    cd /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/Data_Astros_Field_KarimLaaaassssttttt/Data_Astros_Field
%                     cd /Users/karimbenchenane/Dropbox/Lisa/Data_Astros/Astros_OUT
                end


                if listdir(i).isdir==1&listdir(i).name(1)~='.'


                            eval (['cd ',listdir(i).name])


                            nom=listdir(i).name;
                            le=length(listdir(i).name);


                                %% -------------------------------------------------------------------------                                        
                                % -------------------------------------------------------------------------                                        
                                % A faire dans la boucle
                                % -------------------------------------------------------------------------
                                % -------------------------------------------------------------------------                                        

                                try

                                                    CrossCorrParticularFrequency;
                                                    RlisaT(j)=rLisa;
                                                    PlisaT(j)=pLisa;

                                %                     load DataCrossCorrPartFreq lags Cl Cm Ch Cuh FLow FMedium FHigh FUltraHigh YLow YMedium YHigh YUltraHigh zfl zfm zfh zfuh zyl zym zyh zyuh r p R freqFl freqFm freqFh freqFuh f S1 S2 C CPMn CPmn                    


                                                    [binCohr,lCohr]=PoolData(C,f,[0:0.005:Fup]);
                                                    binCohrT=[binCohrT;binCohr];

                                                    [binS1,lS1]=PoolData(S1(f<Fup),f(f<Fup),[0:0.01:Fup]);
                                                    binS1T=[binS1T;binS1];

                                                    [binS2,lS2]=PoolData(S2(f<Fup),f(f<Fup),[0:0.01:Fup]);
                                                    binS2T=[binS2T;binS2];

                                                    lCrossBinL=[-100:2:100];
                                                    lCrossBinM=[-50:1:50];
                                                    lCrossBinH=[-20:0.5:20];
                                                    lCrossBinUH=[-10:0.1:10];

                                                    [binCl,lCrossl]=PoolData(Cl,lags,lCrossBinL);
                                                    [binCm,lCrossm]=PoolData(Cm,lags,lCrossBinM);
                                                    [binCh,lCrossh]=PoolData(Ch,lags,lCrossBinH);
                                                    [binCuh,lCrossuh]=PoolData(Cuh,lags,lCrossBinUH);


                                                    binClT=[binClT;binCl];
                                                    binCmT=[binCmT;binCm];                    
                                                    binChT=[binChT;binCh];                    
                                                    binCuhT=[binCuhT;binCuh];

                                                    RlagZero{j}=r;
                                                    PlagZero{j}=p;


                                                    DelVmLFP(j)=DelayVmLFP
                                                    close
                                                    cellnames{j}=nom;

                                                    j=j+1;            

                                 end



        % -------------------------------------------------------------------------                                        
        % -------------------------------------------------------------------------
        % -------------------------------------------------------------------------



                end
        end



%save AnalysisCrossCorrPartFreqMai2010NewFiler_005_01
     %   save AnalysisCrossCorrPartFreqMai2010NewFiler
%          save AnalysisCrossCorrPartFreqMai2010
save AnalysisCrossCorrPartFreqJuly2010AstroNewPaper

end



%% -----------------------------------------------------------------------
% ------------------------------------------------------------------------
% Modification Karim
% ------------------------------------------------------------------------
% ------------------------------------------------------------------------




% ------------------------------------------------------------------------
% removal of outliers
% ------------------------------------------------------------------------


if 0
    
idddx=[5
     9
    19
     1
     4
     6
    10
    11
     2
    14
    15
    16
    18
     8
    13
     3
     7
    12
    17
    20]';
    
%binClT=binClT(idddx([[1:16],[18:end]]),:);
%binCmT=binCmT(idddx([[1:16],[18:end]]),:);
%binChT=binChT(idddx([[1:16],[18:end]]),:);
%binCuhT=binCuhT(idddx([[1:16],[18:end]]),:);


binClT=binClT(idddx([[1:13],[15,16],[18:end]]),:);
binCmT=binCmT(idddx([[1:13],[15,16],[18:end]]),:);
binChT=binChT(idddx([[1:13],[15,16],[18:end]]),:);
binCuhT=binCuhT(idddx([[1:13],[15,16],[18:end]]),:);


end



% ------------------------------------------------------------------------
% ------------------------------------------------------------------------



mfreqFl=0.015;
mfreqFm=0.035;
mfreqFh=0.12;
mfreqFuh=0.5;

[MeanBinCrossl,IndexGloball]=AnalysisBinCross(binClT,lCrossl);
[MeanBinCrossm,IndexGlobalm]=AnalysisBinCross(binCmT,lCrossm);
try
[MeanBinCrossh,IndexGlobalh,Ppr0h,Tpr0h]=AnalysisBinCross(binChT,lCrossh);
catch
    keyboard
end
[MeanBinCrossuh,IndexGlobaluh,Ppr0uh,Tpr0uh]=AnalysisBinCross(binCuhT,lCrossuh);


[BE,id]=min(MeanBinCrossl);
delaiL=lCrossl(id);

Mb=MeanBinCrossl(lCrossl>-50);
lb=lCrossl(lCrossl>-50);
[BE,id]=min(Mb);
delaiL=lb(id);

[BE,id]=min(MeanBinCrossm);
delaiM=lCrossm(id);
[BE,id]=min(MeanBinCrossh);
delaiH=lCrossh(id);
[BE,id]=min(MeanBinCrossuh);
delaiUH=lCrossuh(id);


Delais=[delaiL, delaiM,delaiH, delaiUH];
mFreq=[mfreqFl, mfreqFm, mfreqFh, mfreqFuh];

figure('Color',[1 1 1]), 
subplot(2,1,1), plot(mFreq,Delais,'ko','MarkerFaceColor','k')
xlabel('Frequency (Hz)')
ylabel('Delay (s)')
subplot(2,1,2), plot(1./mFreq,Delais,'ko','MarkerFaceColor','k')
xlabel('Period (s)')
ylabel('Delay (s)')
title(['Delays ',num2str(Delais(1)),'s  ',num2str(Delais(2)),'s  ',num2str(Delais(3)*1000),'ms  ',num2str(Delais(4)*1000),'ms'])

Rt=zeros(8,8);
for i=1:15
Rt=Rt+RlagZero{i};
end


font=8;

legend{1}='LFP low';
legend{2}='Vm low';
legend{3}='LFP medium';
legend{4}='Vm medium';
legend{5}='LFP high';
legend{6}='Vm high';
legend{7}='LFP ultra-high';
legend{8}='Vm ultra-high';



figure('Color',[1 1 1]),
for i=1:15
Mat=(RlagZero{i}-diag(diag(RlagZero{i})));    

for j=1:length(Mat)
    Mat(j,j)=max(max(Mat));
end
subplot(3,5,i),imagesc(Mat)  
ca=caxis;
caxis([-max(ca) max(ca)])
title([cellnames{i},',  ',num2str(floor(DelVmLFP(i))),'ms, ',num2str(floor(100*max(ca))/100)])
end



Mat=(Rt-diag(diag(Rt)))/15;
for i=1:length(Mat)
    Mat(i,i)=max(max(Mat));
end

figure('Color',[1 1 1]), imagesc(Mat) 
ca=caxis;
caxis([-max(ca) max(ca)])
colorbar
set(gca,'ytick',[1:length(legend)])
set(gca,'yticklabel',legend)
set(gca,'xtick',[1:length(legend)])
set(gca,'xticklabel',legend)
set(gca,'FontSize',font)


% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
% ------------------------------------------------------------------------

%En enlevant les points bizarres


[Me,Id,P,T]=AnalysisBinCross(binChT(IndexGlobalh([[1:13],[15,16],[18:end]]),:),lCrossh);




