function [dist, gradi_brush]=my_query_brushfire(brushfire_map, point)


%Treating border points
if point(1)<=1
    point(1)=2;
end
if point(1)>=size(brushfire_map,1)
   point(1)=size(brushfire_map,1)-1;
end
if point(2)<=1
    point(2)=2;
end
if point(2)>=size(brushfire_map,2)
   point(2)=size(brushfire_map,2)-1;
end


%Distance from closer obstacle
dist=brushfire_map(point(1),point(2));


%Calculate neighboors of point
%Connectivity 4

%4 neighboors
    neighboors(1)=brushfire_map((point(1))+1,(point(2)));
    neighboors(2)=brushfire_map((point(1)),(point(2))+1);
    neighboors(3)=brushfire_map((point(1))-1,(point(2)));
    neighboors(4)=brushfire_map((point(1)),(point(2))-1);
   
    
    %Searching neighboor with bigger value
    [Y, sort_index] = sort(neighboors); 


%Gradient
%Direction to furthest obstacle
if sort_index(4)==1
    max_neighbour=[point(1)+1 , point(2)];
end
if sort_index(4)==2 
    max_neighbour=[point(1), point(2)+1];
end
if sort_index(4)==3
    max_neighbour=[point(1)-1 , point(2)];
end
if sort_index(4)==4 
    max_neighbour=[point(1) , point(2)-1];
end
 
%Gradient
gradi_brush=max_neighbour'-point';



end