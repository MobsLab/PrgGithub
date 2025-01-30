%ParcoursSleepCycleMac



Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

a=1;
for man=1:length(Dir.path)
%     try
   try
       cd(Dir.path{man})
   catch
       cd(['/Volumes',Dir.path{man}(7:end)])
   end
   
   disp(Dir.path{man})
%    [Mat1{a},Mat2(a,:),CaracSlCy(a,:),freq(a,:),Spect(a,:),B(a,:),C(a,:),ReNormTnew{a},tpsb(a,:),ReNormT{a},tps(a,:),ReNormT2{a},tps2{a},ff(a,:),M1{a},S1{a},t1(a,:),M2{a},S2{a},t2(a,:),M3{a},S3{a},t3(a,:),R1{a},R2{a},R3{a},R4{a},R5{a}]=AnalysisSleepCycle;
   [Mat1{a},Mat2,CaracSlCy{a}]=AnalysisSleepCycle;
   close all
   nameMouse{a}=Dir.name{man};
   pathMouse{a}=Dir.path{man};
   a=a+1;
%     end
end


try
    cd /media/mobssenior/Data2/Dropbox/Kteam
catch
    cd /Users/Bench/Dropbox/Kteam
end
% save DataParcoursSleepCycle2

