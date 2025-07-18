function YMProcessPosFile()

jump_thresh = 20;
smooth_length = 800*10;


close all

[p, n, e] = fileparts(pwd);
sessionName = n;


% load the tracker file 
posfileName = [pwd  filesep n '_pos.mat'];
load(posfileName)


% Clean up tracker data
[X1, Y1] = RemoveBadPosPoints(X, Y, jump_thresh, jump_thresh);

XS = smooth(X1, smooth_length);
YS = smooth(Y1, smooth_length);

%Compute speed
warning off
[VX, VY] = Vel2d(XS, YS);
warning on

V2 = tsd(Range(VX, 'ts'), sqrt(Data(VX).*Data(VX) + Data(VY) .* ...
			       Data(VY)));
               
                   
                   
                   
% ask user for epoch timestamps
disp('Enter beginning/end of maze epoch')

plot(Range(XS), Data(XS))

gg = ginput(2);

maze_epoch = intervalSet(gg(1,1), gg(2,1));
% ask user to define maze geometry
plot(Data(XS), Data(YS))

keyboard
disp('Enter extreme points for the three arms, (departure, left, right)')
gg = ginput(3)
xd = gg(1,1);
yd = gg(1,2);
xl = gg(2,1);
yl = gg(2,2);
xr = gg(3,1);
yr= gg(3,2);

disp('Enter platform vertices (departure, left, right)')
gg = ginput(3)
xpd = gg(1,1);
ypd = gg(1,2);
xpl = gg(2,1);
ypl = gg(2,2);
xpr = gg(3,1);
ypr= gg(3,2);


% coordinates for maze epoch
Xm = Restrict(X, maze_epoch);
Ym = Restrict(Y, maze_epoch);

%time frames while on the departure arm 
md = -(xd-xpd)/(yd-ypd);
qd = ypd - md * xpd;
bd = Data(Ym) > md * Data(Xm) + qd;

%time frames while on the right target arm
mr = -(xr-xpr)/(yr-ypr);
qr = ypr - mr* xpr;
br = Data(Ym) < mr*Data(Xm) + qr;

%time frames while on the left target arm
ml = -(xl-xpl)/(yl-ypl);
ql = ypl - ml*xpl;
bl = Data(Ym) < ml*Data(Xm)+ql;

%time frames while on the platform

b_plat = ~ (bd | bl | br);


%times spent in departure, right, left arm and in platform, clean up for
%really short "flickering" time intervals
time_d = dropShortIntervals(thresholdIntervals(tsd(Range(Xm), bd), 0.5), 30000);

if length(Start(time_d)) > 0
	time_d = mergeCloseIntervals(time_d, 3000 *10);
end;

time_r = dropShortIntervals(thresholdIntervals(tsd(Range(Xm), br), 0.5), 10000);

if length(Start(time_r)) > 0
	time_r= mergeCloseIntervals(time_r, 3000 *10);
end

time_l = dropShortIntervals(thresholdIntervals(tsd(Range(Xm), bl), 0.5), 10000);

if length(Start(time_l)) > 0
    	time_l = mergeCloseIntervals(time_l, 3000 *10);
end;

time_plat = dropShortIntervals(thresholdIntervals(tsd(Range(Xm), b_plat), 0.5), 10000);




% make plot  highlighting time wpent on different arms
figure(1);
clf
axis([0 300 0 250]);
hold on 
bx = Restrict(Xm, time_d);
by = Restrict(Ym, time_d);
plot(Data(bx), Data(by))

bx = Restrict(Xm, time_r);
by = Restrict(Ym, time_r);
plot(Data(bx), Data(by), 'r')

bx = Restrict(Xm, time_l);
by = Restrict(Ym, time_l);
plot(Data(bx), Data(by), 'g')

bx = Restrict(Xm, time_plat);
by = Restrict(Ym, time_plat);
plot(Data(bx), Data(by), 'm')

% compute linearized coordinates 

xm = Data(Xm);
ym = Data(Ym);
pos = [xm, ym];
v = [(xd-xpd);(yd-ypd)];
p = (pos-repmat([xpd,  ypd], length(xm),1)) * v;
phi_d = Restrict(tsd(Range(Xm), p /  norm(v)^2), time_d);

v = [(xr-xpr);(yr-ypr)];
p = (pos-repmat([xpr,  ypr], length(xm),1)) * v;
phi_r = Restrict(tsd(Range(Xm), p/  norm(v)^2), time_r);

v = [(xl-xpl);(yl-ypl)];
p = (pos-repmat([xpl,  ypl], length(xm),1)) * v;
phi_l= Restrict(tsd(Range(Xm), p/  norm(v)^2), time_l);


% Times of arrival  at reward sites

at_reward_d = threshold(phi_d, 0.90);
at_reward_d = Restrict(at_reward_d, Start(time_d), 'align', 'next');

at_reward_l = threshold(phi_l, 0.90);
keyboard
at_reward_l = Restrict(at_reward_l, Start(time_l), 'align', 'next');

at_reward_r = threshold(phi_r, 0.90);
at_reward_r = Restrict(at_reward_r, Start(time_r), 'align', 'next');

% Times of departure from reward sites

off_reward_d = threshold(phi_d, 0.90, 'Crossing', 'Falling');
off_reward_d = Restrict(off_reward_d, End(time_d), 'align', 'prev');

off_reward_r = threshold(phi_r, 0.90, 'Crossing', 'Falling');
off_reward_r = Restrict(off_reward_r, End(time_r), 'align', 'prev');

off_reward_l = threshold(phi_l, 0.90, 'Crossing', 'Falling');
off_reward_l = Restrict(off_reward_l, End(time_l), 'align', 'prev');


% add to plot times of identified reward arrival/departure
rx = Restrict(Xm, at_reward_d);
ry = Restrict(Ym, at_reward_d);
plot(Data(rx), Data(ry), 'yo');

rx = Restrict(Xm, at_reward_r);
ry = Restrict(Ym, at_reward_r);
plot(Data(rx), Data(ry), 'yd');

rx = Restrict(Xm, at_reward_l);
ry = Restrict(Ym, at_reward_l);
plot(Data(rx), Data(ry), 'y+');


vfact = 90/(110 * 0.0001); % (arm length) / (number of pixels in arm * time unit), convert to cm/sec

% absolute speed in cm/s
V2 = tsd(Range(VX, 'ts'), vfact * sqrt(Data(VX).*Data(VX) + Data(VY) .* ...
			       Data(VY)));
               
Vs = smooth(V2, 20000);

thresh = 13; %cm/sec, threshold to start trial) 
tt = threshold(Vs,  thresh);

tExtr = zeros(length(Start(time_d)), 1);
for td = 1:length(Start(time_d)) % for each time interval in departure arm
    yi = Restrict(Ym, subset(time_d, td)); % take y coord in that particular interval
    yd = Data(yi);
    yt = Range(yi);
    [dummy, ix] = max(yd);
    tExtr(td) = yt(ix);
end


startTrial = Restrict(tt, End(time_d), 'align', 'prev');
startTrial = tsd(max(Range(startTrial), tExtr), Data(startTrial));

figure 
plot(Range(Ym, 's'), Data(Ym))
hold on 
rr = Restrict(Ym, time_d);
plot(Range(rr, 's'), Data(rr), 'r');
rr = Restrict(Ym, time_plat); 
plot(Range(rr, 's'), Data(rr), 'm');


rr = Restrict(Ym, at_reward_d);
plot(Range(rr, 's'), Data(rr), 'yo');

rr = Restrict(Ym, at_reward_r);
plot(Range(rr, 's'), Data(rr), 'yo');

rr = Restrict(Ym, at_reward_l);
plot(Range(rr, 's'), Data(rr), 'yo');


% the trial outcome tsd contains in the Range, the timestamps of reward
% arrival and in data, zero for arrival at rhgt hand side reward and one
% for left hand side reward
ot = [Range(at_reward_r);Range(at_reward_l)];
ox =[zeros(size(Range(at_reward_r))); ones(size(Range(at_reward_l)))];
[ot, ix] = sort(ot);
ox = ox(ix);
trialOutcome = tsd(ot, ox);

ii = intervalSet(startTrial, trialOutcome, '-fixit');
startTrial = ts(Start(ii));
trialOutcome = Restrict(trialOutcome, End(ii), 'align', 'closest');


 rr = Restrict(Ym, startTrial);
plot(Range(rr, 's'), Data(rr), 'g.', 'MarkerSize', 20);


% load file with reports of manually taken notes
[p,n,e] = fileparts(pwd)
 runFname = [ n 'runs.txt'];
 
 % load file with light position as given from the spike2 flags
 digMarkFname = [n 'm_DigMark.mat'];
 if exist(digMarkFname)
    lightRecord = readDigMark(digMarkFname);
    lightRecord = Restrict(lightRecord, startTrial, 'align', 'closest');
 else
     lightRecord = [];
 end    
 
 
 if 0 % exist(runFname)
    % if there is notes files compare it with the automatically generated
    % trialOutcome, if there is any difference, report error 
     [trialDirection, correctError, lightPosition] = readRunsFile(runFname)

     keyboard;
     
     if(any(trialDirection~=Data(trialOutcome)))
         error 'soemthing wrong with runs  file'
     end

     correctError = tsd(Range(trialOutcome), correctError);
     trialDirection= tsd(Range(trialOutcome), trialDirection);
     lightPosition = tsd(Range(trialOutcome), lightPosition);
 else
     % otherwise just take the automatically generated file as good, and
     % generate correct 
     trialDirection = trialOutcome;
     lightDirection = lightRecord;
     correctError = findCorrect(trialOutcome, lightRecord, 'right');
 end

% if isempty(lightRecord)
%     lightRecord = lightPosition;
% end

 % save all variables that will be used for further analysis
 save PosFile correctError startTrial trialOutcome trialDirection lightRecord at_reward* off_reward* time_* phi_* Vs XS YS

 

 % make a human readable (well, almost...) flag file
 flags = [];
 flagtimes = [];

flagtimes = [flagtimes ; Start(time_plat)];
flags = [ flags ; repmat('p', length(Start(time_plat)), 1)]; % enter platform

flagtimes = [flagtimes ; End(time_plat)];
flags = [flags ; repmat('q', length(End(time_plat)), 1)]; % leave platform

flagtimes = [flagtimes ; Range(at_reward_d)];
flags = [flags ; repmat('i', length(Range(at_reward_d)), 1)];

flagtimes = [flagtimes ; Range(off_reward_d)];
flags = [flags ; repmat('j', length(Range(off_reward_d)), 1)];

flagtimes = [flagtimes ; Range(at_reward_r)];
flags = [flags ; repmat('a', length(Range(at_reward_r)), 1)];

flagtimes = [flagtimes ; Range(off_reward_r)];
flags = [flags ; repmat('b', length(Range(off_reward_r)), 1)];

flagtimes = [flagtimes ; Range(at_reward_l)];
flags = [flags ; repmat('m', length(Range(at_reward_l)), 1)];

flagtimes = [flagtimes ; Range(off_reward_l)];
flags = [flags ; repmat('n', length(Range(off_reward_l)), 1)];

flagtimes = [flagtimes ; Range(startTrial)];
flags = [flags ; repmat('d', length(Range(startTrial)),1)];

[flagtimes , ix] = sort(flagtimes);
flags = flags(ix);


fh = fopen([sessionName  '_flags.txt'], 'w');

for i = 1:length(flagtimes)
    fprintf(fh, '%f\t%c\n', flagtimes(i), flags(i));
end

fclose(fh);


keyboard


function lightRecord = readDigMark(fname) 
    load(fname)
    ix = find(Data(DigMark) == 28 | Data(DigMark) == 30);
    
    lightRecord = subset(DigMark, ix);
    lightRecord = tsd(Range(lightRecord), (Data(lightRecord)-28)/2);
    
    
 function ce =findCorrect(side, light, task)
     
     switch(task)
         case 'right'
             ce = Data(side) == 0;
         case 'left'
             ce = Data(side) == 1;
         case 'light'
             ce = Data(side) == Data(light);
         case 'dark'
             ce = Data(side) ~= Data(light);
     end
     
     ce  = tsd(Range(side), ce);
     
     