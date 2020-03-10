%% The Solar System in 3-D
System = [];
mass = 10^24 * [1.989e+6, 0.330, 4.87, 5.97, 0.642, 1898, 568, 86.8, 102];
radi = 10^3 * [6.95508e+5, 4879, 12104, 12756, 6792, 142984, 120536, ...
    51118, 49528];
posi = 10^9 * [0, 57.9, 108.2, 149.6, 227.9, 778.6, 1433.5, 2872.5, ...
    4495.1];
velo = 10^3 * [0, 47.4, 35.0, 29.8, 24.1, 13.1, 9.7, 6.8, 5.4];
% incl = [0, 7, 3.4, 0, 1.9, 1.3, 2.5, 0.8, 1.8]*pi/180;
rgb = [1 0.84 0; 0.75 0.75 0.75; 1 0.64 0; 0 0 1; 1 0 0; 0 0.39 0; ...
    0.54 0 1; 0.53 0.8 0.98; 1 0.078 0.57];

dt = 60*60*24; %seconds, equivalent to one day on Earth
runtime = 4331; %days, or one complete orbit of Jupiter
path = zeros(3,runtime,length(System));
quiv = zeros(3,runtime,length(System));

for i = 1:length(mass)
    theta = rand()*2*pi;
%     phi = incl(1,i);
    phi = rand()*pi;
    c = rand();
    rDir = [sin(phi)*cos(theta), sin(phi)*sin(theta), cos(phi)];
    vDir = c*[cos(phi)*cos(theta), cos(phi)*sin(theta), -sin(phi)];
    vDir = vDir + sqrt(1-c^2)*[-sin(theta), cos(theta), 0];
%     vDir = [-sin(theta), cos(theta), 0];
    System = [System Body(mass(1,i), ... %radi(1,i)
        posi(1,i)*rDir, velo(1,i)*vDir, 0)];
%     if (i > 1)
%         angl(:,i-1) = [phi; theta];
%     end
end

for t = 1:runtime
    for i = 1:length(System)
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
        path(:,t,i) = System(1,i).posi;
        quiv(:,t,i) = System(1,i).velo;
    end
end

figure(7)
view(3)
hold on
grid on
axis equal
for i = 1:length(System)
    for i = 1:length(System)
        scatter3(path(1,1,i), path(2,1,i), path(3,1,i), [], rgb(i,:))
        legend('Sun', 'Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', ...
            'Saturn', 'Uranus', 'Neptune')
    end
    for i = 1:length(System)
        plot3(path(1,2:runtime,i), path(2,2:runtime,i),...
            path(3,2:runtime,i), 'Color', rgb(i,:))
        quiver3(System(1,i).posi(1,1), System(1,i).posi(2,1), ...
            System(1,i).posi(3,1), System(1,i).velo(1,1), ...
            System(1,i).velo(2,1), System(1,i).velo(3,1), 1.5*10^6, ...
            'Color', rgb(i,:))
    end
end
xlabel('x-axis (m)')
ylabel('y-axis (m)')
zlabel('z-axis (m)')
title('Figure 6: 3-D model of the Solar System')