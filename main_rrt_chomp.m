close all; clear all; 
[polyObs,Obstacles, ax] = LoadObstacles; hold on;
M = 100;xlim=10; ylim=10;
ax.Visible = 'off'; frame = getframe(ax); ax.Visible = 'on'; 
img = imresize(frame.cdata,[M,M]); [s1,s2,s3] = size(img); bit = flipud(rgb2gray(img)); 

bitmap = zeros(s1,s2); 
bitmap(bit<10) = 1;
num_samples=500;
%%
% brushfire_map=bitmap;
size_x=100;
size_y=size_x;
for i=1:size(bitmap,1)
    for j=1:size(bitmap,2)
%         Setting '1' to borders of the map
        if i<=1 || j<=1 || i>=size(bitmap,1) || j>=size(bitmap,2)
            bitmap(i,j)=1;
        end
    end
end
x_max=100; y_max=100;
hold on;
g_x=[0:1:x_max]; % user defined grid Y [start:spaces:end]
g_y=[0:1:y_max]; % user defined grid X [start:spaces:end]
% for i=1:length(g_x)
%    plot([g_x(i) g_x(i)],[g_y(1) g_y(end)],'k:','HandleVisibility','off') %y grid lines
%    hold on    
% end
% for i=1:length(g_y)
%    plot([g_x(1) g_x(end)],[g_y(i) g_y(i)],'k:','HandleVisibility','off') %x grid lines
%    hold on    
% end
% [distMap] = getDistanceMap(brushfire_map);
% [value_map]=brushfire(brushfire_map);



%Steer fixed step size
step_size=20;


q_start= [65, 95.6]; q_goal= [46.9, 5.115];
disp('Click in the figure to select q_start')
[q_start(1), q_start(2)] = ginput(1);
% figure(1)
hold on
% scatter(round(q_start(1)),round(q_start(2)),400,[0 1 0], 'filled')

disp('Click in the figure to select q_goal')
[q_goal(1), q_goal(2)] = ginput(1);
% scatter(round(q_goal(1)),round(q_goal(2)),300,[1 0 0],'filled')
map_grid=bitmap;




%Function that create the discrete map and run the RRT algorithm
%Returns the waypoints found by the RRT algorithm
% RRT_waypoints=RRT_function(map_grid,size_x,size_y,num_samples,step_size,prob_Xrand,q_start,q_goal);
 tol=5;
 tic
[RRT_waypoints]= RRTStar(q_start,q_goal,polyObs,num_samples,step_size,Obstacles);

toc
%Create Brusfire map
cost_rrtstar=norm(RRT_waypoints(:,1)-RRT_waypoints(:,2));

%%
% close all
Path = RRT_waypoints;
plot(Path(1,:), Path(2,:),'g', 'Linewidth', 2)
% legend(['RRT*'])
% hold on
% % plot(Path(1,:), Path(2,:), 'g--', 'Linewidth', 1.5); hold on;
% plot(polyObs);
% axis equal


[brushfire_map]=brushfire(map_grid);
%Inverted brushfire
for i=1:size(map_grid,1)
    for j=1:size(map_grid,2)
        if map_grid(i,j)==1
            inv_map(i,j)=0;
        else
            inv_map(i,j)=1;
        end       
    end
end
[inv_brushfire_map]=brushfire(inv_map);
for i=1:size(inv_brushfire_map,1)
    for j=1:size(inv_brushfire_map,2)
        if inv_brushfire_map(i,j)==1
            inv_brushfire_map(i,j)=0;
        else
            inv_brushfire_map(i,j)=-inv_brushfire_map(i,j);
        end       
    end
end


% set(gca,'xdir','reverse','ydir','reverse')

%brushire + inverted brushfire
brushfire_complete=brushfire_map + inv_brushfire_map;









%Now, use CHOMP to make the  smooth if path has been found
tic

smooth_traj=my_chomp(RRT_waypoints,brushfire_complete);

brushfire_complete(brushfire_complete<60) =1;
smooth_traj=my_chomp(RRT_waypoints,brushfire_complete);
toc
plot(smooth_traj(1,:), smooth_traj(2,:),'r','LineWidth',3)
grid off
[~, hobj, ~, ~]=legend({'RRT*','Chomp'})
% end
hl = findobj(hobj,'type','line');
set(hl,'LineWidth',2);


cost_chomp=norm(smooth_traj(1,:)-smooth_traj(2,:));

saveas(gcf,'RRTChomp','epsc')


traj=smooth_traj;
for i=1:(length(traj)-1)
    free_smooth(i)=PathFree(traj(:,i)',traj(:,i+1)',Obstacles);
end
free_smooth;
sum(free_smooth);
if any(free_smooth==0)
       disp('Smooth Path not free')
       return
else
       disp('Smooth Path free')
end
figure()
dx = diff(ax.XLim)/M; dy = diff(ax.YLim)/M;
[X,Y] = meshgrid(dy*(0.05:1:M),dx*(0.05:1:M));
surf(X,Y,brushfire_map);


% RGB1 = repmat(rescale(flip(brushfire_complete)), [1 1 3]);
% figure
% imshow(RGB1), title('Euclidean')
% hold on;imcontour(flip(brushfire_complete)); hold on;
% gca=plot(10*Path(1,:), 10*(Path(2,:)), 'g', 'Linewidth', 3)
% 
