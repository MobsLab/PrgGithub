


function ValueOfDate=DateValue_BM(Dir)
 
for mouse = 1:length(Dir.path)
    try
        Date(mouse)=Dir.ExpeInfo{1, mouse}{1, 1}.date  ;
    catch
        Date(mouse)=str2num(Dir.ExpeInfo{1, mouse}{1, 1}.date);
    end
    
    try
        Date2{mouse}=num2str(Date(mouse));
        year=str2num(Date2{mouse}(3:4))-18;
        month=str2num(Date2{mouse}(5:6));
        day=str2num(Date2{mouse}(7:8));
        ValueOfDate(mouse)=year*365+month*30+day;
    end
end




















