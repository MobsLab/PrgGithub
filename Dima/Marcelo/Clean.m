function cleanPositions = Clean(positions,maxGap,maxDistance)

if nargin<2
    maxGap = 10;
end

if nargin<3
    maxDistance = 10;
end

n = size(positions,1);

% Work on column pairs (each column pair corresponds to one LED)
for i = 1:size(positions,2)/2,

    % Interpolate missing values or large jumps
    j = (i-1)*2+1;
    jump = abs(diff(positions(:,j)))>10|abs(diff(positions(:,j+1)))>10;
    good = find(positions(:,j)>-1 & ~([jump;0] | [0;jump]));
    if length(good) < 2,
        cleanPositions(:,[j j+1]) = -ones(size(positions,1),2);
    else
%         cleanPositions(:,[j j+1]) = round(interp1(good,positions(good,[j j+1]),1:n,'linear',-1));
        cleanPositions(:,[j j+1]) = interp1(good,positions(good,[j j+1]),1:n,'linear',-1);
    end

    % Find missing stretches
    d = [-(positions(1,j)==-1) ; diff(positions(:,j)>-1)];
    start = find(d<0);
    stop = find(d>0)-1;
    % If last point is bad, final stretch should be discarded
    if positions(end,j) == -1,
        stop = [stop;n];
    end

    % Do not interpolate data that does not conform to (maxGap,maxDistance) constraints
    if length(start>0),
        i1 = Clip(start-1,1,n);
        i2 = Clip(stop+1,1,n);

        discard = find(stop-start>=maxGap ...
            | abs(positions(i1,j)-positions(i2,j)) > maxDistance ...
            | abs(positions(i1,j+1)-positions(i2,j+1)) > maxDistance);

        for k = discard(:),
            cleanPositions(start(k):stop(k),[j j+1]) = -1;
        end
    end

end