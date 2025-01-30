function saveFigure(n,title,Dossier)

% pour sauver les figure en png et en epx 
% utilisation saveFigure(n,title,Dossier)
% n : le numero de la figure que tu veux sauver
% title : le nom que tu veux donner a la figure
% Dossier : le dossier dans lequel tu veux sauver la figure


res=pwd;

eval(['cd ',Dossier])


set(n,'paperPositionMode','auto')

eval(['print -f',num2str(n),' -dpng ',title,'.png'])

eval(['print -f',num2str(n),' -painters',' -depsc2 ',title,'.eps'])

eval(['cd ' res])