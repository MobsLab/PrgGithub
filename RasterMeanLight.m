function RasterMeanLight(date, essaiDeb,essaiFin)


cd /media/usbdisk/Data




date=num2str(date);


if date(1:2)=='18'
    fichierDateL=num2str(['Rat18/',date]);
    else if date(1:2)=='12'
        fichierDateL=num2str(['Rat12/',date]);
        else if date(1:2)=='19'
            fichierDateL=num2str(['Rat19/',date]);
            else if date(1:2)=='20'
                fichierDateL=num2str(['Rat20/',date]);
                else if date(1:2)=='15'
                    fichierDateL=num2str(['Rat15/',date]);
                    end
                end
            end
        end
end

chopeMoi('LightTime','LightOn',fichierDateL)



if date(1:2)=='18'
    fichierDate=num2str(['/media/usbdisk/Data/Rat18/',date]);
    else if date(1:2)=='12'
        fichierDate=num2str(['/media/usbdisk/Data/Rat12/',date]);
        else if date(1:2)=='19'
            fichierDate=num2str(['/media/usbdisk/Data/Rat19/',date]);
            else if date(1:2)=='20'
                fichierDate=num2str(['/media/usbdisk/Data/Rat20/',date]);
                else if date(1:2)=='15'
                    fichierDate=num2str(['/media/usbdisk/Data/Rat15/',date]);
                    end
                end
            end
        end
end

                  

            
cd (fichierDate)

load CoherenceData
load behavResources

li=Range(LightOn);
st=Range(startTrial{1});
%st=st(2:end-1);
to=Range(trialOutcome{1});
%to=to(2:end-1);

if essaiFin>length(st)
  figure,  [fh1, rasterAx1, histAx1] = ImagePETH(CoherenceTsd, ts(li(essaiDeb:end-1)), -50000, 100000, ...
		'Markers', {ts(st(essaiDeb:end-1))} , 'MarkerTypes', {'k.' }, 'MarkerSize', 20, 'BinSize', 200); title(num2str(['RasterMean Light On ',date,' ', num2str(essaiDeb),' a ','Fin']));

%figure,  [fh1, rasterAx1, histAx1] = ImagePETH(CoherenceTsd, ts(to(essaiDeb:end-1)), -50000, 100000, ...
		%'Markers', {ts(st(essaiDeb:end-1))} , 'MarkerTypes', {'k.' }, 'MarkerSize', 20, 'BinSize', 200); title(num2str(['RasterMean TrialOutcome ',date,' ', num2str(essaiDeb),' a ','Fin']));

 saveas(gcf, num2str(num2str(['RasterMean_LightOn_',date,'_', num2str(essaiDeb),'_a_',num2str(essaiFin),'.jpg'])))
else
 figure,   
[fh1, rasterAx1, histAx1] = ImagePETH(CoherenceTsd, ts(li(essaiDeb:essaiFin)), -50000, 100000, ...
		'Markers', {ts(st(essaiDeb:essaiFin))} , 'MarkerTypes', {'k.' }, 'MarkerSize', 20, 'BinSize', 200); title(num2str(['RasterMean Light On ',date,' ', num2str(essaiDeb),' a ',num2str(essaiFin)]));

 saveas(gcf, num2str(num2str(['RasterMean_LightOn_',date,'_', num2str(essaiDeb),'_a_',num2str(essaiFin),'.jpg'])))
        
 %   figure,
  %      [fh1, rasterAx1, histAx1] = ImagePETH(CoherenceTsd, ts(to(essaiDeb:essaiFin)), -50000, 100000, ...
	%	'Markers', {ts(st(essaiDeb:essaiFin))} , 'MarkerTypes', {'k.' }, 'MarkerSize', 20, 'BinSize', 200); title(num2str(['RasterMean TrialOutcome ',date,' ', num2str(essaiDeb),' a ',num2str(essaiFin)]));
end

end
