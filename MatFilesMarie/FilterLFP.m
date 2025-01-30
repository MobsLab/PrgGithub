function  [EEGf,fif]=FilterLFP(EEG,freq,fi)


% Filtering Local Field Potential
% [EEGf,fif]=FilterLFP(EEG,freq,fi)
% INPUTS:
% EEG: Local field potential to be filtered
% freq: Bandpass use to filter the data (must be: [L H], with L and H frequencies used by the filter)
% fi: optional, designs an fi'th order lowpass, see "help fir1" for details, defauft
% value 96
% 
% OUTPUTS:
% EEGf: filtered LFP
% 
% copyright (c) 2009 Karim Benchenane
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html


try
    fi;
catch
    fi=96;
end

  try

      okk=0;
      
      for i=1:10
          if okk==0
                  try
                        Fn=1/(median(diff(Range(EEG,'s'))));
                        b = fir1(fi/i,freq*2/Fn);
                        % b = butter(fi,freq*2/Fn);

                        dEeg = filtfilt(b,1,Data(EEG));
                        rg = Range(EEG);

                        if length(rg) ~= length(dEeg)
                            %keyboard; commented by Gdelavilleon for MMN analysis (05/11/2014)
                        end

                        EEGf = tsd(rg,dEeg);
                        fif=fi/i;
                        okk=1;
                  end
          
          end
          
      end
      
      if okk==0;
          grrr;
      end
      
catch
    
   for i=1:length(EEG)


            Fn=1/(median(diff(Range(EEG{i},'s'))));

            b = fir1(fi,freq*2/Fn);

            %b = butter(fi,freq*2/Fn);

            dEeg = filtfilt(b,1,Data(EEG{i}));
            rg = Range(EEG{i});

            if length(rg) ~= length(dEeg)
                keyboard;
            end

            EEGf{i} = tsd(rg,dEeg);




       
   end
   
    EEGf=tsdArray(EEGf);
    
    
end

