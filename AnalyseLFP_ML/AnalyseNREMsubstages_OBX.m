%AnalyseNREMsubstages_OBX.m

% list of related scripts in NREMstages_scripts.m

%%
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
DirX=PathForExperimentFEAR('Sleep-OBX');
Dir=MergePathForExperiment(Dir1,Dir2);
Dir=MergePathForExperiment(DirX,Dir);

%%
% <<<<<<<<<<<<<<<<<<<<<<<<<<< INITIATE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
MATOSCI={};
MATEP={};
for man=1:length(Dir.path)
    cd(Dir.path{man})
    disp(Dir.path{man})
    
    % -----------------------------------------------------------------
    % get substages
    clear op NamesOp Dpfc Epoch noise wholeEpoch temp
    try
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        op; noise ;disp('... loading epochs from NREMepochsML.m')
    catch
        [op,NamesOp,Dpfc,Epoch,noise]=FindNREMepochsML;
        save NREMepochsML.mat op NamesOp Dpfc Epoch noise
        disp('saving in NREMepochsML.mat')
    end
    if ~isempty(op)
        [temp,nameEpochs]=DefineSubStages(op(1:end-1),op{end},1); % 1 to remove short sleep periods
        MATEP(man,1:length(temp))=temp;
        
        % -----------------------------------------------------------------
        % get rhythms
        clear rip dHPCrip
        [dHPCrip,EpochRip]=GetRipplesML;
        try rip=ts(dHPCrip(:,2)*1E4);catch, rip=ts([]);;end
        
        Spfc=[];
        [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_sup');
        try Spfc=[Spfc;SpiHigh(:,2)];end
        try Spfc=[Spfc;SpiLow(:,2)];end
        
        [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_deep');
        try Spfc=[Spfc;SpiHigh(:,2)];end
        try Spfc=[Spfc;SpiLow(:,2)];end
        Spfc=sort(Spfc);
        Spfc(find(diff(Spfc)<0.5)+1)=[];%meme spindles
        Spfc=ts(Spfc*1E4);
        
        MATOSCI(man,1:3)={Dpfc,rip,Spfc};
        
        % -----------------------------------------------------------------
        % load time of debRec
        NewtsdZT=GetZT_ML(Dir.path{man});
        MATZT(man,1:2)=[min(Data(NewtsdZT)),max(Data(NewtsdZT))]/1E4; % en second
    end
end

%%

%run steps from AnalyseNREMsubstagesML.m
% delta
figure(numF(1)),subplot(3,2,1), plot(MATDELT(find(strcmp(Dir.name,'Mouse249')),idchange),'ob');
figure(numF(2)),subplot(3,2,1), plot(MiDELT(find(strcmp(mice,'Mouse249')),idchange),'ob');
%Spindles
figure(numF(1)),subplot(3,2,3), plot(MATSPIND(find(strcmp(Dir.name,'Mouse249')),idchange),'ob'); 
figure(numF(2)),subplot(3,2,3), plot(MiSPIND(find(strcmp(mice,'Mouse249')),idchange),'ob'); 
% Ripples
figure(numF(1)),subplot(3,2,5), plot(MATRIP(find(strcmp(Dir.name,'Mouse249')),idchange),'ob'); 
figure(numF(2)),subplot(3,2,5), plot(MiRIP(find(strcmp(mice,'Mouse249')),idchange),'ob');
% duration tot
figure(numF(1)),subplot(3,2,2), plot(MATDUR(find(strcmp(Dir.name,'Mouse249')),idchange),'ob'); 
figure(numF(2)),subplot(3,2,2), plot(MiEP(find(strcmp(mice,'Mouse249')),idchange),'ob'); 
% duration out of sws
figure(numF(1)),subplot(3,2,4), plot(MATDURsws(find(strcmp(Dir.name,'Mouse249')),idchange),'ob'); 
figure(numF(2)),subplot(3,2,4), plot(MiEPsws(find(strcmp(mice,'Mouse249')),idchange),'ob'); 
% duration out of sleep
figure(numF(1)),subplot(3,2,6), plot(MATDURs(find(strcmp(Dir.name,'Mouse249')),idchange),'ob'); 
figure(numF(2)),subplot(3,2,6), plot(MiEPs(find(strcmp(mice,'Mouse249')),idchange),'ob'); 


%% dKO
Dir=PathForExperimentsML('BASAL');
Dir=RestrictPathForExperiment(Dir,'Group','dKO');
    
checked{1}='/media/DataMOBsRAID/ProjetAstro/Mouse054/20130306/BULB-Mouse-54-06032013';



