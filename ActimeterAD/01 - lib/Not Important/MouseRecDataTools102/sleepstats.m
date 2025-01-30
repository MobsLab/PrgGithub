function sleepstats()
% This menu driven program presents plots and statistics related the sleep
% descision statistics produce from the processed sensor data (processed by
% LabVIEW program MouseRec 1.0.0.3.
%
%   Dependencies: cleanfnam(), histint(), hopenlab(), omousefilelab(), 
%                 swseg(), textout(), wakeactivity(), minstdt()
%
% Updated by Kevin D. Donohue (kevin.donohue@sigsoln.com) February 2012 

scnsize = get(0,'ScreenSize');
fszr = [220   200   780   375];   %  Define Figure Size to most plots
%  Scale figure size to screen width.
%fsz = round(fszr.*[scnsize(3)/1179, scnsize(4)/661, scnsize(3)/1179, scnsize(4)/661]);
fsz = [1248          76         990         409];
pnam1 = [];   % Initialize open file menu to current directory
mforder = 5;  %  Default median filter order (not applied until user hits
              %  median filter button)



%  Main Menu to Open file / Program Quit 
nflago = 'd';   %   Set dummy value to start main menu in while loop
anflago = ['o', 'v'];   %  flag values to generate desired actions
%  Loop to open files until exit is selected
while (nflago ~= 'v')
    % Generate Menu
    kflago = menu('Program Options', 'Open File to Plot', 'Exit Program');
    if kflago ~= 0
        nflago = anflago(kflago);  %  Assign option labels if menu not canceled
    else  %  if canceled exit program
        nflago = 'v';
    end
    % Option to open file
    if nflago == 'o'
        %  Function to prompt user to open file and load data in
        %  data structure par
        pause(.5)  %  pause to limit the possibility of picking up an erroneous click
        [par, endit] = hopenlab(pnam1);
        par.tshift = 0;  %  Default time shift
        %  If file opened sucessfuly process parameters to prepare for plotting,
        %  if not, end the open block and return to file select menu
        if endit == 1;
            %  Initalize sliding window length in hours for percent waketime plots
            %  Prompt user to set the averaging interval              
            if isfield(par,'wintv') == 0;  %  if interval not defined yet, set to default
                par.wintv = 2;
            end
            
            if isfield(par,'winc') == 0;  %  If increment not defined yet, set to default
                par.winc = .2;
            end
            
            if isfield(par,'bithresh') == 0;  %  If bout length threshold not defined yet, set to default
                par.bithresh = 256;  %  Default bout length in seconds
            end
            
            if isfield(par,'CSV_min_interval') == 0;  %  If interval not defined yet, set to default
                par.CSV_min_interval = 60;  %  Default interval for exporting summary statistics
            end
            
            if isfield(par,'ignore_interupt') == 0;  %  If duration not defined yet, set to default
                %  Ignore wake/motion disturbances of this duration in seconds or less
                par.ignore_interupt = 4;  
            end
                  
           if isfield(par,'actrange') == 0;  %  If peak activity range not set to default
                par.actrange(1) = 3;  %  Hours before dark onset
                par.actrange(2) = 6;  %  Hours after dark onset
           end
        
            if isfield(par,'threshv') == 0;  %  If thresholds not defined yet, compute adaptive ones
                  % Compute the thresholds for each day and let overall
                  % threshold be the median of the thresholds over all days.
                  % Loop through each channel
                  tdum = zeros(par.headerinfo.chan,4);
                  for i=1:par.headerinfo.chan
                     tlen=length(par.sw(:,i)); % length of the sleep-wake statistics for each channel
                     dlen=ceil((24*60*60)/2); % number of sleep-wake statistics per day(divide by 2 as sw decision is made every two seconds)
                     kt=1;   % index to the 24 hour blocks
                     ct=1;   %  Day counter
                     % There must be at least one full day for adaptive
                     % threshold to work, if not set threshold to 0.
                     if (tlen<=dlen)
                         par.threshv(i)=0;
                     else  %  If more than one day available, do some clustering
                     %  Loop through each day of data
                    % tdum = [];   %  Initalize threshold output
                     while (kt<=tlen-dlen) 
                            %  find minimum variance threshold for i-th channel and
                            %  ct-th day
                            tdum(i,ct) = minstdt(par.swtrim((kt:kt+dlen-1),i));
                            ct=ct+1; %increment the counter after each day
                            kt=kt+dlen;  %  Increment data index to next day
                     end
                     % the final threshold is the median threshold of all days
                     par.threshv(i)=median(tdum(i,:));
                     end
                    
                  end
                  csvwrite('daythresh.csv', tdum);
                  
            end
            % Save parameter is mat file to recall in later sessions        
           save([par.pnam,par.fnam(1:end-7),'mat'],'-struct','par','ldtimes','idcell','threshv',  ...
            'ignore_interupt', 'CSV_min_interval', 'bithresh','actrange')  %  Save changes to fields in mat file
%       
            sw = par.sw;  %  store original set of sleep-wake statsitcs in a working copy for restoring if needed
            dd=get(0,'Children');
            %  Convert light-dark times to hours
            ldt = datevec(par.ldtimes);  
            ldhrs = ldt(:,4:6)*[1; 1/60; 1/60^2]; 
            %  find all dark to light transition times (daybreak) on data axis
            lintime = par.taxhr+par.tshift;      % assign linear time in hours
            % Compute sampling increment to round off light-dark marker
            % times to closest points time points on axis
            daybtimes = cyctimes(ldhrs(1),lintime,24);   %  Daybreak times
            nightftimes = cyctimes(ldhrs(2),lintime,24); %  Nightfall times
            %  Set begining to first daybreak from experiment to last
            %  daybreak
            if length(daybtimes) < 2  %  Unless segment does not contain a full day
                btime = lintime(1);
                etime = lintime(end);
            else
               btime = daybtimes(1);
               etime = daybtimes(end);
            end
            %  Integer day range  (Fraction of a day at the begining cutoff
            intdayrng = find(lintime >= btime & lintime < etime);
          
            %  Display submenu for plotting and processing options
            %     Labels for case statements
 
             kflagid = {'Sleep-Wake-Statistic', 'Histo_Sleep-Wake-Statistic', 'Daily-Sleep', 'Light-Dark-Sleep', 'Wake-Activity', 'Sleep-Epochs', 'Export-CSV',...
                        'Export-Excel_SleepPercent/min', 'Export-Excel_BoutLengths/hour', 'Close-Figs', 'Copy-Figs', 'Change-Options', 'q'};
  
            nflag = 'u';   %Dummy value to pass into while loop      
            %  Loop to give operator options for plotting
            while (nflag ~= 'q')
              % Generate Menus
   
            kflag = menu('Select Display Options', 'Plot Sleep-Wake Decision Statistics', 'Plot Sleep-Wake Decision Histogram', 'Percent Daily Sleep', ...
            'Percent Sleep in Light/Dark', 'Percent Wake over Sliding Interval', 'Sleep Bout Length Histograms', 'Daily Sleep Stats Export CSV', ...
            'Hourly Sleep Percentage Export CSV', 'Hourly Sleep Bout Stats Export CSV', 'Close All Figures', 'Copy Selected Figure', 'Change Processing Options','Quit/Get New File' );
                      
             % If menu canceled just quit
              if kflag == 0
                 nflag = 'q';
              else
                  lastoption = 0;  % Flag to enter into menu's
                                   %  while loop (set to 1 to exit)   
                  switch kflagid{kflag};
                            case 'Change-Options' ; %  Option to change processing parameters
                               kchofig = 1;  % Initalize value to enter while loop for submenu
                               %  id labels for cases
                              
                               kchoid = {'Change_Decision_Threshold', 'Change_Light/Dark_Times', 'Change_Sleep_Movement_Threshold',  ...
                               'Wake_Activity_Window_Length', 'Peak-activity-range', 'Hourly_Stats_Interval', 'Tail_Statistic_Threshold',  'Save_Changes', 'Previous_Menu'};
                               while 0 == lastoption     
                                   kchofig = menu('Plot options', 'Change Decision Threshold', 'Change Light/Dark Times', 'Change Sleep Movement Threshold',  ...
                                   'Change Wake Activity Intervals','Change Activity Peak and Onset Range', 'Change Interval for CSV Export', 'Change Sleep Bout Threshold', 'Save Changes', 'Previous Menu');


                                   %  Option to change Threshold,
                                   switch kchoid{kchofig}
                                       case 'Change_Decision_Threshold'
                                           
                                             %  Get choice of channel to plot
                                              pchannum = menu('select the mouse threshold to change',par.idcell{:});
                                              %  If a valid channel selected , plot it!
                                              if pchannum<=par.headerinfo.chan && pchannum > 0
                                                  %  Default times for switch in light and dark 
                                                   swthresh = { num2str(par.threshv(pchannum))}; 
                                                   swtprompt = {['Enter Threshold Value for ' par.idcell{pchannum}]};
                                                   dtitle = 'Sleep-Wake Decision Threshold ';
                                                   numlns = 1;
                                                   % Prompt user for input
                                                   dumcell = inputdlg(swtprompt,dtitle,numlns,swthresh,'on');
                                                   if ~isempty(dumcell)
                                                       % new constant threshold vector 
                                                           par.threshv(pchannum) = str2double(dumcell{1});
                                                   else
                                                           th = warndlg('Channel number not valid. Threshold not changed');
                                                           pause(2)
                                                           if ishandle(th)
                                                            close(th)
                                                           end   
                                                   end
                                                else
                                                      th = warndlg('Threshold not changed');
                                                      pause(2)
                                                      if ishandle(th)
                                                          close(th)
                                                      end
                                              end                                           
                                           
                                       
                                     %   Option to Change light-dark-times    
                                     case 'Change_Light/Dark_Times'
                                        %  Default times for switch in light and dark 
                                        ntimes = length(par.ldtimes);
                                        tprompt = cell(1,ntimes); % Create prompt strings to enter time
                                        tprompt{1} = 'Dark-to-Light time (Light Onset):';
                                        tprompt{2} = 'Light-to-Dark time (Dark Onset):';
                                        dtitle = 'Enter Light Dark Transition Times (military time format)';
                                        numlns = 1;
                                        % Prompt user for new Light/Dark Times
                                        dumcell = inputdlg(tprompt,dtitle,numlns,par.ldtimes,'on');
                                        if ~isempty(dumcell)
                                            par.ldtimes = dumcell;
                                            ldt = datevec(par.ldtimes);
                                            if ldt(1,4) < 24 && ldt(1,4) >= 0  && ldt(2,4) < 24 && ldt(2,4) >= 0
                                                ldhrs = ldt(:,4:6)*[1; 1/60; 1/60^2];            
                                                % Compute sampling increment to round off light-dark marker
                                                % times to closes points time points on axis
                                                daybtimes = cyctimes(ldhrs(1),lintime,24);   %  Daybreak times
                                                nightftimes = cyctimes(ldhrs(2),lintime,24); %  Nightfall times
                                            else
                                                th = warndlg('Hours not in range [0, 34). Markers not changed');
                                                pause(2)
                                                if ishandle(th)
                                                   close(th)
                                                end
                                            end
                                        else  %  If menu canceled warn used and indicate nothing was changed
                                            th = warndlg('Markers not changed');
                                            pause(2)
                                            if ishandle(th)
                                               close(th)
                                            end   
                                        end
                                   %  Option to change sleep movement threshold
                                   case 'Change_Sleep_Movement_Threshold'
                                       %  Default threshold 
                                       txtstr = {num2str(par.ignore_interupt)}; 
                                       txtprompt = 'Enter sleep movement threshold (in seconds)';
                                       dtitle = 'Movement Threshold';
                                       numlns = 1;
                                      % Prompt user for input
                                       dumcell = inputdlg(txtprompt,dtitle,numlns,txtstr,'on');
                                      if ~isempty(dumcell)
                                        par.ignore_interupt = str2double(dumcell{1});                      
                                      else
                                        th = warndlg('Threhsold Not Changed ');
                                        pause(2)
                                        if ishandle(th)
                                          close(th)
                                        end
                                      end 

                                  %  option to apply median filter
                                  case 'Apply_Median_Filter'
                                       %  Default filter order 
                                       filord = {num2str(mforder)}; 
                                       filoprompt = 'Enter Median filter order';
                                       dtitle = 'Median Filter Order';
                                       numlns = 1;
                                      % If option to add id codes selected, prompt user for input
                                       dumcell = inputdlg(filoprompt,dtitle,numlns,filord,'on');
                                      if ~isempty(dumcell)
                                        mforder = str2double(dumcell{1});
                                        sw = medfilt1(par.sw,mforder);
                                      else
                                        th = warndlg('Filter Option Canceled ');
                                        pause(2)
                                        if ishandle(th)
                                          close(th)
                                        end
                                      end      

                                % Option to Change percent wake activity sliding window length
                                case 'Wake_Activity_Window_Length'
                                        wsint = {num2str(par.wintv),num2str(par.winc)};
                                        wsprompt = {'Enter Averaging Interval (in hours)', ...
                                            'Enter Sliding Window Increment (in hours)'};
                                        dtitle = 'Peak Activity Analysis';
                                        numlns = 1;
                                       % Prompt user for input length of
                                       % sliding interval and increment

                                        dumcell = inputdlg(wsprompt,dtitle,numlns,wsint,'on');
                                        if ~isempty(dumcell)
                                           wintv = str2double(dumcell{1});
                                           par.wintv = wintv;
                                           winc = str2double(dumcell{2});
                                           par.winc = winc;
                                        else
                                          th = warndlg('Window values not selected use default');
                                          pause(2)
                                          if ishandle(th)
                                             close(th)
                                          end
                                        end

                                        
                                        
                              % Option to Change range for activity onset
                              % and peak activity with respect to dark
                              % onset
                                case 'Peak-activity-range'
                                        wsint = {num2str(par.actrange(1)),num2str(par.actrange(2))};
                                        wsprompt = {'Enter hours before dark onset', ...
                                            'Enter hours after dark onset'};
                                        dtitle = 'Peak Activity and Onset';
                                        numlns = 1;
                                       % Prompt user for input length of
                                       % sliding interval and increment

                                        dumcell = inputdlg(wsprompt,dtitle,numlns,wsint,'on');
                                        if ~isempty(dumcell)
                                           par.actrange(1) = str2double(dumcell{1});
                                           par.actrange(2) = str2double(dumcell{2});
                                        else
                                          th = warndlg('Range values not changed!');
                                          pause(2)
                                          if ishandle(th)
                                             close(th)
                                          end
                                        end
                                        
                                        
                                        
                                        
                                        % Option to Change percent wake activity sliding window length
                                case 'Hourly_Stats_Interval'
                                        backupp = par.CSV_min_interval;
                                        wsint = {num2str(par.CSV_min_interval)};
                                        wsprompt = {'Enter Interval in Minutes'};
                                        dtitle = 'Interval/Increment for CSV Sleep Stats';
                                        numlns = 1;
                                       % Prompt user for input length of
                                       % sliding interval and increment

                                        dumcell = inputdlg(wsprompt,dtitle,numlns,wsint,'on');
                                        if ~isempty(dumcell)
                                           par.CSV_min_interval = str2double(dumcell{1});
                                           %  Make sure we round to nearest
                                           %  Minute
                                          par.CSV_min_interval = round(par.CSV_min_interval);
                                           if par.CSV_min_interval < 1
                                            th = warndlg('Interval value less than 1 minute, not valid');
                                            par.CSV_min_interval = backupp;  % restore value
                                            pause(2)
                                            if ishandle(th)
                                              close(th)
                                            end
                                          end

                                        else
                                          th = warndlg('Window values not selected use default');
                                          pause(2)
                                          if ishandle(th)
                                             close(th)
                                          end
                                        end
                                        
                                  % Option to Change tail statistics threshold
                                  case 'Tail_Statistic_Threshold'
                                        bithresh = {num2str(par.bithresh)};
                                        wsprompt = 'Threshold (in seconds)';
                                        dtitle = 'Probability a sleep interval is greter than threshold';
                                        numlns = 1;
                                       % Prompt user for input length of sliding interval
                                        dumcell = inputdlg(wsprompt,dtitle,numlns,bithresh,'on');
                                        if ~isempty(dumcell)
                                           bithresh = str2double(dumcell{1});
                                           par.bithresh = bithresh;
                                        else
                                          th = warndlg('Interval not selected usedefault');
                                          pause(2)
                                          if ishandle(th)
                                             close(th)
                                          end
                                        end

                                  % Option to save changes
                                  case 'Save_Changes'
                                        save([par.pnam,par.fnam(1:end-7),'mat'],'-struct','par','ldtimes','idcell','threshv', ...
                                        'ignore_interupt', 'CSV_min_interval', 'bithresh', 'actrange')  %  Save changes to fields in mat file
                                     %  Shift time
                                 case 'Shift_Time'
                                       if isfield(par,'tshift') 
                                           tshift = {num2str(par.tshift)};
                                       else
                                           tshift = {num2str(0)};
                                       end
                                        wsprompt = 'Time shift (in hours)';
                                        dtitle = 'Time shift option';
                                        numlns = 1;
                                        % Prompt user for time axis shift
                                        dumcell = inputdlg(wsprompt,dtitle,numlns,tshift,'on');
                                        if ~isempty(dumcell)
                                           par.tshift = str2double(dumcell{1});
                                           lintime = par.taxhr+par.tshift;      % assign linear time in hours
                                        else
                                          th = warndlg('time shift not selected');
                                          pause(2)
                                          if ishandle(th)
                                             close(th)
                                          end
                                        end
                                    otherwise
                                    lastoption = 1;  %  Leave recuring processing menu options       
                                   end    
                                end    %  IF end change parameters adn processing options
                      case 'Sleep-Wake-Statistic' % Option to plot Sleep-Wake Statistics
                            poutthere = 0;  %  Set flag off for option to get real data 
                            kchofig = 1;  % Initalize value to enter while loop
                            while kchofig ~= 3 && kchofig > 0
                               if poutthere == 0   %  Menu if plot not available 
                                  kchofig = menu('Plot options', 'Individual', 'All', 'Previous Menu');
                               else  %  Menu if plot for original data range selection available
                                  kchofig = menu('Plot options', 'Individual', 'All', 'Previous Menu', 'Superimpose Sensor Data');
                               end
                               %   If individual plot selected
                               if kchofig == 1
                                   %  Get choice of channel to plot
                                   pchannum = menu('select the mouse data to plot',par.idcell{:});
                                     %  If a valid channel selected , plot it!
                                       if pchannum<=par.headerinfo.chan && pchannum > 0
                                         hfiglast = figure;  %  Store figure handle incase motion data plot is requested
                                         %  Plot detection stats for requested channel
                                         plot(lintime,sw(:,pchannum))
                                         hold on
                                         plot(lintime, ones(1,length(sw(:,pchannum)))*par.threshv(pchannum),'g--')
                                         hold off
                                         set(gcf,'Position', fsz);
                                         lightdarklines(gcf,daybtimes,nightftimes); %  Put light dark marker on plot
                                         xlabel('Hour (military time)')
                                         ylabel('Sleep-Wake Statistic')
                                         title([par.fnam(1:end-8) ': Sleep-Wake stats for ' par.idcell{pchannum} '. Sleep above and wake below threshold (broken line)'], 'interpreter','none')
                                         poutthere = 1;  %  Set flag on for option to get real data
                                      else
                                          th = warndlg('Plot Option Canceled ');
                                          pause(2)
                                          if ishandle(th)
                                              close(th)
                                          end
                                      end
                               % Option to plot all channels
                               elseif kchofig == 2
                                poutthere = 0;  %  Set flag off for option to get real data
                                %  Loop through every channel
                                for kpp = 1:par.headerinfo.chan
                                    figure
                                   %  Compute starting hour of the day
                                    plot(lintime,sw(:,kpp))
                                      hold on
                                      plot(lintime, ones(1,length(sw(:,kpp)))*par.threshv(kpp),'g--')
                                      hold off
                                    set(gcf,'Position', fsz);
                                    % Plot light dark transition markers 
                                    lightdarklines(gcf,daybtimes,nightftimes);
                                    xlabel('Hour (military time)')
                                    ylabel('Sleep-Wake Statistic')
                                    title([par.fnam(1:end-8) ': Sleep-Wake stats for ' par.idcell{kpp} '. Sleep above and wake below threshold (broken line)'], 'interpreter','none')
                                   print -dmeta
                                   pause
                                end
                               %  Option to superimpose raw motion data
                               elseif kchofig ==4
                                   %  compute starting time
                                   tst = par.headerinfo.sh*60^2+par.headerinfo.sm*60+par.headerinfo.ss;
                                   figure(hfiglast)  %  Select last figure plotted
                                   xlims = get(gca,'Xlim');
                                   xlimits = xlims;
                                  % xlimits(1) = max([lintime(1),xlims(1)]);
                                  % xlimits(2) = min([xlims(end), lintime(end)]);
                                   xlimsec = xlimits*60^2;
                                   durate = xlimits(2)-xlimits(1);
                                   %  If a long duration is on the figure, warn user
                                   %  and prompt with insturctions 
                                   if durate > 5
                                       huh = ['Current figure axis corresponds to ' num2str(durate) ' hours of data, which ' ...
                                               'will be hard to see detail and may take a long time to plot.  It is recomended that ' ...
                                               'you quit and zoom in on a smaller area.  Do you want to quit?'];
                                           bt1 = 'quit';
                                           bt2 = 'continue';
                                           resp = questdlg(huh, 'Are you sure?',bt1, bt2, bt1);
                                           if resp(1) == 'q' || isempty(resp)
                                               pflag = 0; % Flag to indicate don't plot
                                           else
                                               pflag = 1;  %  Flag to indicate continue on with plot
                                           end
                                   else
                                       pflag = 1;  % Data segement reasonably short, follow through on plot
                                   end
                                   %  if user still wanted to plot, do it!
                                   if pflag == 1    
                                       fn = [par.pnam, par.fnam(1:end-7)];  %  Create default file name for original binary file
                                       % Frequency range in Hz for processing motion
                                       % data segment
                                       lowlim = .5;
                                       highlim = 10;
                                       lfcutoff = lowlim;  %  Filter data, low frequency cutoff in Hz
                                       hfcutoff = highlim;  %  Filter data, high frequency cutoff in Hz
                                       filord = round(par.headerinfo.fs*2/lfcutoff)-1;
                                       filpar.b = fir1(filord,2*[lfcutoff hfcutoff]/par.headerinfo.fs);  %  Compute Filter coefficients
                                       filpar.a = 1;
                                       [bb,ba] = butter(5,[6.6 9.697]/(par.headerinfo.fs/2),'stop');
                                       filpar.b = conv(filpar.b,bb);
                                       filpar.a = conv(filpar.a,ba);
                                       locfil = exist([fn 'bin'], 'file');
                                       %  If file with same base name is present in directory, open it, if not give user a search option 
                                       if locfil == 2
                                           %   Open raw data file
                                           filpar.lim = xlimsec-tst;
                                           filpar.showwin = 0;
                                           [d,info, hd, ef, t] = omousefilelab([fn 'bin'], pchannum-1, filpar);
                                            %  If file read window still open, close it
                                           if ishandle(hd)
                                               close(hd)
                                           end
                                           if isempty(d)
                                               noopen = 1;
                                           else
                                               noopen = 0;
                                           end
                                       else  %  Search for binary data file if not in current direcotory or has other name 
                                           [fnb, pnb] = uigetfile([par.pnam '*'],'get raw signal file');
                                           if fnb ~= 0
                                               filpar.lim = xlimsec-tst;
                                               filpar.showwin = 0;
                                               [d,info, hd, ef, t] = omousefilelab([pnb, fnb],pchannum-1, filpar);
                                               if ishandle(hd)
                                                   close(hd)
                                               end
                                               if isempty(d)
                                                  noopen = 1;
                                               else
                                                  noopen = 0;
                                               end
                                           else   %  if file menu canceled skip plot
                                               noopen = 1;
                                           end
                                       end
                                       %  If file opened ok, then proceed with plot
                                       if noopen == 0
                                           figure(hfiglast)
                                           rdindx = find(lintime <= xlimits(2) & lintime >= xlimits(1));
                                           plot((tst+t)/60^2,d,'r',lintime(rdindx),sw(rdindx,pchannum),'b')
                                         %  Superimpose threshold
                                           hold on
                                         plot(lintime(rdindx), ones(1,length(sw(rdindx,pchannum)))*par.threshv(pchannum),'g--')
                                         hold off
                                           title([par.fnam(1:end-8) ': Sleep-Wake Stats(blue) + original waveform(red) for ' par.idcell{pchannum} '. Sleep above and wake below threshold (broken line)'], 'interpreter','none')
                                           set(hfiglast,'Position', fsz);
                                           axis('tight')
                                           xlabel('Hours')
                                           
                                       end
                                   end
                               end
                            end     
               
                            case 'Histo_Sleep-Wake-Statistic' % Option to plot Sleep-Wake Statistics
                            
                            kchofig = 1;  % Initalize value to enter while loop
                            while kchofig ~= 3 && kchofig > 0
                               %  Menu  
                                  kchofig = menu('Plot options', 'Individual', 'All', 'Previous Menu');
                               
                               %   If individual plot selected
                               if kchofig == 1
                                   %  Get choice of channel to plot
                                   pchannum = menu('select the mouse data to plot',par.idcell{:});
                                     %  If a valid channel selected , plot it!
                                       if pchannum<=par.headerinfo.chan && pchannum > 0
                                         %  Plot histogram for stats for requested channel

                                         figure
                                         hist(par.swtrim(:,pchannum),100)
                                         hold on
                                         plot(par.threshv(pchannum)*[1 1], ylim, 'g--')
                                         xlabel('Sleep-Wake Decision Statsitics')
                                         ylabel ('Occurrences')
                                         title([par.fnam(1:end-8) ': Sleep-Wake Histogram ' par.idcell{pchannum} '. threshold (broken line)'], 'interpreter','none')
                                         hold off
                                         
                                         set(gcf,'Position', fsz);
                                       else
                                          th = warndlg('Plot Option Canceled ');
                                          pause(2)
                                          if ishandle(th)
                                              close(th)
                                          end
                                        end
                                       % Option to plot all channels
                                  elseif kchofig == 2
                                  %  This section plots all histograms of stats
                                        for kpp = 1:par.headerinfo.chan
                                             figure
                                             hist(par.swtrim(:,kpp),100)
                                             hold on
                                             plot(par.threshv(kpp)*[1 1], ylim, 'g--')
                                             xlabel('Sleep-Wake Decision Statsitics')
                                             ylabel ('Occurrences')
                                             title([par.fnam(1:end-8) ': Sleep-Wake Histogram ' par.idcell{kpp} '. threshold (broken line)'], 'interpreter','none')
                                             hold off
                                             set(gcf,'Position', fsz);
                                        end
                               end
                            end
                            
                            
                            
                            
                            
                            
                      case 'q'   %  Option to quit
                           nflag = 'q';
               
                      case 'Wake-Activity'    %  option to display percent wake state over sliding time interval
                            [nttax, ntind] = swseg(par.taxhr+par.tshift, daybtimes,nightftimes, ldhrs);
                            wsint = {num2str(par.wintv)};  % length of sliding window in hours
                            tlen = par.taxhr(end)-par.taxhr(1)+par.tshift;
                            nplot = tlen/par.wintv;   %  See how many points will be plotted
                            if nplot < par.wintv/2
                               th = warndlg(['Interval should be less that half the data segment length (which is ' num2str(tlen) ' hrs )']);
                               pause(4)
                               if ishandle(th)
                                  close(th)
                               end
                            else
                               kplot = menu('select mouse data to plot', [par.idcell{:}, {'all'}]);
                               if kplot ~= 0
                                  if kplot<=par.headerinfo.chan
                                      figure
                                      set(gcf,'Position', fsz);
                                      set(gca,'Ylim',[0 110])
                                      hold on
                                      % passing the new threshold
                                      wakeactivity(sw(:,kplot),par,par.threshv(kplot),nightftimes,daybtimes, 1);
                                      %  Attach export function of data to figure
                                      trm = [par.fnam(1:end-8) , '_', par.idcell{kplot}];
                                      fname = cleanfnam(trm);
                                      set(gcf,'UserData',fname);
                                      uimenu(gcf,'Label', 'Export CSV','Callback', {'ExportCSV_Callback', par.pnam});
                                      
                                      % Plot light dark transition markers 
                                      lightdarklines(gcf,daybtimes,nightftimes);
                                      hold off
                                      xlabel('Hour (military time)')
                                      ylabel('Percent Wake')
                                      title([par.fnam(1:end-8) ', ' par.idcell{kplot} ': Percent Wake over ' char(wsint) 'hr Windows, Activity onset (Thin Red line) relative to dark onset'], 'interpreter','none')
                                     
                                  else   %  Plot All
                                     for kpp = 1:par.headerinfo.chan
                                      figure
                                      set(gcf,'Position', fsz);
                                      set(gca,'Ylim',[0 110])
                                      hold on
                                      wakeactivity(sw(:,kpp),par,par.threshv(kpp),nightftimes, daybtimes, 1);
                                      %  Attach export function of data to figure
                                      trm = [par.fnam(1:end-8) , '_', par.idcell{kpp}];
                                      fname = cleanfnam(trm);
                                      set(gcf,'UserData',fname);
                                      uimenu(gcf,'Label', 'Export CSV','Callback', {'ExportCSV_Callback', par.pnam});

                                      % Plot light dark transition markers 
                                      lightdarklines(gcf,daybtimes,nightftimes);
                                      hold off
                                      xlabel('Hour (military time)')
                                      ylabel('Percent Wake')
                                      title([par.fnam(1:end-8) ', ' par.idcell{kpp} ': Percent Wake over ' char(wsint) 'hr Windows, Activity onset (Thin Red line) relative to dark onset'], 'interpreter','none')
                                      
                                     end
                                  end
                               end     
                            end
                
                      case 'Daily-Sleep'  %  Option to compute overall sleep percentage
                            [nr,nc] = size(sw(intdayrng,:));
                            %  Loop through each channel and compute percent time
                            %  detect in sleep state
                            persltot = zeros(nc,1);  % allocate vector to store percentages
                            for kslp = 1:nc
                                slp=find(sw(intdayrng,kslp) >= par.threshv(kslp));%using new threshold par.threshv
                                persltot(kslp) = 100*length(slp)/nr;
                            end
                            figure
                            bar(persltot)
                            set(gcf,'Position', fsz);
                            bf = get(gca,'Children');
                            set(bf,'FaceColor','c');
                            set(gca,'Ylim', [0 110])
                            set(gca,'XTicklabel','');
                            text((1:nc)-.6,-34*ones(1,nc),par.idcell,'Rotation',60, 'HorizontalAlignment', 'Left', 'interpreter','none');
                            set(gca,'Position',[.13, .23, .775, .7000])
                            for kslp=1:nc
                                text(kslp,persltot(kslp)+5,num2str(persltot(kslp),2));
                            end
                            ylabel('Percentage Sleep')
                            if ~isempty(daybtimes)
                                 title([par.fnam(1:end-8) ':Sleep Percentage over ' num2str(daybtimes(end)-btime) ' hours'], 'interpreter','none')
                            else
                                 title([par.fnam(1:end-8) ':Sleep Percentage over ' num2str(etime-btime) ' hours'], 'interpreter','none')
                            end    

                      case 'Light-Dark-Sleep'  %  Light and Dark Sleep Percentages
                            [nr,nc] = size(sw(intdayrng,:));
                            %  Check to see the light dark nature of the interval
                            %  if interval does not include a light-dark transition
                            dts = find(daybtimes >= btime);
                            nts = find(nightftimes >= btime);
                            [nttax, ntind, dytax, dyind] = ...
                                   swseg(par.taxhr+par.tshift, daybtimes(dts),nightftimes(nts), ldhrs);
                            dtot = [];
                            ntot = [];
                            %  Concatenate all nighttime indecies
                            for kl = 1:length(ntind);
                                ntot = [ntot; ntind{kl}'];
                            end
                            %  Concatenate all daytime indecies
                            for kl = 1:length(dyind);
                                dtot = [dtot; dyind{kl}'];
                            end
                            
                            perslday = zeros(nc,1); %  Allocate day sleep precentage vector
                            perslnight = zeros(nc,1); % Allocate night sleep precentage vector
                            for kslp = 1:nc  % All in the day
                               slp=find(sw(dtot,kslp) >= par.threshv(kslp));
                               perslday(kslp) = 100*length(slp)/(length(dtot)+eps);
                            end
                            for kslp = 1:nc  % All in the night
                               slp=find(sw(ntot,kslp) >= par.threshv(kslp));
                               perslnight(kslp) = 100*length(slp)/(length(ntot)+eps);
                            end
                            %  Plot figure for daytime sleep
                            figure
                            bar(perslday)
                            set(gcf,'Position', fsz);
                            bf = get(gca,'Children');
                            set(bf,'FaceColor','c');
                            set(gca,'Ylim', [0 110])
                            set(gca,'XTicklabel','');
                            text((1:nc)-.6,-34*ones(1,nc),par.idcell,'Rotation',60, 'HorizontalAlignment', 'Left', 'interpreter','none');
                            set(gca,'Position',[.13, .23, .775, .7000])
                            for kslp=1:nc
                                text(kslp,perslday(kslp)+5,num2str(perslday(kslp),2));
                            end
                            ylabel('Percentage Sleep')
                            title([par.fnam(1:end-8) ': Daytime Sleep Percentage'], 'interpreter','none')
                            
                            %  Plot figure for nighttime sleep
                            figure
                            bar(perslnight)
                            set(gcf,'Position', fsz);
                            bf = get(gca,'Children');
                            set(bf,'FaceColor','c');
                            set(gca,'Ylim', [0 110])
                            set(gca,'XTicklabel','');
                            text((1:nc)-.6,-34*ones(1,nc),par.idcell,'Rotation',60, 'HorizontalAlignment', 'Left', 'interpreter','none');
                            set(gca,'Position',[.13, .23, .775, .7000])
                            for kslp=1:nc
                                text(kslp,perslnight(kslp)+5,num2str(perslnight(kslp),2));
                            end
                            ylabel('Percentage Sleep')
                            title([par.fnam(1:end-8) ': Nighttime Sleep Percentage'], 'interpreter','none')
                            

                      case 'Sleep-Epochs' %  Option to plot sleep interval histogram
                            khist = 1;  % Initalize value to enter while loop
                            xticklab = {'2' '8' '16' '32' '64' '128' '256' '>256'};
                            warning('off','MATLAB:log:logOfZero')
                           while khist ~= 3 && khist > 0
                              khist = menu('Histogram Plot 0ptions', 'Total Time Period', 'Separate Light/Dark Histogram', 'Previous Menu');
                               %  Option to daily sleep interval histograms
                              if khist == 1
                                  kchofig = 1;
                                  sampincs = 60*60*abs(lintime(2)-lintime(1)); % Compute sampling increment in seconds for sleep wake detections
                                  %  Menu options for plot all or individual
                                  while kchofig ~= 3 && kchofig > 0
                                    kchofig = menu('Plot options', 'Individual', 'All', 'Previous Menu');
                                    if kchofig == 1
                                        %  present text menu of choices
                                        pchannum = menu('select the mouse data to plot',par.idcell{:});
                                        if pchannum<=par.headerinfo.chan && pchannum>0                                   
                                                figure
                                                [freq, bins, stats] = histint(sw(intdayrng,pchannum),sampincs,par.threshv(pchannum), par.bithresh,par.ignore_interupt);
                                                bhand = bar([1:length(freq)]-.5,log2(freq));
                                                set(bhand(1),'FaceColor',[.5 .5 .5]);
                                                set(gca,'XtickLabel',xticklab)
                                                set(gcf,'Position', fsz);
                                                xlabel('seconds')
                                                ylabel('Log base 2 of Sleep Intervals')
                                                title([par.fnam(1:end-8) ': Sleep-Interval Histogram for ' par.idcell{pchannum} '. mean= ' num2str(stats.mean) ', STD = ' num2str(stats.std) ], 'interpreter','none')
                                               
                                        else
                                                th = warndlg('Plot Option Canceled ');
                                                pause(2)
                                                if ishandle(th)
                                                   close(th)
                                                end
                                        end

                                    %   Plot All
                                    elseif kchofig == 2
                                        [nr,nc] = size(sw);
                                        for kpp = 1:par.headerinfo.chan
                                           figure
                                           %  Compute starting hour of the day
                                           [freq, bins, stats] = histint(sw(intdayrng,kpp),sampincs,par.threshv(kpp), par.bithresh,par.ignore_interupt);
                                           bhand = bar([1:length(freq)]-.5,log2(freq));
                                           set(bhand(1),'FaceColor',[.5 .5 .5]);
                                           allquan(kpp) = 1-stats.q;  %  1-cdf
                                           totintervals(kpp) = allquan(kpp)*sum(freq);   %  number of intervals greater then threshold 
                                           set(gca,'XtickLabel',xticklab)
                                           set(gcf,'Position', fsz);
                                           xlabel('seconds')
                                           ylabel('Log base 2 of Sleep Intervals')
                                           title([par.fnam(1:end-8) ': Sleep-Interval Histogram for ' par.idcell{kpp} '. mean= ' num2str(stats.mean) ', STD = ' num2str(stats.std) ], 'interpreter','none')
                                          
                                        end
                                    end
                                  end
                               %  Light and Dark Sleep Interval histograms
                               elseif khist == 2
                                 leglabs = {'Day', 'Night'};  %  Legend labels 
                                 kchofig = 1;
                                 sampincs = abs(lintime(2)-lintime(1))*60*60; % Compute sampling increment in seconds for sleep wake detections
                                 while kchofig ~= 3 && kchofig > 0
                                    kchofig = menu('Plot options', 'Individual', 'All', 'Previous Menu');
                                    if kchofig == 1
                                        %  present text menu of choices
                                        pchannum = menu('select the mouse data to plot',par.idcell{:});
                                       
                                        if pchannum<=par.headerinfo.chan && pchannum > 0
                                        kpp = pchannum;  %  Set index for selected channel
                                        %  Check to see the light dark nature of the interval
                                        %  if interval does not include a light-dark transition
                                            dts = find(daybtimes >= btime);
                                            nts = find(nightftimes >= btime & nightftimes <= etime);
                                            [nttax, ntind, dytax, dyind] = ...
                                              swseg(par.taxhr+par.tshift, daybtimes(dts),nightftimes(nts), ldhrs);
                                            dtot = [];
                                            ntot = [];
                                            %  Concatenate indecies
                                            %  assoicated with nighttime
                                            for kl = 1:length(ntind);
                                                ntot = [ntot; ntind{kl}'];
                                            end
                                            %  Concatenate indecies
                                            %  assocaited wtih daytime
                                            for kl = 1:length(dyind);
                                                dtot = [dtot; dyind{kl}'];
                                            end

                                             % All in the day
                                            
                                             [freqd, bins, statsd] = histint(sw(dtot,pchannum),sampincs, par.threshv(pchannum), par.bithresh,par.ignore_interupt);
                                             %  All in the night
                                             [freqn, bins, statsn] = histint(sw(ntot,pchannum),sampincs, par.threshv(pchannum), par.bithresh,par.ignore_interupt);
                                             lend = length(freqd);
                                             lenn = length(freqn);
                                             
                                             %  Ensure Day and Night bin
                                             %  are equal in length
                                             if  lend > lenn  %  extend night with zeros
                                                 freqn(lenn+1:lend) = 0;
                                             elseif lenn > lend  %  extend day with zeros
                                                 freqd(lend+1:lenn) = 0;
                                             end
                                               hfiglast = figure;     
                                              bhand = bar([1:length(freqn)]-.5,log2([freqd; freqn]'),'grouped');
                                              set(bhand(1),'FaceColor',[1 1 1]);
                                              set(bhand(2),'FaceColor',[0 0 0]);
                                              %set(gca,'Xtick', [0:length(freqn)-1])
                                              set(gca,'XtickLabel',xticklab)
                                              set(gcf,'Position', fsz);
                                              xlabel('seconds')
                                              ylabel('Log base 2 of Sleep Intervals')
                                              title({[par.fnam(1:end-8) ': Daytime Sleep-Interval Histogram for ' par.idcell{kpp} '. mean= ' num2str(statsd.mean) ', STD = ' num2str(statsd.std) ]; ...
                                                                     ['Nighttime Sleep-Interval Histogram for ' par.idcell{kpp} '. mean= ' num2str(statsn.mean) ', STD = ' num2str(statsn.std) ]}, 'interpreter','none')
                                     %         title([par.fnam(1:end-8) ': Daytime Sleep-Interval Histogram for ' par.idcell{pchannum} '. mean= ' num2str(statsd.mean) ', STD = ' num2str(statsd.std) ], 'interpreter','none')
                                              legend(leglabs)
                                              hold off
                                              
                                           else
                                               th = warndlg('Plot Option Canceled ');
                                               pause(2)
                                               if ishandle(th)
                                                  close(th)
                                               end
                                           end

                               elseif kchofig == 2
                                %  Plot All
                                 [nr,nc] = size(sw);
                                 
                                            %  Check to see the light dark nature of the interval
                                            %  if interval does not include a light-dark transition
                                            dts = find(daybtimes >= btime);
                                            nts = find(nightftimes >= btime);
                                            [nttax, ntind, dytax, dyind] = ...
                                                   swseg(par.taxhr+par.tshift, daybtimes(dts),nightftimes(nts), ldhrs);
                                            dtot = [];
                                            ntot = [];
                                            for kl = 1:length(dyind);
                                                dtot = [dtot; dyind{kl}'];
                                            end
                                            for kl = 1:length(ntind);
                                                ntot = [ntot; ntind{kl}'];
                                            end
                                    %  Loop to plot all channels
                                    allquansd = zeros(par.headerinfo.chan);  %  Dark Initalize arrays to store tail statistics
                                    allquansl = zeros(par.headerinfo.chan);  % Light Initalize arrays to store tail statistics
                                    totintsd = zeros(par.headerinfo.chan);  %  Dark Initalize arrays to store tail statistics
                                    totintsl = zeros(par.headerinfo.chan);  % Light Initalize arrays to store tail statistics
                                    for kpp = 1:par.headerinfo.chan
                                           % All in the day
                                            [freqd, bins, statsl]=histint(sw(dtot,kpp),sampincs,par.threshv(kpp), par.bithresh,par.ignore_interupt);
                                           % All in the night
                                            [freqn, bins, statsd] = histint(sw(ntot,kpp),sampincs,par.threshv(kpp), par.bithresh,par.ignore_interupt);
                                            allquansd(kpp) = 1-statsd.q;
                                            allquansl(kpp) = 1-statsl.q;
                                            totintsd(kpp) = allquansd(kpp)*sum(freqn);
                                            totintsl(kpp) = allquansl(kpp)*sum(freqd);
                                            
                                           % figure
                                           % loglog(bins(pltlimn),freq(pltlimn),'k-','Linewidth',1.5)
                                            lend = length(freqd);
                                           lenn = length(freqn);
                                           %  Ensure Day and Night bin
                                             %  are equal in length
                                             if  lend > lenn  %  extend night with zeros
                                                 freqn(lenn+1:lend) = 0;
                                             elseif lenn > lend  %  extend day with zeros
                                                 freqd(lend+1:lenn) = 0;
                                             end
                                           hfiglast = figure;
                                           bhand = bar([1:length(freqn)]-.5,log2([freqd; freqn]'),'grouped');
                                           set(bhand(1),'FaceColor',[1 1 1]);
                                           set(bhand(2),'FaceColor',[0 0 0]);
                                          % set(gca,'Xtick', [0:length(freqn)-1])
                                           set(gca,'XtickLabel',xticklab)
                                           set(gcf,'Position', fsz);
                                           xlabel('seconds')
                                           ylabel('Log base 2 of Sleep Intervals')
                                           title({[par.fnam(1:end-8) ': Daytime Sleep-Interval Histogram for ' par.idcell{kpp} '. mean= ' num2str(statsl.mean) ', STD = ' num2str(statsl.std) ]; ...
                                                                     ['Nighttime Sleep-Interval Histogram for ' par.idcell{kpp} '. mean= ' num2str(statsd.mean) ', STD = ' num2str(statsd.std) ]}, 'interpreter','none')
                                           legend(leglabs) 
                                           pause(.1)
                                       end                               
                                    end
                                 end
                               end       
                            end
                            warning('on','MATLAB:log:logOfZero')
                       
                      case 'Copy-Figs'  % Option to copy active figure to the clipboard
                            figure(gcf)
                            print(gcf, '-dbitmap')   %  Copy figure to clipboard
		
                      case 'Close-Figs' % Option to close all figure windows
                            close all
                   
                      case 'Export-CSV'  % Option Export to Excel
                            %  prompt user for details on exported data.
                            dtitle ='Export to CSV File';
                            %  Create default string
                            dysstr = [];
                            for kn=1:length(daybtimes)-1
                                dysstr = [dysstr, int2str(kn) ' '];
                            end
                            %  If file does not contain 1 complete day,
                            %  give warning and skip output
                            if isempty(dysstr)
                               wrnout = {'File does not contain one complete day (from light onset to light onset).  No ouput file will be created.'};
                               gh = warndlg(wrnout,'No file created!');
                            else

                                prompt = {'Filename', 'Days to include' };
                                % Defaults
                                defres = {[par.fnam(1:end-7) 'csv'], dysstr};

                                numlns = 1;
                                %  Get user input
                                detail_o = inputdlg(prompt,dtitle,numlns,defres,'on');
                                if ~isempty(detail_o)
                                    dys = str2num(detail_o{2});
                                    dys = round(dys);
                                    dys = sort(dys);

                                    % Check to ensure all days are valid
                                    if sum(dys > 0 & dys  <= length(daybtimes)-1) ~= length(dys)
                                        disp('some requested days are not in range')
                                    end
                                    gg = find(dys > 0 & dys  <= length(daybtimes)-1);
                                    dys = dys(gg);  %  Trim to valid days
                                   %  Find date of first daybreak after experiment
                                   %  begins
                                    %  Get start date of data file
                                    dv = [par.headerinfo.year, par.headerinfo.month, par.headerinfo.date, ...
                                          par.headerinfo.sh, par.headerinfo.sm, par.headerinfo.ss]; 
                                    %  Set start time to first daybreak time
                                    gg = par.ldtimes{1};  
                                    if daybtimes >= 24
                                        %  first daybrake time occurs on next
                                        %  day
                                        dnum = datenum(dv(1:3));
                                        sdate = datevec(dnum+1);
                                    else
                                        %  Same as start date
                                        sdate = datevec(dnum);
                                    end
                                    sdate(4) = str2num(gg(1:2));
                                    sdate(5) = str2num(gg(4:5));
                                    sdate(6) = str2num(gg(7:8));

                                    %  Initalize cell array for output to excel
                                    %  file, ROWS=number of mice, Columns = number
                                    %  of days times number of parameters plus once
                                    %  column for the labels
                                    rws = length(par.idcell);
                                    [nr, nc] = size(sw);

                                    %  set headers appropiate for experiment
                                    hedd1 = {'MOUSE_ID', 'TESTDATE', 'PERCENTSLEEPTOT', 'PERCENTSLEEPNIGHT', 'PERCENTSLEEPDAY', 'BOUTLENGTHTOT', ...
                                             'BOUTLENGTHNITE', 'BOUTLENGTHDAY', 'ACTONSET', 'PEAKACT'};
                                    outexcell = cell([rws+1, length(hedd1) + (length(dys)-1)*(length(hedd1)-2)]);     
                                    %  Insert labels into cell array for excel sheet
                                    outexcell{1,1} = hedd1{1};  % Mouse ID
                                    outexcell{1,2} = hedd1{2};
                                    offsett = length(hedd1(3:end));  % Fields
                                    %  Insert multiple fields
                                    for kkday = 1:length(dys)  % +length(sdday))
                                        for kk=1:offsett
                                            outexcell{1,2+kk+offsett*(kkday-1)} = [hedd1{kk+2} int2str(dys(kkday))];
                                        end
                                    end

                                    %  Assign mouse labels
                                    for krws = 1:rws
                                        outexcell{krws+1,1} = par.idcell{krws};
                                    end
                                    sdaynow = datenum(sdate);
                                    %  Write down date for the start of first
                                    %  full day (starting with light onset)
                                    for krws=1:rws
                                        outexcell{krws+1,2} = datestr(sdaynow,23);
                                    end
                                    %  Compute statistics to fill out table
                                        % Compute wake activity onset values for
                                        % all days and compute mean over specfied
                                        % normal days
                                        h = waitbar(0,'Please wait...');
                                        acton = zeros(1,nc); % Average activity onset time
                                        pkact = zeros(1,nc); % Average peak activity vector
                                        for kslp = 1:nc
                                                [peakact, pak] = wakeactivity(sw(:,kslp),par,par.threshv(kslp),nightftimes, daybtimes,0);
                                                if isempty(pak)
                                                    paka(kslp,:) = NaN;
                                                    pkka(kslp,:) = NaN;
                                                else
                                                paka(kslp,:) = pak';
                                                pkka(kslp,:) = peakact';
                                                waitbar(kslp/(nc+4),h);
                                                acton(kslp) = mean(paka(kslp,dys));
                                                pkact(kslp) = mean(pkka(kslp,dys));
                                                end
                                        end




                                        % Compute average percentage sleep times over
                                        % normal days
                                        tdark = [];  %  index vector for dark times
                                        tlight = [];  %  index vector for light times
                                        tall = [];   %  index vector for all times
                                        sampincs = abs(lintime(2)-lintime(1))*60*60; % Compute sampling increment in seconds for sleep wake detections
                                        dtot = length(dys);
                                        for kkday = 1:dtot
                                            dtmb = daybtimes(dys(kkday));  % Get day of interest begining
                                            dtme = daybtimes(dys(kkday)+1);  % Get day of interest end
                                            nti = find(nightftimes > dtmb );  %  Get associated night times
                                            ntm = nightftimes(nti(1));

                                            ta = find(par.taxhr+par.tshift >= dtmb & par.taxhr+par.tshift < dtme);
                                            td = find(par.taxhr+par.tshift >= ntm & par.taxhr+par.tshift < dtme);
                                            tl = find(par.taxhr+par.tshift >= dtmb & par.taxhr+par.tshift < ntm);

                                            for kslp = 1:nc
                                                slp=find(sw(ta,kslp) >= par.threshv(kslp));  %  Find point associated with the day of interest
                                                pt = 100*length(slp)/length(ta);  %  Percentage of time over 24 hour period
                                                outexcell{kslp+1,3+offsett*(kkday-1)} = pt;
                                                %  Percent sleep in dark average
                                                slp=find(sw(td,kslp) >= par.threshv(kslp));  %  Find point associated with the day of interest
                                                pt = 100*length(slp)/length(td);  %  Percentage of time over 24 hour period
                                                outexcell{kslp+1,4+offsett*(kkday-1)} = pt; 
                                                %  Percent sleep in light
                                                slp=find(sw(tl,kslp) >= par.threshv(kslp));  %  Find point associated with the day of interest
                                                pt = 100*length(slp)/length(tl);  %  Percentage of time over 24 hour period
                                                outexcell{kslp+1,5+offsett*(kkday-1)} =  pt;
                                                %  Average bout length total average

                                                [freq, bins, stats] = histint(sw(ta,kslp),sampincs,par.threshv(kslp), par.bithresh,par.ignore_interupt);
                                                abouts(kslp,kkday)=1-stats.q;
                                                aboutsnum(kslp,kkday) = abouts(kslp,kkday)*sum(freq); 
                                                outexcell{kslp+1,6+offsett*(kkday-1)} = stats.mean;  %  Mean sleep bout length over 24 hour period
                                                %  Average bout length dark average
                                                [freq, bins, stats] = histint(sw(td,kslp),sampincs,par.threshv(kslp), par.bithresh,par.ignore_interupt);
                                                dbouts(kslp,kkday)=1-stats.q;
                                                dboutsnum(kslp,kkday) = dbouts(kslp,kkday)*sum(freq);
                                                outexcell{kslp+1,7+offsett*(kkday-1)} = stats.mean;  %  Mean sleep bout length in light over 24 hour period
                                                %  Average bout lenght light average
                                                [freq, bins, stats] = histint(sw(tl,kslp),sampincs,par.threshv(kslp), par.bithresh,par.ignore_interupt);
                                                lbouts(kslp,kkday)= 1-stats.q;
                                                lboutsnum(kslp,kkday) = lbouts(kslp,kkday)*sum(freq);
                                                outexcell{kslp+1,8+offsett*(kkday-1)} = stats.mean;  %  Mean sleep bout length in dark over 24 hour period
                                                outexcell{kslp+1,9+offsett*(kkday-1)} = paka(kslp,dys(kkday));  % Activity Onset from nightfall
                                                outexcell{kslp+1,10+offsett*(kkday-1)} = pkka(kslp,dys(kkday));  % Peak Activity from nightfall
                                            end
                                            % Build vectors over all normal days
                                            % for averaging
                                            tall = [tall, ta];
                                            tdark = [tdark, td];
                                            tlight = [tlight, tl];
                                            h=waitbar(kslp/dtot,h);

                                        end

                                        textout(detail_o{1}, outexcell)
                                        th = msgbox(['Creating file ' defres], 'Writing to CSV File');
                                        pause(2)
                                        if ishandle(th)
                                          close(th)
                                        end
                                        close(h)
                                end  %  End If from if dialog box empty 
                            end

                      
                      case 'Export-Excel_BoutLengths/hour'
                             th = msgbox([ 'Computing statistics for ' par.fnam(1:end-8)], 'Writing to CSV File');
                             pause(.1)
                             sampincs = abs(lintime(2)-lintime(1))*60*60; % Compute sampling increment in seconds for sleep wake detections
                          %  Get start date of file
                              dv = [par.headerinfo.year, par.headerinfo.month, par.headerinfo.date, ...
                              par.headerinfo.sh, par.headerinfo.sm, par.headerinfo.ss]; 
                              dstr = datestr(datevec(datenum(dv(1:3))));
                              head1 = { dstr, par.idcell{:}} ;
                              [rss,css] = size(sw);  %  Get length of sleep wake stats and number of mice
                          %  Window size in minutes (use only integers)
                              ws = par.CSV_min_interval;   
                              sampindb = 1;  %  Beginging sample index
                              inc = round(60*ws/sampincs);  %  Number of 2 second intervals
                              sampinde = inc;  % Ending Index for window
                              excellout1 = cell(round(rss/inc)+1, css+1);
                              excellout2 = cell(round(rss/inc)+1, css+1);
                              excellout3 = cell(round(rss/inc)+1, css+1);
                              excellout4 = cell(round(rss/inc)+1, css+1);
                              excellout5 = cell(round(rss/inc)+1, css+1);
                              excellout6 = cell(round(rss/inc)+1, css+1);
                              excellout1(1,:) = head1;  % Median
                              excellout2(1,:) = head1;  %  90th percentile
                              excellout3(1,:) = head1;  %  10th percentile
                              excellout4(1,:) = head1;  % mean
                              excellout5(1,:) = head1;  %  std
                              excellout6(1,:) = head1;  %  user defined threshohlded 
                              rwcount = 1;   %  Initalize row counter for output cell arrays (1 row is header)
                              while sampinde < rss   %  Keep going as long as last window fits the data length
                                  rwcount = rwcount+1;  %  Increment row counter for output cell array
                                  spw = sw(sampindb:sampinde, :);  %  Extract chunk of sleep wake statistics for processing
                                  ddd = datestr(datevec(datenum(dv)));  %  Get date vector for time stamp
                                  timestmp = ddd(13:end);   %  Extract time portion
                                  excellout1{rwcount,1} = timestmp;   %  Write time stamp for current numbers
                                  excellout2{rwcount,1} = timestmp;   %  Write time stamp for current numbers
                                  excellout3{rwcount,1} = timestmp;
                                  excellout4{rwcount,1} = timestmp;   %  Write time stamp for current numbers
                                  excellout5{rwcount,1} = timestmp;   %  Write time stamp for current numbers
                                  excellout6{rwcount,1} = timestmp;
                                  %  Loop through each mouse
                                  for kmc = 1:css
                                      [freq, bins, stats] = histint(spw(:,kmc),sampincs,par.threshv(kmc), par.bithresh,par.ignore_interupt);

                                      excellout1{rwcount,1+kmc} = stats.median;  % Median sleep bout in seconds
                                      excellout2{rwcount,1+kmc} = stats.pct90;
                                      excellout3{rwcount,1+kmc} = stats.pct10;
                                      excellout4{rwcount,1+kmc} = stats.mean;
                                      excellout5{rwcount,1+kmc} = stats.std;
                                      excellout6{rwcount,1+kmc} = stats.q;
                                  end
                                  sampindb = sampinde+1;  %  Increment to begining point of next segment
                                  sampinde=sampindb+inc-1;   % Increment to ending point of next segment
                                  dv(5) = dv(5)+ws;  %  Increment time stamp with minutes
                              end
                              if ishandle(th)
                                  close(th)
                              end
                              pause(.1)
                              %  Window to indicate saving file
                              th = msgbox([ 'Saving ' par.fnam(1:end-8) '_MedianSB.csv'], 'Writing to CSV File');
                              pause(1)
                              textout([par.fnam(1:end-8) '_MedianSB.csv'], excellout1);
                              if ishandle(th)
                                  close(th)
                              end
                              %xlswrite([par.fnam(1:end-8) '_MedianSB.xls'], excellout1)

                              %  Window to indicate saving file
                              th = msgbox([ 'Saving ' par.fnam(1:end-8) '_90pctileSB.csv'], 'Writing to CSV File');
                              pause(1)
                              textout([par.fnam(1:end-8) '_90pctileSB.csv'], excellout2);
                              if ishandle(th)
                                  close(th)
                              end

                              %xlswrite([par.fnam(1:end-8) '90pctileSB.xls'], excellout2)
                              th = msgbox([ 'Saving ' par.fnam(1:end-8) '_10pctileSB.csv'], 'Writing to CSV File');
                              pause(1)
                              textout([par.fnam(1:end-8) '_10pctileSB.csv'], excellout3);
                              %xlswrite([par.fnam(1:end-8) '_10pctileSB.xls'], excellout3)
                              if ishandle(th)
                                  close(th)
                              end

                              th = msgbox([ 'Saving ' par.fnam(1:end-8) '_MeanSB.csv'], 'Writing to CSV File');
                              pause(1)
                              textout([par.fnam(1:end-8) '_MeanSB.csv'], excellout4);
                              %xlswrite([par.fnam(1:end-8) '_MeanSB.xls'], excellout4)
                              if ishandle(th)
                                  close(th)
                              end

                              th = msgbox([ 'Saving ' par.fnam(1:end-8) '_StdSB.csv'], 'Writing to CSV File');
                              pause(1)
                              textout([par.fnam(1:end-8) '_StdSB.csv'], excellout5);
                              %xlswrite([par.fnam(1:end-8) '_StdSB.xls'], excellout5)
                              if ishandle(th)
                                  close(th)
                              end

                              th = msgbox([ 'Saving ' par.fnam(1:end-8) '_QthSB.csv'], 'Writing to CSV File');
                              pause(1)
                              textout([par.fnam(1:end-8) '_QthSB.csv'], excellout6);
                              %xlswrite([par.fnam(1:end-8) '_QthSB.xls'], excellout6)
                              if ishandle(th)
                                  close(th)
                              end
                      
                      case 'Export-Excel_SleepPercent/min'
                              sampincs = abs(lintime(2)-lintime(1))*60*60; % Compute sampling increment in seconds for sleep wake detections
                              %  Get start date of file
                                  dv = [par.headerinfo.year, par.headerinfo.month, par.headerinfo.date, ...
                                  par.headerinfo.sh, par.headerinfo.sm, par.headerinfo.ss]; 
                              dstr = datestr(datevec(datenum(dv(1:3))));
                              head1 = { dstr, par.idcell{:}} ;
                              [rss,css] = size(sw);  %  Get length of sleep wake stats and number of mice
                              %  Window size in minutes (use only integers)
                              ws = par.CSV_min_interval;   
                              sampindb = 1;  %  Beginging sample index
                              inc = round(60*ws/sampincs);  %  Number of 2 second intervals
                              sampinde = inc;  % Ending Index for window
                              excellout = cell(round(rss/inc)+1, css+1);
                              excellout(1,:) = head1;
                              rwcount = 1;   %  Initalize row counter for output cell arrays (1 row is header)
                              while sampinde < rss   %  Keep going as long as last window fits the data length
                                  rwcount = rwcount+1;  %  Increment row counter for output cell array
                                  spw = sw(sampindb:sampinde, :);  %  Extract chunk of sleep wake statistics for processing
                                  ddd = datestr(datevec(datenum(dv)));  %  Get date vector for time stamp
                                  timestmp = ddd(13:end);   %  Extract time portion
                                  excellout{rwcount,1} = timestmp;   %  Write time stamp for current numbers
                                  %  Loop through each mouse
                                  for kmc = 1:css
                                      slpperint = length(find(spw(:,kmc)>par.threshv(kmc)))/inc;
                                      excellout{rwcount,1+kmc} = slpperint;
                                  end
                                  sampindb = sampinde+1;  %  Increment to begining point of next segment
                                  sampinde=sampindb+inc-1;   % Increment to ending point of next segment
                                  dv(5) = dv(5)+ws;  %  Increment time stamp with minutes
                              end
                              th = msgbox([ 'Saving ' par.fnam(1:end-8) 'slppcnt.csv'], 'Writing to CSV File');
                              pause(1)

                              textout([par.fnam(1:end-8) 'slppcnt.csv'], excellout);
                              %xlswrite([par.fnam(1:end-8) 'slppcnt.xls'], excellout)
                              if ishandle(th)
                                  close(th)
                              end                         
                                    
                            
                  end  %  Ends SWITCH-CASE statement                
              end    %  IF end to all the plot options
           end  %  If for toggling auto paste option
        end   %  %  Plot option while loop
    end   %  If opened file
    %  Clear old fields
    if exist('par','var')
       clear par
    end
end  %   Open file / Quit While loop
     

function lightdarklines(fno,dbt,nft)
%  This function will draw vertical line on plot in figure FNO
%  with cyan lines at time points in vector DBT and black line
%  at time points in vector NFT
%
%    lightdarklines(fno,dbt,nft)
%
%  written by Kevin D. Donohue (donohue@engr.uky.edu) August 11, 2006

figure(fno)
yh = get(gca,'Ylim');  %  get height of plot
hold on  %  Hold current graphic to superimpose
%  Insert daybreak/nightfall markers
for klines = 1:length(dbt)
    plot(dbt(klines)*ones(1,2), yh, 'c--', 'LineWidth',2)
end
for klines = 1:length(nft)
    plot(nft(klines)*ones(1,2), yh, 'k--', 'LineWidth',2)
end
hold off

function timemarkers = cyctimes(mtime,lintime,modcyc)
%  This function finds the values on linear time scale LINTIME that 
%  correspond to marker time MTIME, where LINTIME is an unwrapped
%  version of a cyclic time with a mod number of MODCYC
%  
%       timemarkers = cyctimes(mtime,lintime,modcyc)
%  
%  where output TIMEMARKERS is a vector of unwraped time values from
%  cyclic time of mod MODCYC to the the linear time vector LINTIME
%
%    Written by Kevin D. Donohue (donohue@engr.uky.edu) August 11


% Compute sampling increment to round off light-dark marker times to closes points time points on axis
sampinc = 2*abs(lintime(2)-lintime(1)); 
cirtime = mod(lintime, modcyc);  % convert to mod 24, circular time
lddist = abs(mtime - cirtime);  %  Compute distances from the daybreak times to mod 24 hr times
itimes = find(lddist < sampinc); %   Find all points within one sampling increment of daybreak times
%  If points on axis found
if ~isempty(itimes)
%  Remove consective points, if more than one axis point was
%  found in interval
rmk = 0;  %  Initialize counter for non-consecutive points
rmi = []; %  Initalize Array for saving non-consecutive points  
k=1;  
while k <= length(itimes)-1
   if itimes(k+1)-itimes(k) > 1
       rmk=rmk+1;
       rmi(rmk) = k;
   end
   k=k+1;
end
rmk = rmk+1;
rmi(rmk) = k;
itimes = itimes(rmi);  %  Trim array to only those points that are nonconsective
end
timemarkers = lintime(itimes);
