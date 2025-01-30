function saveFigure(n,title,Dossier)

% pour sauver les figure en png et en epx 
% utilisation saveFigure(n,title,Dossier)
% n : le numero de la figure que tu veux sauver
% title : le nom que tu veux donner a la figure
% Dossier : le dossier dans lequel tu veux sauver la figure
% ex: saveFigure(3,'FigureTitle','/Path/To/Save/Figure')

res=pwd;

% eval(['cd ',Dossier])
cd(Dossier)

set(n,'paperPositionMode','auto')

% try was added to accomodate new Matlba version - SB
try
    eval(['print -f',num2str(n),' -dpng ',title,'.png'])

    eval(['print -f',num2str(n),' -painters',' -depsc2 ',title,'.eps'])

    eval(['print -f',num2str(n),' -painters',' -depsc2 ',title,'.fig'])

catch
    eval(['print -f',num2str(n.Number),' -dpng ',title,'.png'])

    eval(['print -f',num2str(n.Number),' -painters',' -depsc2 ',title,'.eps'])

    eval(['print -f',num2str(n.Number),' -painters',' -depsc2 ',title,'.fig'])
end

% eval(['cd ' res])
cd(res)

end