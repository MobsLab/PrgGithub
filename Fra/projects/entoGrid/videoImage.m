clear M
np= 1  
tInit = 10010/monitorStep;
            %tEnd = nSteps/monitorStep;
            tEnd = 15000/monitorStep;
            nConf = size(Vtot, 1);
            side  = sqrt(nConf);
            for i = tInit:2:tEnd
                vv = (Vconf(:,i))';
                vvk = repmat(vv, nConf,1);
                acPack = sum(Vtot .* vvk, 2);
                acPack = reshape(acPack, 50, 50);
                imagesc(acPack)
                caxis([cmin, cmax])
                hold on 
                text(20, 25, num2str(i));
                hold off 
                pause(0);
                M(np) = getframe;
                np = np+1;
            end