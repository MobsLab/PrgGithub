function saveFigure(n,title,Dossier)

% Save figure in png, svg, fig and eps format (vectorial)
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

% pour sauver les figure en png et en epx
% utilisation saveFigure(n,title,Dossier)
% n : le numero de la figure que tu veux sauver
% title : le nom que tu veux donner a la figure
% Dossier : le dossier dans lequel tu veux sauver la figure
% ex: saveFigure(3,'FigureTitle','/Path/To/Save/Figure')

res=pwd;


set(n,'paperPositionMode','auto')

try
    eval(['print -f',num2str(n),' -dpng ', Dossier filesep title,'.png'])
    try, saveas(n,[Dossier filesep title '.fig']), end
    print(n, [Dossier filesep title], '-dsvg');
    eval(['print -f',num2str(n),' -painters',' -depsc2 ',Dossier filesep title,'.eps'])
catch
%     try was added to accomodate new Matlab version - SB
    try
        eval(['print -f',num2str(n.Number),' -dpng ', Dossier filesep title,'.png'])
        saveas(n,[Dossier filesep title '.fig'])
        saveas(n,[Dossier filesep title '.svg'])
        eval(['print -f',num2str(n.Number),' -painters',' -depsc2 ',Dossier filesep title,'.eps'])
    catch
        disp('ERROR')
    end
end

end
