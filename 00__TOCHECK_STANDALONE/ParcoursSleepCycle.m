%ParcoursSleepCycle

clear

DoAnlysisSB=0;

% Dir1=PathForExperimentsDeltaSleepNew('BASAL');
% Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
% Dir2=PathForExperimentsML('BASAL');
% Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
% Dir=MergePathForExperiment(Dir1,Dir2);


Dir2=PathForExperimentsML('BASAL');
Dir=RestrictPathForExperiment(Dir2,'Group','dKO');






a=1;
for man=1:length(Dir.path)
        try
   cd(Dir.path{man})
   disp(Dir.path{man})
   [Mat1{a},Mat2{a},Mat3{a},Mat4{a},CaracSlCy{a},freq{a},Spect{a},B{a},C{a},ReNormTnew{a},tpsb{a},ReNormT{a},tps{a},ReNormT2{a},tps2{a},ff{a},M1{a},S1{a},t1{a},M2{a},S2{a},t2{a},M3{a},S3{a},t3{a},R1{a},R2{a},R3{a},R4{a},R5{a}]=AnalysisSleepCycle(DoAnlysisSB);
    close all
   nameMouse{a}=Dir.name{man};
   pathMouse{a}=Dir.path{man};
   a=a+1;
   end
end

close all
% 
cd /media/mobssenior/Data2/Dropbox/Kteam

% save DataParcoursSleepCycleMLBulb15secWakeControlledKO
save DataParcoursSleepCycleMLPfc15secWakeControlledKO

%save DataParcoursSleepCycleMLHpcTheta15sec
% save DataParcoursSleepCycleMLHpc15sec
%save DataParcoursSleepCycleMLHpc15secWakeControlled
%save DataParcoursSleepCycleMLPfc15sec
%save DataParcoursSleepCycleMLPfc15secWakeControlled
%save DataParcoursSleepCycleMLPfcSpindles15sec
% save DataParcoursSleepCycleMLBulb15sec
%save DataParcoursSleepCycleMLBulb15secWakeControlled
% 
% 
% 
% clear
% 
% 
% Dir1=PathForExperimentsDeltaSleepNew('BASAL');
% Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
% Dir2=PathForExperimentsML('BASAL');
% Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
% Dir=MergePathForExperiment(Dir1,Dir2);
% 
% a=1;
% for man=1:length(Dir.path)
% 
%    cd(Dir.path{man})
%    disp(Dir.path{man})
%    [Mat1{a},Mat2(a,:),CaracSlCy(a,:),freq(a,:),Spect(a,:),B(a,:),C(a,:),ReNormTnew{a},tpsb(a,:),ReNormT{a},tps(a,:),ReNormT2{a},tps2{a},ff(a,:),M1{a},S1{a},t1(a,:),M2{a},S2{a},t2(a,:),M3{a},S3{a},t3(a,:),R1{a},R2{a},R3{a},R4{a},R5{a}]=AnalysisSleepCycle;
%    close all
%    nameMouse{a}=Dir.name{man};
%    pathMouse{a}=Dir.path{man};
%    a=a+1;
% 
% end
% 
% cd /media/mobssenior/Data2/Dropbox/Kteam
