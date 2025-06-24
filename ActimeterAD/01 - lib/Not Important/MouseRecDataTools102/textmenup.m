function pchannum = textmenup(idcell)
%  This function presents a text menu for the user to make a
%  selection among as many choices as in input cell array IDCELL
%
%    pchannum = textmenup(idcell)
%
%  Ouput PCHANNUM is an integer from 0 to length of IDCELL + 1
%  If PCHANNUM = 0, then input choice operaion was canceled
%  If PCHANNUM is between 0 and length of IDCELL + 1 then a 
%  choice was made and PCHANNUM is the index of that choice
%  If PCHANNUM is length of IDCELL + 1, then no match was found
%
%   Written by Kevin D. Donohue (kevin.donohue@sigsoln.com) June 2011


%  Assign default channel to plot for display prompt 
pchan = idcell(1); 
%  Set up user prompt
chcprompt =[];
% Concatenate strings into prompt
for kcp =1:length(idcell)-1
%   pstr{kcp} = [par.idcell{kcp}];
   chcprompt = [chcprompt, idcell{kcp}, ', '];
end
kcp = kcp+1;
chcprompt = [chcprompt, idcell{kcp}];
chcprompt = ['Channel Choices (' chcprompt ')'];  %  Window title
dtitle = ['Choose ' idcell{1} ' to ' idcell{end} ];  % Info prompt
numlns = 1;
%  Get data
dumcell = inputdlg(chcprompt,dtitle,numlns,pchan,'on');
%  If window not canceled, process data
if ~isempty(dumcell)
   pchannum = length(idcell) + 1;  % initalize selected channel out of range
   %  Step through all labels and find a match
   for kc=1:length(idcell)
       % If string lenghts match, check for
       % character matches
       if length(idcell{kc}) == length(dumcell{1})
           matchs  = (idcell{kc} == dumcell{1});
           %  Check for character match
           if sum(matchs) == length(dumcell{1});
               pchannum = kc;  %  If match, make index assignment
           end
       end
   end
else
   %  Termination of menu (operation canceled 
   pchannum = 0;  %  set output index to 0
end
