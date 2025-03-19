% CreateIntervalSession
% 16.11.2016 KJ
%
% Create file IntervalSession.mat containing:  
%   Session1 Session2 Session3 Session4 Session5 
%   night_duration TimeDebRec TimeEndRec
%
%



% Dir1=PathForExperimentsDeltaWavesTone('RdmTone');
% Dir2=PathForExperimentsDeltaWavesTone('DeltaToneAll');
% Dir = MergePathForExperiment(Dir1,Dir2);
% clear Dir1 Dir2
% 
% for p=1:length(Dir.path)
%     try
%         disp(' ')
%         disp('****************************************************************')
%         eval(['cd(Dir.path{',num2str(p),'}'')'])
%         disp(pwd)
%         
%         clearvars -except Dir p
%         
%         load behavResources
%         Session1 = intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
%         Session2 = intervalSet(tpsdeb{2}*1E4,tpsfin{2}*1E4);
%         Session3 = intervalSet(tpsdeb{3}*1E4,tpsfin{3}*1E4);
%         Session4 = intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
%         Session5 = intervalSet(tpsdeb{5}*1E4,tpsfin{5}*1E4);
%         night_duration = tpsfin{5}*1E4 - tpsdeb{1}*1E4;
% 
%         try 
%             save IntervalSession Session1 Session2 Session3 Session4 Session5 night_duration TimeDebRec TimeEndRec
%         catch
%             save IntervalSession Session1 Session2 Session3 Session4 Session5 night_duration
%         end
%     catch
%         disp('error for this record')
%     end
% end
% 
% 
% Dir=PathForExperimentsDeltaKJHD('Basal');
% 
% for p=1:length(Dir.path)
%     try
%         disp(' ')
%         disp('****************************************************************')
%         eval(['cd(Dir.path{',num2str(p),'}'')'])
%         disp(pwd)
%         
%         clearvars -except Dir p
%         
%         load behavResources
%         if length(tpsdeb)==5
%             Session1 = intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
%             Session2 = intervalSet(tpsdeb{2}*1E4,tpsfin{2}*1E4);
%             Session3 = intervalSet(tpsdeb{3}*1E4,tpsfin{3}*1E4);
%             Session4 = intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
%             Session5 = intervalSet(tpsdeb{5}*1E4,tpsfin{5}*1E4);
%             night_duration = tpsfin{5}*1E4 - tpsdeb{1}*1E4;
%         else
%             night_duration = tpsfin{end}*1E4 - tpsdeb{1}*1E4;
%             Session1 = intervalSet(0,night_duration*(1/5));
%             Session2 = intervalSet(night_duration*(1/5),night_duration*(2/5));
%             Session3 = intervalSet(night_duration*(2/5),night_duration*(3/5));
%             Session4 = intervalSet(night_duration*(3/5),night_duration*(4/5));
%             Session5 = intervalSet(night_duration*(4/5),night_duration);
%         end
%         try 
%             save IntervalSession Session1 Session2 Session3 Session4 Session5 night_duration TimeDebRec TimeEndRec
%         catch
%             save IntervalSession Session1 Session2 Session3 Session4 Session5 night_duration
%         end
%     catch
%         disp('error for this record')
%     end
% end



Dir=PathForExperimentsBasalSleepSpike;
Dir=RestrictPathForExperiment(Dir, 'nMice', [403,451]);

for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)

    clearvars -except Dir p

    load behavResources
    night_duration = max(Range(MovAcctsd)) - min(Range(MovAcctsd));
    Session1 = intervalSet(0,night_duration*(1/5));
    Session2 = intervalSet(night_duration*(1/5),night_duration*(2/5));
    Session3 = intervalSet(night_duration*(2/5),night_duration*(3/5));
    Session4 = intervalSet(night_duration*(3/5),night_duration*(4/5));
    Session5 = intervalSet(night_duration*(4/5),night_duration);

    save IntervalSession Session1 Session2 Session3 Session4 Session5 night_duration
end


