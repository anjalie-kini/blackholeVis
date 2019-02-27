function rayTracingFunction(g,m,s)

%fig = figure('Name','Blackhole Light Path Simulation','position',[100 300 1000 600]);

% Ray Tracing (generating light paths using geodesic equations) around a 
% Kerr (rotating) black hole

% Set the number of rows and columns of rays (there are num_ray_rows *
% num_ray_cols total rays)
num_ray_rows = 10; % pixels                                     
num_ray_cols = 10; % pixels       
% (not worth making a parameter because too few or too many just messes up
% the plot / makes it hard to discern individual rays)

startTime = tic;

% Input parameters and constants
% Default - (1, 1, 0.6)
% (gravitational "constant" is a parameter because mass and gravitation
% need to be two factors which each proportionately affect the radius and
% therefore pull of the black hole)
grav = g; % gravitational constant 
mass = m; % mass of blackhole
spin = s; % Kerr ( spin ) parameter = angular momentum
radiusBH = 2 * grav * mass; % proportional to Schwarzschild radius

% (celestial sphere used to limit the lengths of the rays / create a
% reasonable field of vision)
radiusCS = 80; %radius of celestial sphere

% draw black sphere in center of field
% (hold on to map rays over field)
[X,Y,Z] = sphere; 
colormap ([0 ,0 ,0])
% (draws sphere proportional to calculated radiusBH)
surf(radiusBH*X,radiusBH*Y,radiusBH*Z) 
axis equal
hold on 

% Formulas (functions of r or theta) shorten code in ODEs
% (r is radius, theta is intial deflection angle)
sigma = @(r,theta) r^2 + spin^2 * cos(theta)^2;
% deriv of sigma with respect to r
sigma_deriv_r = @(r) 2 * r;
% deriv of sigma with respect to theta
sigma_deriv_theta = @(theta) - 2 * spin^2 * cos(theta) * sin(theta); 
delta = @(r) r^2 - radiusBH * r + spin^2;
% deriv of delta with respect to r
delta_deriv_r = @(r) 2 * r - radiusBH;

% window size determines range of deflection angles
window_height = 0.00001;
% (ratio of window height/width must be the same as ratio of resolution
% height/width)
window_width = (num_ray_cols/num_ray_rows)* window_height;
% distance determines relative positions of ray start point and black hole
distance_from_window = -2*0.000007;

stepsize = 0.07; % stepsize for Runge Kutta 4 ODE method
% (tradeoff here - smaller is faster but less accurate)
% (based on experimentation, ideal zone is anywhere from .05 to .105)

for j = 1: num_ray_cols
    % continually updates progress bar
    %loadingBar.iterate(1); 
    % calculate the ray path for each initial condition
    for i = 1: num_ray_rows
        % (evenly space rays)
        pos_height = window_height/2 - (i - 1) * window_height/(num_ray_rows - 1); 
        pos_width = -window_width/2 + (j-1) * window_width/(num_ray_cols - 1);
        
        % Initialize radius and angles
        r = 70;
        theta = pi/2 - pi/46;
        phi = 0;
        theta_dot = 1;
        phi_dot = (csc(theta)* pos_width) / sqrt((spin^2 + r^2) * (distance_from_window^2 + pos_width^2 + pos_height^2));
        p_r = 2 * sigma(r,theta) * (pos_height * (spin^2 + r^2) * cos(theta) + r * sqrt(spin^2 +r^2) * sin(theta) * distance_from_window)...
            /(sqrt(distance_from_window^2 + pos_height^2 + pos_width^2) * (spin^2 + 2 * r^2 + spin^2 * cos(2*theta)) * delta(r)); 
        p_theta = 2 * sigma(r,theta) * (-pos_height * r * sin(theta) + sqrt( spin^2 + r^2 ) * cos(theta) * distance_from_window)...
            /(sqrt(distance_from_window^2 + pos_height^2 + pos_width^2 ) * ( spin^2 + 2 * r^2 + spin^2 * cos(2*theta)));
    
        %Conserved quantities
        e = (1 - radiusBH/r) * theta_dot + (radiusBH * spin * phi_dot)/r;
        l = -(radiusBH*spin)/r * theta_dot + (r^2 + spin^2 + (radiusBH * spin^2)/r) * phi_dot;

        %Geodesic equations
        % input : x = [r; theta; phi; p_r; p_theta]
        % ouput: dx = [d_r; d_theta; d_phi; d_pr; d_ptheta] 
        f = @(lambda, x) [( x(4) * delta(x(1)) ) / sigma(x(1),x(2)) ;
                        x(5) / sigma(x(1), x(2));
                        (spin*(-spin * l + x(1) * radiusBH * e ) + l * csc(x(2))^2 * delta(x(1)) )/( delta(x(1)) * sigma(x(1),x(2)));
                        -(1/(2 * delta(x(1))^2 * sigma(x(1),x(2))^2) ) * (sigma(x(1),x(2)) * (-e * delta(x(1)) *...
                        ( spin * radiusBH * (-2 * l + spin * e * sin (x(2)) ^ 2) + 2 * x (1) * e * sigma(x(1) , x(2))) ...
                                +(spin*(spin*l^2-2*l*x(1)*radiusBH*e+spin*x(1)*radiusBH*e^2*sin(x(2))^2)+x(4)^2 *... 
                                delta(x(1))^2 + ( spin^2 + x(1)^2 ) * e^2 * sigma(x(1),x(2))) * delta_deriv_r(x(1)) )... 
                                + delta(x(1))*(spin*(l*(spin*l-2*x(1)*radiusBH*e)+spin*x(1)*radiusBH*e^2*sin(x(2))^2 )...
                                - delta(x(1)) * (x(5)^2 + l^2 * csc(x(2))^2 + x(4)^2 * delta(x(1)))) * sigma_deriv_r(x(1)) );
                        -( 1 / ( 2 * delta(x(1)) * sigma(x(1),x(2))^2)) * (-2 * sin(x(2)) * (spin^2 * x(1) * radiusBH * e^2 * cos(x(2))... 
                                + l^2 * cot(x(2)) * csc(x(2))^3 * delta(x(1)) ) * sigma(x(1),x(2))...
                                + (spin * (l * (spin * l - 2 * x(1) * radiusBH * e) + spin * x(1) * radiusBH * e^2 * sin(x(2))^2 ) - delta(x(1))... 
                                *(x(5)^2 + l^2 * csc(x(2))^2 + x(4)^2 * delta(x(1)))) * sigma_deriv_theta(x(2)))];
        
        % (to be inputted into Range Kutta method)
        rk_input_BC_init = [r ; theta ; phi ; p_r ; p_theta];
        rk_input_BC = rk_input_BC_init'; %tranpose x_0 to column matrix
        
        k=1;
        % Limit curves to celestial sphere
        while (radiusBH < rk_input_BC(k,1)) && (rk_input_BC(k,1) < radiusCS) && (k<20000)
            % Clean coordinates
            rk_input_BC(k,2) = mod(rk_input_BC(k,2),2*pi); 
            rk_input_BC(k,3) = mod(rk_input_BC(k,3),2*pi); 
            
            if rk_input_BC(k,2) > pi
                rk_input_BC(k,2) = 2*pi - rk_input_BC(k,2);
                rk_input_BC(k,3) = mod(pi + rk_input_BC(k,3),2*pi ); 
            end

            k = k+1;

            % Use rk4step to simplify geodesic curve
            rk_input_BC(k,:) = rk4step(f, 0, rk_input_BC(k-1,:)' , min([stepsize*delta(rk_input_BC(k-1,1));stepsize]))'; 
        end

        % Transform to from Boyer-Lindquist coords to Cartesian coords
        % (Boyer-Lindquist is standardized metric for Kerr spacetime)
        [n,~] = size(rk_input_BC);
        A = spin*ones(n,1);
        CoordConversion = @(r,theta ,phi) [sqrt(r.^2 + A.^2).*sin(theta).*cos(phi),...
            sqrt(r.^2 + A.^2).*sin(theta).*sin(phi),r.*cos(theta )];
        cartesianCoords = CoordConversion(rk_input_BC(:,1),rk_input_BC(:,2),rk_input_BC(:,3));
        plot3(cartesianCoords(:,1),cartesianCoords(:,2),cartesianCoords(:,3)); 
        pause(0.001);
    end
end

hold off
   
%Final computations time
endTime = toc(startTime);
fprintf('%d minutes and %f seconds\n',floor(endTime/60),rem(endTime,60));
end
