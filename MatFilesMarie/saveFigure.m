function saveFigure(n,title,Dossier)

% Save figure in png format and eps format (vectorial)
% 
% INPUTS:
% n: number of the fingure window to be saved
% title: name of the file in wich the figure will be saved 
% Dossier: File in wich the figure will be saved
% 
% 
% copyright (c) 2009 Karim Benchenane
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html


res=pwd;

try 
    Dossier;
    
eval(['cd(''',Dossier,''')'])


set(n,'paperPositionMode','auto')

eval(['print -f',num2str(n),' -dpng ',title,'.png'])

%eval(['print -f',num2str(n),' -painters',' -depsc2 ',title,'.eps'])
eval(['print -f',num2str(n),' -depsc2 ',title,'.eps'])

eval(['cd(''',res,''')'])


catch
    
set(n,'paperPositionMode','auto')

eval(['print -f',num2str(n),' -dpng ',title,'.png'])

%eval(['print -f',num2str(n),' -painters',' -depsc2 ',title,'.eps'])
eval(['print -f',num2str(n),' -depsc2 ',title,'.eps'])
    
    
end