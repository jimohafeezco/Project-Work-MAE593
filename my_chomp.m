function [smooth_traj] = my_chomp(traji,brushfire_map)


traj1=[];
traj2=[];
for i=1:length(traji)-1
    traj1=[traj1 linspace(traji(1,i), traji(1,i+1), 5)];
    traj2=[traj2 linspace(traji(2,i), traji(2,i+1), 5)];
end
Path=[traj1;traj2];
% plot(Path(1,:), Path(2,:))
hold on
niter=  10;%Number of iterations
mu = 0.4;%Smoothness
alpha = 0.005;%Avoid obstacles
epsilon = 15;%Distance of obstacle detection

for n=1:niter
    for i=2:length(Path)-1

        
        %Smoothness gradient
        gradsmooth=Path(:,i+1)+Path(:,i-1)-2*Path(:,i);
        
        dq=Path(:,i)-Path(:,i-1);
        ddq=Path(:,i+1)-Path(:,i-1);
        
        %Get distance to closer obstacle and gradient
%         Gx,Gy =
        [d, gradc]=my_query_brushfire(brushfire_map, round(10*Path(:,i))');
%       
% 
%         d = brushfire_map(round(Path(1,i)),round(Path(2,i)))
%         gradc1= Gx(round(Path(1,i)),round(Path(2,i)));
%         gradc2= Gy(round(Path(1,i)),round(Path(2,i)));
%         gradc = [gradc1; gradc2];
        if d<0
            c=-d+0.5*epsilon;
        else if d>=0 && d <= epsilon
            c=1/(2*epsilon)*(d-epsilon)^2;
        else
            c=0;
            end
        end
%         c = max(epsilon-d, 0);
        %Obstacle Gradient
        gradobst=norm(dq)*(eye(2)-dq*dq')*gradc-c*(norm(dq)^-2*(eye(2)-dq*dq')*ddq);
        

       %Total Gradient
        grad=gradsmooth+alpha*gradobst;
                
        %If gradient grown too much and became degenerated
        if sum(isnan(grad))>=1
            disp('Warning -> Degenerated gradient. Try smaller alpha')
            grad=[0;0];
        end
%         if isFree(traj(:,i)
        Path(:,i)=Path(:,i)+mu*grad;
        
    end
    
end
smooth_traj=Path;
end