%% 
function [moyenne,sigma,amp] = Rythm_Detection_Rudy_BM(SP,f,t,nb)

if nb==0
    moyenne = zeros(length(t),10);
    sigma = zeros(length(t),10);
    amp = zeros(length(t),10);
else
    moyenne = zeros(length(t),nb);
    sigma = zeros(length(t),nb);
    amp = zeros(length(t),nb);
end
SP = SP.*f;
SP = SP-min(SP')';
for i=1:length(t)
    [moyenne(i,:),sigma(i,:),amp(i,:)] = detecte_gauss(f,SP(i,:),nb);
    for j=1:length(amp(i,amp(i,:)>0))
        amp(i,j) = amp(i,j)./moyenne(i,j);
    end
end

end
%%

function [ydata] = calcul_gauss(xdata,moyenne,sigma,amp)

ydata = amp./max(exp(-0.5*((xdata-moyenne)./sigma).^2)./(sigma*sqrt(2*pi))).*(exp(-0.5*((xdata-moyenne)./sigma).^2)./(sigma*sqrt(2*pi)));

end


function [moyenne,sigma,amp] = detecte_gauss(xdata,ydata,nb)
if nb ~=0
    moyenne = zeros(nb,1);
    sigma = zeros(nb,1);
    amp = zeros(nb,1);
else
    seuil = mean(ydata(find(xdata>2)))+ std(ydata(find(xdata>2)))*2 ; % Methode des 3 sigma (2 ~= 95%)
    nb = 10;
    moyenne = zeros(nb,1);
    sigma = zeros(nb,1);
    amp = zeros(nb,1);
end
for j=1:nb
    if j~=1 % retirer la Gaussian_curve precedente de ydata
        ydata = ydata - Gaussian_curve;
    end
    if nb==10
        if max(ydata)<seuil
            break % si ydata<seuil plus de pics
        end
        if max(ydata)==0
            break % si ydata<seuil plus de pics
        end
    end
    [amp(j),moy_point] = max(ydata);%amplitide de la Gaussian_curve
    ydata(ydata<0)=0; % pour eviter le double comptage
    ydata(end) = 0;
    ydata(1) = 0;
    moyenne(j) = xdata(moy_point);
    sigma(j) =0.1;
    Gaussian_curve = calcul_gauss(xdata,moyenne(j),sigma(j),amp(j));
    point_inf = find(ydata(1:moy_point)<(amp(j)*2/3));
    point_inff =point_inf(end);
    point_sup = moy_point+find(ydata(moy_point:end)<amp(j)*2/3,1);
    point = min([point_inff,point_sup]);
    while Gaussian_curve(point)<ydata(point)
        sigma(j) =1+sigma(j);
        Gaussian_curve = calcul_gauss(xdata,moyenne(j),sigma(j),amp(j));
    end
    while Gaussian_curve(point)>ydata(point)
        sigma(j) =sigma(j)-0.1;
        Gaussian_curve = calcul_gauss(xdata,moyenne(j),sigma(j),amp(j));
    end
    while Gaussian_curve(point)<ydata(point)
        sigma(j) =sigma(j)+0.01;
        Gaussian_curve = calcul_gauss(xdata,moyenne(j),sigma(j),amp(j));
    end
    while Gaussian_curve(point)>ydata(point)
        sigma(j) =sigma(j)-0.001;
        Gaussian_curve = calcul_gauss(xdata,moyenne(j),sigma(j),amp(j));
    end
    if sigma(j)==0
        sigma(j) = 0.1;
        Gaussian_curve = calcul_gauss(xdata,moyenne(j),sigma(j),amp(j));
    end
end

end











