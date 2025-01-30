% ConcatenateRampQuantifFiles
% 16.10.2017

% finalement trop compliqu" / casse pied de concatener les files -> j'ai
% refait tourner le code sur la bonne mouse liste

cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/7mice_458-467
tempPaper=load('DataRampOver1DayQuantif_no_selection');

% cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/2mice_march17
% tempMarch=load('DataRampOver1DayQuantif_no_selection');

cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/3mice_july17
tempJuly=load('DataRampOver1DayQuantif_no_selection');

% 
% LFPpower_Before=cat(3,tempPaper.LFPpower_Before,tempMarch.LFPpower_Before,tempJuly.LFPpower_Before)
% LFPpower=cat(3,tempPaper.LFPpower,tempMarch.LFPpower,tempJuly.LFPpower)


if size(tempJuly.LFPpower_Before)~=tempJuly.LFPpower_Before
    keyboard
    Matrix50nan=nan(1,length(tempPaper.structlistname), length(Dir.path),50,67,15);
    tempPaper.LFPpower_Before=cat(3,tempPaper.LFPpower_Before,Matrix50nan)
end



LFPpower_Before=cat(3,tempPaper.LFPpower_Before,tempJuly.LFPpower_Before)
LFPpower=cat(3,tempPaper.LFPpower,tempJuly.LFPpower)


Dir=cat(3,tempPaper.Dir,tempJuly.Dir);
StimInfoAllMan=cat(3,tempPaper.StimInfoAllMan,tempJuly.StimInfoAllMan);

cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/4_3_mice_paper_july17

f1=tempPaper.f1;
f=tempPaper.f;
structlistname=tempPaper.structlistname;
fq_list=tempPaper.fq_list;
nb_fq=tempPaper.nb_fq;

save DataRampOver1DayQuantif_no_selection LFPpower_Before LFPpower f1 f structlistname fq_list Dir LaserInt StimInfoAllMan f nb_fq 


