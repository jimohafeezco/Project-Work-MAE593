function Path = RRT(qstart, qgoal,Obstacle,stepsize,N)
%RRT Summary of this function goes here
%   Detailed explanation goes here
bound=[0 100 0 100];
Graph = PGraph(); 
Graph.add_node(qstart); parent = 0; tol=1;
% while(norm(Graph.coord(Graph.n) - qgoal') > tol)
for i=1: N
    qrand = [bound(1) + rand*(bound(2) - bound(1)); bound(3) + rand*(bound(4) - bound(3))];
    c = Graph.closest(qrand); qc = Graph.coord(c)';
    qnew = Graph.coord(c) + stepsize*(qrand - Graph.coord(c))/norm(qrand - Graph.coord(c))';
    qnew(1) = max(min(qnew(1),bound(2)),bound(1));
    qnew(2) = max(min(qnew(2),bound(4)),bound(3));
%     if(isFree(qnew',O))
    if(isFree(qnew', Obstacle)) && PathFree(qnew',qc,Obstacle)
        end2end = linspace(0,1,50); f = end2end(2:end-1)';
        pts = ones(size(f))*qc + f*(qc - qnew'); 
        if(isPathFree(pts,Obstacle))
            Graph.add_node(qnew);
            Graph.add_edge(Graph.n, c);
            parent = [parent, c];
        end
    end
end
Graph.plot;

path = [Graph.n];
Path = [Graph.coord(Graph.n)';qgoal];
hasparent = 1;
while hasparent
    path = [parent(path(1)),path];
    Path = [Graph.coord(path(1))';Path];
    if(path(1) == 0) 
        path = [];
        break;
    else
        hasparent = parent(path(1))> 0;
    end
end

% plot(Path(:,1), Path(:,2), 'y','linewidth',3); hold on;
Path2 = PostProcessor(Path,Obstacle);
% plot(Path(:,1), Path(:,2), 'linewidth',3);
plot(Path2(:,1), Path2(:,2),'g', 'linewidth',3);
Path = Path2';
end