function isfree = PathFree(p1,p2,Obstacles)
stepsize=0.1;
isfree =1;
% p1 = line(1,:); p2 = line(2,:); 
line=[p1;p2];
L = norm(diff(line)); N = ceil(L/stepsize) + 1; 
% points = []; 
end2end = linspace(0,1,N); 
f = end2end(2:end-1)'; 
pts = ones(size(f))*p1 + f*(p2-p1); 
for r = 1:size(pts,1)
    isfree = isfree && isFree(pts(r,:), Obstacles);
    if ~isfree
        break;
    end
end

end