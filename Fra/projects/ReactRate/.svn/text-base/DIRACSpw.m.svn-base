function AO = DIRACSpw(A)
  
  
  A = registerResource(A, 'SPW_s1', 'cell', {1, 1}, ...
		       'spw_s1', ['intervalSet containing ALL the sharp' ...
		    ' waves before maze']);
  
  A = registerResource(A, 'SPW_M_s1', 'tsdArray', {1, 1}, ...
		       'M_s1', ['tsdArray containing ALL the sharp' ...
		    ' waves peaks before maze']);
  A = registerResource(A, 'SPW_s2', 'cell', {1, 1}, ...
		       'spw_s2', ['intervalSet containing ALL the sharp' ...
		    ' waves after maze']);
  
  A = registerResource(A, 'SPW_M_s2', 'tsdArray', {1, 1}, ...
		       'M_s2', ['tsdArray containing ALL the sharp' ...
		    ' waves peaks after maze']);
  
  A = registerResource(A, 'SessionType', 'cell', {1, 1}, ...
		       'sessionType', ['string that can be BD1 for the' ...
		    ' first track in a session, BD2 for the second' ...
		     ' one']);
  
  
   % compute spw times   
   
   if ~exist([current_dir(A) filesep 'SPWtimes.mat'], 'file') 
     CRfile = List2Cell([current_dir(A) filesep 'ripples_EEG.txt']);
     CRfile = CRfile{1};
     try
       CR = ReadCR_tsd([current_dir(A) filesep CRfile]);
     catch 
       CR = tsd(zeros(0,1), zeros(0,1));
     end
     
     load([current_dir(A) filesep 'DIRACPosFile0627.mat'], 'epoch_start', 'epoch_end');
     
     BD = List2Cell([current_dir(A) filesep 'task_phase.txt']);
     sessionType = BD;
     
     
     if strcmp(BD{1}, 'BD1') % in first track in session
       start_sleep1 = 0;
       end_sleep1 = epoch_start;
       start_sleep2 = epoch_end;
       end_sleep2 = 1e20;
     elseif strcmp(BD{1}, 'BD2') % in second track in session
       start_sleep1 = 0;
       end_sleep1 = 1000;
       start_sleep2 = epoch_end;
       end_sleep2 = 1e20;
     else
       error('unrecognized task phase')
     end
     
     
     CR_s1 = Restrict(CR, start_sleep1, end_sleep1);
     CR_s2 = Restrict(CR, start_sleep2, end_sleep2);
     clear CR;  
     
     CR_ripples_s1 = Filter_200hz(CR_s1);
     CR_ripples_s2 = Filter_200hz(CR_s2);  
     
     clear CR_s1 CR_s2
     
     
     UpThresh = 140;
     DownThresh = 40;
     did_spw = 0;
     while 1
       
       
       figure(5), clf
       PlotEEG(CR_ripples_s2);
       hold on 
       if did_spw
 	plot(Data(S_s2)/10000, zeros(size(Data(S_s2))), 'g.');
 	plot(Data(E_s2)/10000, zeros(size(Data(E_s2))), 'r.');
       end
       display(['UpThresh = ' num2str(UpThresh)]);
       display(['DownThresh = ' num2str(DownThresh)]);    
       
       r = input('UpThresh = ');
       UpThresh = r;
       if r == 0
 	break
       end
       r = input('DownThresh = ');    
       DownThresh = r;
       
       if ~isempty(Range(CR_ripples_s1))
	 [S_s1, E_s1, M_s1] = findRipples(CR_ripples_s1, UpThresh, ...
					  DownThresh);
       else
	 S_s1 = ts([]);
	 E_s1 = ts([]);
	 M_s1 = ts([]);
       end
       
       
       [S_s2, E_s2, M_s2] = findRipples(CR_ripples_s2, UpThresh, DownThresh);
       did_spw = 1;
     end
     if ~isa(S_s1, 'ts')
       S_s1 = ts(S_s1.t);
       E_s1 = ts(E_s1.t);
       M_s1 = ts(M_s1.t);
     end
     
     if ~isa(S_s2, 'ts')
       S_s2 = ts(S_s2.t);
       E_s2 = ts(E_s2.t);
       M_s2 = ts(M_s2.t);
     end

     save([current_dir(A) filesep 'SPWtimes'], 'S_s*',  'E_s*',  'M_s*');
     
   else
     load([current_dir(A) filesep 'SPWtimes']);
     if ~isa(S_s1, 'ts')
       if isa(S_s1.t, 'ts')
	 S_s1 = ts(Range(S_s1.t));
	 E_s1 = ts(Range(E_s1.t));
	 M_s1 = ts(Range(M_s1.t));
       else
	 S_s1 = ts(S_s1.t);
	 E_s1 = ts(E_s1.t);
	 M_s1 = ts(M_s1.t);
       end
     end
     
     if ~isa(S_s2, 'ts')
       if isa(S_s2.t, 'ts')
	 S_s2 = ts(Range(S_s2.t));
	 E_s2 = ts(Range(E_s2.t));
	 M_s2 = ts(Range(M_s2.t));
       else
	 S_s2 = ts(S_s2.t);
	 E_s2 = ts(E_s2.t);
	 M_s2 = ts(M_s2.t);
       end

     end
     
     BD = List2Cell([current_dir(A) filesep 'task_phase.txt']);
     sessionType = BD;

   end
  
  
   

  

    spw_s1 = intervalSet(Range(S_s1), Range(E_s1));
    spw_s2 = intervalSet(Range(S_s2), Range(E_s2));    
    
  

  spw_s1 = { spw_s1 };
  M_s1 = tsdArray({ M_s1 });

  spw_s2 = { spw_s2 };  
  M_s2 = tsdArray({ M_s2 });  

  A = saveAllResources(A);
    
  AO = A;
  
  
  