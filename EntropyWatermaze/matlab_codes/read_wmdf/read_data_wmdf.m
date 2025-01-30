% This is a revised matlab program that we received its original version
% from David ... who made the ACTIMETRIC software 
function [p_xy]=read_data_wmdf(N_animal,t_end);

        p_xy=[]; %positions (x,y)
        cum_d=[];
        for j=1:N_animal
          count=j
          [fname, pname] = uigetfile('*.wmdf');
          fid = fopen([pname, fname]);
          fseek(fid, 0, 'eof');
          file_size = ftell(fid);
          data = [];
          fseek(fid, 0, 'bof');
          trial_start = 4; % where the first trial starts data
          for i = 1:100
            fseek(fid, trial_start, 'bof');
            trial_size     = fread(fid,1,'uint32', 0, 'ieee-be'); %number of bytes in the record for a trial
            
            if trial_size > 0 
              
              n_elements      = fread(fid,1,'uint32', 0, 'ieee-be'); %number of elements in a trial (always 25)
              a               = fseek(fid,12, 'cof');                  %skip the first element (not interesting)
              
              element_size    = fread(fid,1, 'uint32', 0, 'ieee-be');%size of the next element in bytes (tracking data!)
              array_size      = fread(fid,2, 'uint32', 0, 'ieee-be');%size of the tracking data array. Always 3 x N
              n_val           = array_size(1) * array_size(2);
              raw             = fread(fid,n_val,'float32', 0, 'ieee-be'); %The data
              data{i}         = reshape(raw, array_size(2), array_size(1));
            end
            
            trial_start = trial_start + trial_size + 4;
          end
          p_xy{j}=data{1}; 
          [dim_t dim_s]=size(data{1});
          if dim_t<t_end
            fprintf('The total time steps for mouse %d is less than %d\n',j,t_end)
          end
        end
        

