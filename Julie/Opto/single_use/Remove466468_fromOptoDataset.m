%29.08.2017
cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection/DirPathwith_466_468
load DataRampOver1DayQuantif_no_selec_HPC_PiCx_sub

LFPpower_new=LFPpower;
LFPpower_Before_new=LFPpower_Before;


LFPpower_new(:,:,[6 7 10 11],:,:,:)=[];
LFPpower_Before_new(:,:,[6 7 10 11],:,:,:)=[];

LFPpower=LFPpower_new;
LFPpower_Before=LFPpower_Before_new;

size(LFPpower_Before)
size(LFPpower)
cd /media/DataMOBsRAIDN/ProjetAversion/RampOver1dayQuantif/Ramp_4_no_selection

save DataRampOver1DayQuantif_no_selec_HPC_PiCx_sub
