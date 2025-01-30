function FigArrow(Pos,Kappa,Mu,scal)


try 
    scal;
catch
    scal=max(Kappa);
end

% Mu=Mu-pi;
% Mu=Mu*360/2/pi;

Kappa=Kappa/scal;

for i=1:size(Pos,1)
hold on

% added by SB, arrow is no longer compatibl with certain versions of Matlab
try
    arrow([Pos(i,1) Pos(i,2)],[Pos(i,1)+Kappa(i)*cos(Mu(i)) Pos(i,2)+Kappa(i)*sin(Mu(i))],'length',5)
catch
    arrow_update([Pos(i,1) Pos(i,2)],[Pos(i,1)+Kappa(i)*cos(Mu(i)) Pos(i,2)+Kappa(i)*sin(Mu(i))],'length',5)
end
end