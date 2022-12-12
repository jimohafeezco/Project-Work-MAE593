dist=unique(brushfire_map);
epsilon= 10;
c = max(epsilon-dist,0);

plot(dist,c)