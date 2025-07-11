%% -----------------------------------------------------------------------
%AnalysisSWSOB
%-------------------------------------------------------------------------



filename=pwd;


%% -----------------------------------------------------------------------
%Effet DataFiles --------------------------------------------------------
%-------------------------------------------------------------------------
R=[];
HistoUpT=[];
HistoDownT=[];
Cont=[];
timeRecordingT=[];
a=1;
                    
listdir=dir;

for i=1:length(listdir)

        
        
        if listdir(i).isdir==1&listdir(i).name(1)~='.'

            
%                     try                       
        
                    eval(['cd(''',filename,''')'])

                    eval(['cd(''',listdir(i).name,''')'])
                    
                    try
                        load AnaSWSnew
                        load DataMCLFP cont tps
                        load Data nom
                        Cont=[Cont;cont];
                    R=[R;Res];
                    HistoUpT=[HistoUpT;HistoUp];
                    HistoDownT=[HistoDownT;HistoDown];
                    SpectT{a}=Spect;
                    freqT{a}=freq;
                    nomcellule{a}=nom;
                    timeRecording=tps(end)-tps(1);
                    timeRecordingT=[timeRecordingT;timeRecording];
                    a=a+1;
                    close all
                    
                    catch
                        try
                    load Data nom
                    
                    load UpDown
                    load Spikes
                    load DataMCLFP
                    [Res,numfig,HistoUp,binUp,HistoDown,binDown,Spect,freq]=PatchCellProperties(Y+X(1),tps,spikes,DebutUp,FinUp,1);
                    %PlotUpStates(data,X,tps,DebutUp,FinUp)
                    numf=gcf;
                    Cont=[Cont;cont];
                    R=[R;Res];
                    HistoUpT=[HistoUpT;HistoUp];
                    HistoDownT=[HistoDownT;HistoDown];
                    SpectT{a}=Spect;
                    freqT{a}=freq;
                    nomcellule{a}=nom;
                    timeRecording=tps(end)-tps(1);
                    timeRecordingT=[timeRecordingT;timeRecording];
                    a=a+1;
                    res=pwd;
%                     saveFigure(1,'figure1',res)
%                     saveFigure(2,'figure2',res)
%                     saveFigure(3,'figure3',res)
                     %saveFigure(numf,'figure5',res)
                     %clear data
                    save AnaSWSnew Res HistoUp binUp HistoDown binDown Spect freq nom timeRecording
                    close all
%                     end
                        
                        end
                        
                    end
                    
                    

        end
end

eval(['cd(''', filename,''')'])
%cd /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/NewPaper/DataNewPaper/DataMitralKO
eval(['save AnaSWSnew',genotype, ' R HistoUpT binUp HistoDownT binDown SpectT freqT Cont timeRecordingT nomcellule'])


%% -----------------------------------------------------------------------
%Bilan Effets ------------------------------------------------------------
%-------------------------------------------------------------------------


res=pwd;

figure('color',[1 1 1]), 
subplot(2,1,1), 
bar(binUp,sum(HistoUpT),1,'k'),xlim([0 35])
subplot(2,1,2), 
bar(binUp,sum(HistoDownT),1,'k'),xlim([0 35])
title(genotype)

nu1=gcf; 
eval(['saveFigure(nu1,''HistogramUpDownStates',genotype,''',''',res,''')'])
a=length(SpectT);

figure('color',[1 1 1]), hold on
for i=1:a
plot(freqT{i},SpectT{i},'color',[0 (a-i)/(a) i/(a)])
end
title(genotype)

nu2=gcf;
eval(['saveFigure(nu2,''Spectrum',genotype,''',''',res,''')'])
                     
                     
 %% -----------------------------------------------------------------------

 