%%%
clear all
cd /media/DataMOBsRAID/ProjetAversion/OBX_brains/

a = dir;
num = 0;
OBX=[207 208 209 210 214 215 216 , 222 226 228 232 234 236 238 240 , 230,  249 250, 291 297 298,269,270:279];
CTRL=[211 212 213 217 218 219 220, 223 224 225 227 229 233 235 237 239 , 231 248, 241 242,  243 244, 253 254, 258 259 299,280:290,394,395,402,403,450,451,493,471,470];
EarlyMice = [207:220,222:229,232:240];
LateMice = [269:290];

for k = 1:length(a)
    if not(isempty(strfind(a(k).name,'-a.mat')))
        clear CmRuler
        load((a(k).name))
        num = num +1;
        %CmRuler = sqrt(diff(xbrain).^2 + diff(ybrain).^2);
        OBSize(num) = polyarea(xOB,yOB)./(CmRuler.^2);
        MouseName(num) = str2num(a(k).name(1:3));
        IsOBx(num) = ismember( MouseName(num),OBX);
    end
end


A{1} = OBSize(IsOBx==0 & ismember(MouseName,EarlyMice));
A{2} = OBSize(IsOBx==1 & ismember(MouseName,EarlyMice));

A{3} = OBSize(IsOBx==0 & ismember(MouseName,LateMice));%/1.2;
A{4} = OBSize(IsOBx==1 & ismember(MouseName,LateMice));%/1.2;

% sort out some mistakes
temp = A{4}([3,5]);
temp2 = A{3}(4:5);
A{4}(3) = temp2(1);
A{4}(5) = temp2(2);
A{3}(4) = temp(1);
A{3}(5) = temp(2);
Cols = {[0.8 0.8 0.8],[1 0.4 0.4],[0.8 0.8 0.8],[0.8 0.6 0.6]};
X = [1,2,4,5];
Legends = {'SHAM','BBX','SHAM','BBX'};
figure
MakeSpreadAndBoxPlot_SB(A,Cols,X,Legends,1,1)
ylabel('OB area (cm2)')
[p, h, stats]= ranksum(A{2},A{4});
