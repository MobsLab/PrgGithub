function FigArrow(Pos,Kappa,Mu,scal)


try
    scal;
catch
    scal=1;
end

% Mu=Mu-pi;
% Mu=Mu*360/2/pi;

Kappa=Kappa/scal;

for i=1:size(Pos,1)
    hold on
    % if added by SB Jan 2017 to correct for changes in matlab version
    if not(isempty(strfind(version,'2016')))
        arrowNew([Pos(i,1) Pos(i,2)],[Pos(i,1)+Kappa(i)*cos(Mu(i)) Pos(i,2)+Kappa(i)*sin(Mu(i))],'length',5)
    else
        arrow([Pos(i,1) Pos(i,2)],[Pos(i,1)+Kappa(i)*cos(Mu(i)) Pos(i,2)+Kappa(i)*sin(Mu(i))],'length',5)
    end
end