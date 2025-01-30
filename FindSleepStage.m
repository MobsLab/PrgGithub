function [S12,S34,S5,REMEpoch, WakeEpoch,SWAEpoch,SleepStages,spindles,MovEpoch]=FindSleepStage(LFP,sdTH,lim)


plo=0;

try
    lim;
catch
    lim=1;
end

try 
    sdTH;
catch
    sdTH=2;
end


paramselectionS3=5;  %default value 2


load StateEpoch SWSEpoch NoiseEpoch GndNoiseEpoch REMEpoch MovEpoch WeirdNoiseEpoch 

% 
% limLFP=8000;
% AmplitudeNoiseEpoch1=thresholdIntervals(LFP,limLFP,'Direction','Above');
% AmplitudeNoiseEpoch2=thresholdIntervals(LFP,-limLFP,'Direction','Below');
% AmplitudeNoiseEpoch=or(AmplitudeNoiseEpoch1,AmplitudeNoiseEpoch2);
% AmplitudeNoiseEpoch=intervalSet(Start(AmplitudeNoiseEpoch)-1*1E4,End(AmplitudeNoiseEpoch)+1*1E4);
% AmplitudeNoiseEpoch=mergeCloseIntervals(AmplitudeNoiseEpoch,0.5);


Epoch=SWSEpoch-GndNoiseEpoch;
Epoch=Epoch-NoiseEpoch;
try
Epoch=Epoch-AmplitudeNoiseEpoch;
end
try
Epoch=Epoch-WeirdNoiseEpoch;
end

REMEpoch=REMEpoch-GndNoiseEpoch;
REMEpoch=REMEpoch-NoiseEpoch;
try
REMEpoch=REMEpoch-AmplitudeNoiseEpoch;
end
try
REMEpoch=REMEpoch-WeirdNoiseEpoch;
end

% 
[t1,t2,t3,t,brst]=FindExtremPeaks(LFP,sdTH,dropShortIntervals(Epoch,2E4));
tused=t1;
[h,SpEpoch,brst]=ObsExtremPeaks(tused,lim);


[spindles,SWA]=FindSpindlesKarimNew(LFP,[2 20],Epoch,'off');

SWAEpoch=intervalSet(SWA(:,1)*1E4,SWA(:,2)*1E4);
%SpiEpoch=intervalSet(SWATot(:,1)*1E4-1.5E4,SWATot(:,3)*1E4+1.5E4);
%SpiEpoch=mergeCloseintervals(SpiEpoch,5E4);

SpiEpoch=or(SWAEpoch,SpEpoch);

S12=Epoch-SpiEpoch;
S34=SpiEpoch-REMEpoch;       
S5=and(REMEpoch,SpiEpoch);            
REMEpoch=REMEpoch-SpiEpoch;

SleepStages=5*ones(1,length(Range(LFP)));

rg=Range(LFP);

WholeEpoch=intervalSet(rg(1),rg(end));
SleepEpoch=or(SWSEpoch,REMEpoch);

rgS12=Range(Restrict(LFP,S12));
idS12=(find(ismember(rg,rgS12)==1));

rgS34=Range(Restrict(LFP,S34));
idS34=(find(ismember(rg,rgS34)==1));

rgS5=Range(Restrict(LFP,S5));
idS5=(find(ismember(rg,rgS5)==1));

rgREM=Range(Restrict(LFP,REMEpoch));
idREM=(find(ismember(rg,rgREM)==1));

WakeEpoch=WholeEpoch-SleepEpoch;
rgwake=Range(Restrict(LFP,WholeEpoch-SleepEpoch));
idwake=(find(ismember(rg,rgwake)==1));

try
    SleepStages(idwake)=0;
end
try
    SleepStages(idREM)=1;
end
try
    SleepStages(idS12)=3;
end
try
    SleepStages(idS34)=4;
end
try
   SleepStages(idS5)=2;
end

SleepStages(SleepStages>4)=-1;

SleepStages=tsd(rg,SleepStages');





if plo
    
figure('color',[1 1 1])
hold on, plot(Range(SleepStages,'s'),Data(SleepStages),'k')
hold on, plot(Range(SleepStages,'s'),Data(SleepStages),'k.')
hold on, plot(Range(Restrict(SleepStages,REMEpoch),'s'),Data(Restrict(SleepStages,REMEpoch)),'ro','markerfacecolor','r')
hold on, plot(Range(Restrict(SleepStages,S12),'s'),Data(Restrict(SleepStages,S12)),'bo','markerfacecolor','b')
hold on, plot(Range(Restrict(SleepStages,S34),'s'),Data(Restrict(SleepStages,S34)),'go','markerfacecolor','g')
hold on, plot(Range(Restrict(SleepStages,S5),'s'),Data(Restrict(SleepStages,S5)),'mo','markerfacecolor','m')
end
















%tused=t1;


%[h,SpEpoch,brst]=ObsExtremPeaks(tused,lim);


                    %             
                    % SpRejected=[];
                    % SpCorrected=[];
                    % for i=1:length(Start(SpEpoch))
                    %     valOsc=Data(Restrict(tused,subset(SpEpoch,i)));
                    %     %length(find(valOsc<4))
                    %     %     if length(find(valOsc>4))>length(find(valOsc<4))
                    %     %     if length(find(valOsc<4))<2   
                    %     if length(find(valOsc>4))>paramselectionS3        % default value valOsc>6   //  default value paramselectionS3=2;
                    %         SpCorrected=[SpCorrected;[Start(subset(SpEpoch,i)) End(subset(SpEpoch,i))]]; 
                    %     else
                    %         SpRejected=[SpRejected;[Start(subset(SpEpoch,i)) End(subset(SpEpoch,i))]]; 
                    %     end
                    % end
                    % 
                    % 
                    % [BE,id]=sort(SpCorrected(:,1));
                    % SpCorrected=intervalSet(SpCorrected(id,1),SpCorrected(id,2));
                    % SpCorrected=mergeCloseIntervals(SpCorrected,0.00001);
                    % 
                    % 
                    % [BE,id]=sort(SpRejected(:,1));
                    % SpRejected=intervalSet(SpRejected(id,1),SpRejected(id,2));
                    % SpRejected=mergeCloseIntervals(SpRejected,0.00001);
                    % 
                    % % (length(Start(SpEpoch))-length(Start(SpCorrected)))/length(Start(SpEpoch))*100
                    % 
                    % 
                    % S12=SWSEpoch-SpEpoch;
                    % S3=SpCorrected;
                    % S4=SpRejected;
                    % 

                    
                    
                    
                    
%                     
%                     
% SleepStages=5*ones(1,length(Range(LFP)));
% 
% rg=Range(LFP);
% 
% WholeEpoch=intervalSet(rg(1),rg(end));
% SleepEpoch=or(SWSEpoch,REMEpoch);
% 
% rgS12=Range(Restrict(LFP,S12));
% idS12=(find(ismember(rg,rgS12)==1));
% 
% rgS3=Range(Restrict(LFP,S3));
% idS3=(find(ismember(rg,rgS3)==1));
% 
% rgS4=Range(Restrict(LFP,S4));
% idS4=(find(ismember(rg,rgS4)==1));
% 
% rgREM=Range(Restrict(LFP,REMEpoch));
% idREM=(find(ismember(rg,rgREM)==1));
% 
% WakeEpoch=WholeEpoch-SleepEpoch;
% rgwake=Range(Restrict(LFP,WholeEpoch-SleepEpoch));
% idwake=(find(ismember(rg,rgwake)==1));
% 
% try
% SleepStages(idwake)=0;
% end
% try
%     SleepStages(idREM)=1;
% end
% try
%     SleepStages(idS12)=2;
% end
% try
%     SleepStages(idS3)=3;
% end
% try
%     SleepStages(idS4)=4;
% end
% 
% SleepStages(SleepStages>4)=nan;
% 
% SleepStages=tsd(rg,SleepStages');
% 
% 
% 
% 



