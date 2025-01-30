function monte_carlo_ens_val=TirageFromDistrib(h1Permut,b1,nbSample,plo)


try
    plo;
catch
    plo=0;
end

%nbSample=4;

n=h1Permut;
f_repart = cumsum(h1Permut)/sum(h1Permut);
x_out=b1;
[b, m, nb] = unique(f_repart); % on repère les doublons

if plo
    figure('color',[1 1 1]), 
    subplot(1,2,1),hold on
    plot(b1,h1Permut/max(h1Permut),'k','linewidth',2)
    subplot(1,2,2),hold on
    plot(x_out,f_repart,'k','linewidth',2) % *max(n) =>  meme echelle à l'affichage
end

monte_carlo_f_repart = rand(nbSample,1);
% monte_carlo_ens_val = interp1(f_repart(m),x_out(m),monte_carlo_f_repart,'nearest');
% monte_carlo_ens_val=monte_carlo_ens_val+(-1)^randn(1,1)*randn(1,1)*monte_carlo_ens_val/10;

uniformDraw=rand(nbSample,1);
[val idmax]=arrayfun(@(x) max(f_repart>x), uniformDraw);
monte_carlo_ens_val=x_out(idmax);

monte_carlo_ens_val=monte_carlo_ens_val+(-1)^randn(1,1)*randn(1,1)*monte_carlo_ens_val/10;


[h,b]=hist(monte_carlo_ens_val,b1);


if plo

subplot(1,2,1),hold on
plot(b,h/max(h),'r')

subplot(1,2,2),hold on
plot(b,cumsum(h)/sum(h),'r')

end
