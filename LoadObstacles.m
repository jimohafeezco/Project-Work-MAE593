function [polyObs,Obstacles, ax] = LoadObstacles
load('Obstacles.mat'); 
% f = figure('Color', 'w', 'Position', [20 180 600 450]);
for n = 1:numel(Obstacles)
    obstacle = Obstacles{n};
    fill(obstacle(1,:), obstacle(2,:), 'k', 'LineWidth', 1,'HandleVisibility','off'); hold on;
end
% plot(...,'HandleVisibility','off')

isfreefxn = @(q) isFree(q, Obstacles);
axis([0 100 0 100]);
hold on; grid on;
ax = gca;
end