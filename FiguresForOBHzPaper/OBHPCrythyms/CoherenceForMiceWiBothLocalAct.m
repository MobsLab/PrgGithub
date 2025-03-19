% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
% Get directories
CtrlEphys=[254,253,395];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Frequency bands to scan through
FreqRange=[1:12;[3:14]];
% Name of possible different structures
FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc','PFCx'};
TimeLag=1;
% Parameters for triggered spectro
MouseNum=1;
TotNeurons=0;
[params,movingwin,suffix]=SpectrumParametersML('low');

AllCombi=combnk([1:length(FieldNames)],2);

for mm=1:3
    mm
    cd(Dir.path{mm})
    load('behavResources.mat')
    [ChanAll,LFPAll]=GetChannelsLFPPhaseCouplingOBHzProject(1);
    
    % coherence
    disp('calculating coherence')
    for cc=1:length(AllCombi)
        if not(strcmp(FieldNames{AllCombi(cc,1)}(1:2),FieldNames{AllCombi(cc,2)}(1:2)))
            NameTemp1=['CohgramcDataL/Cohgram_',FieldNames{AllCombi(cc,1)},'_',FieldNames{AllCombi(cc,2)},'.mat'];
            NameTemp2=['CohgramcDataL/Cohgram_',FieldNames{AllCombi(cc,2)},'_',FieldNames{AllCombi(cc,1)},'.mat'];
            if exist(NameTemp1)>0 | exist(NameTemp2)>0
            else
                 NameTemp1
                    [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPAll.(FieldNames{AllCombi(cc,1)})),Data(LFPAll.(FieldNames{AllCombi(cc,2)})),movingwin,params);
                    chan1=ChanAll.(FieldNames{AllCombi(cc,1)});
                    chan2=ChanAll.(FieldNames{AllCombi(cc,2)});
                    save(NameTemp1,'C','phi','S12','confC','t','f','chan1','chan2')
                    clear C phi S12 S1 S2 t f confC phist chan1 chan2
                
           end
        end
    end
    clear ChanAll LFPAll
    
end