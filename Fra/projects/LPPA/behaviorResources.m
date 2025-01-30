function A = behaviorResources(A)



A = registerResource(A, 'PosXS', 'tsdArray', {1, 1}, ...
    'XS', ['X coordinate of the smoothed position'], 'mfile');
A = registerResource(A, 'PosYS', 'tsdArray', {1, 1}, ...
    'YS', ['Y coordinate of the smoothed position'], 'mfile');

A = registerResource(A, 'PosPhiD', 'tsdArray', {1, 1}, ...
    'phiD', ['linearized coordinate on the departure arm'], 'mfile');
A = registerResource(A, 'PosPhiL', 'tsdArray', {1, 1}, ...
    'phiL', ['linearized coordinate on the left target arm'], 'mfile');
A = registerResource(A, 'PosPhiR', 'tsdArray', {1, 1}, ...
    'phiR', ['linearized coordinate on the right target arm'], 'mfile');
A = registerResource(A, 'PosVs', 'tsdArray', {1,1}, ...
    'Vs', ['smoothed running speed'], 'mfile');
A = registerResource(A, 'PosTimeD', 'cell', {1,1}, ...
    'timeD', ['time intervals spent on the departure arm'], 'mfile');
A = registerResource(A, 'PosTimeL', 'cell', {1,1}, ...
    'timeL', ['time intervals spent on the left arm'], 'mfile');
A = registerResource(A, 'PosTimeR', 'cell', {1,1}, ...
    'timeR', ['time intervals spent on the right arm'], 'mfile');
A = registerResource(A, 'PosAtRewardD', 'tsdArray', {1,1}, ...
    'atRewardD', ['time of arrival at reward, dep. arm'], 'mfile');
A = registerResource(A, 'PosAtRewardL', 'tsdArray', {1,1}, ...
    'atRewardL', ['time of arrival at reward, left arm'], 'mfile');
A = registerResource(A, 'PosAtRewardR', 'tsdArray', {1,1}, ...
    'atRewardR', ['time of arrival at reward, right arm'], 'mfile');
A = registerResource(A, 'PosOffRewardD', 'tsdArray', {1,1}, ...
    'offRewardD', ['time of departure from reward, dep. arm'], 'mfile');
A = registerResource(A, 'PosOffRewardL', 'tsdArray', {1,1}, ...
    'offRewardL', ['time of departure from reward, left arm'], 'mfile');
A = registerResource(A, 'PosOffRewardR', 'tsdArray', {1,1}, ...
    'offRewardR', ['time of departure from reward, right arm'], 'mfile');
A = registerResource(A, 'StartTrial', 'tsdArray', {1,1}, ...
    'startTrial', ['times of trial beginning'], 'mfile');
A = registerResource(A, 'CorrectError', 'tsdArray', {1,1}, ...
    'correctError', ['whether it was a correct or error trial'], 'mfile');
A = registerResource(A, 'TrialOutcome', 'tsdArray', {1,1}, ...
    'trialOutcome', ['outcome of the trial, zero for right, one for left'], 'mfile');
A = registerResource(A, 'LightRecord', 'tsdArray', {1,1},  ...
    'lightRecord', ['time and location of the light, zero = right, one = left'], 'mfile');



  load([current_dir(A) filesep 'PosFile.mat'])
  
  phiD = phi_d;
  phiL = phi_l;
  phiR = phi_r;
  timeD = time_d;
  timeL = time_l;
  timeR = time_r;
  atRewardD = at_reward_d;
  atRewardL = at_reward_l;
  atRewardR = at_reward_r;
  offRewardD = off_reward_d;
  offRewardL = off_reward_l;
  offRewardR = off_reward_r;
  
  if ~exist('startTrial', 'var')
      thresh = 13; %cm/sec, threshold to start trial) 
      tt = threshold(Vs,  thresh);
      startTrial = Restrict(tt, End(time_d), 'align', 'prev');
  end
  
 
  A= saveAllResources(A);
  