
matrixname={'C','P','E'};

for i=1:3
    for k=0:3
        disp(['M' num2str(k) '=' matrixname{i}  num2str(k) ]);
        eval(['M' num2str(k) '=' matrixname{i} num2str(k) ]);
    end
    keyboard;
    
end