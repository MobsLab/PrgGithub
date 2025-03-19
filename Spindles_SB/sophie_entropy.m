 % Entropy method

%  look at evolution of permutation entropy

t=0.0001*10000; %time step,seconds*10000
win=0.1; %window, seconds
win_dt=0.05; %move along window
disp('entropy method')
m=5;
permlist = perms(1:m);
voie=cell(1,7);
voie{1}='25';
voie{2}='26';
voie{3}='30';
voie{4}='22';
voie{5}='31';
voie{6}='29';
voie{7}='24';

voie{8}='17';
voie{9}='19';
voie{10}='26';
voie{11}='28';
voie{12}='24';
voie{13}='23';

for v=1:3
    clear time
    clear pe
    v
    if v<8
load (strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/LFPData/LFP',voie{v},'.mat'))
    else
load (strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse047/20130111/BULB-Mouse-47-11012013/LFPData/LFP',voie{v},'.mat'))
    end     
    
LFPtest=ResampleTSD(LFP,250);
duration=Range(LFPtest,'s');
duration=duration(end);

for i=1:floor((duration-win)/win_dt)
    
    Epoch=intervalSet((i-1)*win_dt*10000, win*10000+(i-1)*win_dt*10000);
    y=Data(Restrict(LFPtest,Epoch));
    ly = length(y);
    c(1:length(permlist))=0;
    
 for j=1:ly-t*(m-1)
    [a,iv]=sort(y(j:t:j+t*(m-1)));
     for jj=1:length(permlist)
         if (abs(permlist(jj,:)'-iv))==0
             c(jj) = c(jj) + 1 ;
         end
     end
 end

 
c=c(find(c~=0));
p = c/sum(c);
pe(i) = (-sum(p .* log(p)))/length(permlist);
time(i)=((i-1)*win_dt+win+(i-1)*win_dt)/2;
end    
if v<8
save (strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/entropy5_',voie{v},'.mat'),'time','pe')
else
    save (strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse047/20130111/BULB-Mouse-47-11012013/entropy5_',voie{v},'.mat'),'time','pe')
    end     
    end

std_pe=std(pe{(m-1)/2});
mean_pe=mean(pe{(m-1)/2});
deriv_pe=diff(pe{(m-1)/2});
deriv1_pe = [deriv_pe 0];
deriv2_pe = [0 deriv_pe];
PeaksIdx_pe = find(deriv1_pe > 0 & deriv2_pe < 0);
Peaks_val_pe=pe{(m-1)/2}(PeaksIdx_pe);
PeaksIdx_high_pe=PeaksIdx_pe(Peaks_val_pe<(mean_pe-2*std_pe));
PeaksIdx_low_pe=PeaksIdx_pe(Peaks_val_pe<(mean_pe-std_pe));
brst_high_pe = burstinfo(time(PeaksIdx_high_pe), 0.15, inf, 3);
brst_low_pe = burstinfo(time(PeaksIdx_low_pe), 0.15, inf, 3);


%    figure(m-2)     
%      plot(time/10000,pe/length(permlist))
%    hold on
%     plot(time/10000,smooth(pe/length(permlist),5),'k')
%     title(num2str(m))
%     
end
clear event1
event1.time=[ brst_high_pe.t_start  brst_high_pe.t_end ]';
for i=1:length(brst_high_pe.t_start)
    
   event1.description{i}='spinstart';
   event1.description{i+length(brst_high_pe.t_start)}='spinstop';

end

SaveEvents(strcat('Sophie_sp_high_ent.evt.h', voie{v}),event1)

clear event1
event1.time=[ brst_low_pe.t_start  brst_low_pe.t_end ]';
event1.time=event1.time(:);
for i=1:length(brst_low_pe.t_start)
    
   event1.description{i}='spinstart';
      event1.description{i+length(brst_low_pe.t_start)}='spinstop';

end
SaveEvents(strcat('Sophie_sp_low_ent.evt.l', voie{v}),event1)