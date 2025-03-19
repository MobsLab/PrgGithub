

zones = [1, 2, 3, 4];

zone_init = zones(1);
zone_dur = 30;
zone_max = 60;

enroulement = 0;


a = 1;

% Trajet de la souris

% sq_dist1 = (PosMat(end-1,2)-PosMat(end-2,2))^2+(PosMat(end-1,3)-PosMat(end-2,3)^2;
% sq_dist2 = (PosMat(end-2,2)-PostMat(end,3))^2+(PosMat(end-2,3)-PostMat(end,3))^2;
% sq_dist3 = (PostMat(end,2)-PosMat(end-1,2))^2+(PostMat(end,3)-PosMat(end-1,3))^2;
% gamma = acos((sq_dist1 + sq_dist2 - sq_dist3)/2*sqrt(sq_dist1)*sqrt(sq_dist2));

vect2 = [PosMat(end,2)-PosMat(end-1,2),PosMat(end,3)-PosMat(end-1,3)];
vect1 = [PosMat(end-1,2)-PosMat(end-2,2),PosMat(end-1,3),PosMat(end-2,3)];

gamma = acos(dot(vect1,vect2)/(norm(vect1)*norm(vect2)))



% Decides to give a shock or not
if and(y(3)>a*x, y(3)>0)
    shock = 1;
else
    shock = 0;
end

% Decides to change rotation

    % Determmines zone
if and(x(3)>0,y(3)>0)
    zone = zones(1);
elseif and(x(3)>0,y(3)<0)
    zone = zones(2);
elseif and(x(3)<0,y(3)>0)
    zone = zones(3);
else
    zone = zones(4);
end

    % Changer sens?
    
delay = PosMat(end,1)-PosMat(end-1,1);
if zone == zone_init
    zone_dur = zone_dur + delay;
else
    zone_init = zone;
    zone_dur = 0;
end
if zone_dur>zone_max
    rotation = 1;
end


% empeche la souris de s enrouler
enroulement = enroulement + gamma;
