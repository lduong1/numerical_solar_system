% The Solar System in 2-D
System = [];
mass = 10^24 * [1.989e+6, 0.330, 4.87, 5.97, 0.642, 1898, 568, 86.8, 102];
radi = 10^3 * [6.95508e+5, 4879, 12104, 12756, 6792, 142984, 120536, ...
    51118, 49528];
posi = 10^9 * [0, 57.9, 108.2, 149.6, 227.9, 778.6, 1433.5, 2872.5, ...
    4495.1];
velo = 10^3 * [0, 47.4, 35.0, 29.8, 24.1, 13.1, 9.7, 6.8, 5.4];
rgb = [1 0.84 0; 0.75 0.75 0.75; 1 0.64 0; 0 0 1; 1 0 0; 0 0.39 0; ...
    0.54 0 1; 0.53 0.8 0.98; 1 0.078 0.57];

dt = 60*60*24; %seconds, equivalent to one day on Earth
runtime = 4331; %days, or one complete orbit of Jupiter
path = zeros(3,runtime,length(mass));

for i = 1:length(mass)
    theta = rand()*2*pi;
    System = [System Body(mass(1,i), radi(1,i), posi(1,i)*[cos(theta) ...
        sin(theta)],velo(1,i)*[-sin(theta) cos(theta)], 0)];
end

for t = 1:runtime
    for i = 1:length(System)
%         if (i == 1)
%             System(1,i).mass = System(1,i).mass * 0.995;
%         end  % The Sun shrinks in mass
        path(:,t,i) = System(1,i).posi;
        traj(:,t,i) = System(1,i).velo;
        F = 0;
        for j = 1:length(System)
            if (j ~= i)
                F = F + System(1,i).grav(System(1,j));
            end
        end
        System(1,i).acce = F/System(1,i).mass;
    end
    for i = 1:length(System)
        System(1,i).velo = System(1,i).velo + System(1,i).acce * dt;
        System(1,i).posi = System(1,i).posi + System(1,i).velo * dt;
    end
end

figure(3)
hold on
axis equal
for i = 1:length(System)
    scatter(path(1,1,i), path(2,1,i), [], rgb(i,:))
end
for i = 1:length(System)
    plot(path(1,2:runtime,i), path(2,2:runtime,i), 'Color', rgb(i,:))
    quiver(System(1,i).posi(1,1), System(1,i).posi(2,1), ...
        System(1,i).velo(1,1), System(1,i).velo(2,1), 1.5*10^6, ...
        'Color', rgb(i,:))
end
xlabel('x-axis (m)');
ylabel('y-axis (m)');
title('Figure 3: 2-D model of the Solar System');