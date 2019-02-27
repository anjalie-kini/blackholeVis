% rk4step method found at: http://www.math.mcgill.ca/gantumur/math579w10/matlab/rk4step.m

% Usage: y = rk4step(f,t,x,h)
% One step of Runge-Kutta method of order 4 for initial value problems

% Input:
% f - Matlab inline function f(t,y)
% t - initial time
% x - initial condition
% h - stepsize

% Output:
% y - computed solution at t+h

function y = rk4step(f,t, x,h)
halfh = h / 2;
s1 = f(t, x);
s2 = f(t + halfh, x + halfh * s1);
s3 = f(t + halfh, x + halfh * s2);
s4 = f(t + h, x + h * s3);
y = x + (s1 + 2 * s2 + 2 * s3 + s4) * h / 6;