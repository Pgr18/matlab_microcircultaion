function [x0,y0] = intersections(x1,y1,x2,y2,robust)
%INTERSECTIONS Find intersection points of two 2D curves.
%   [X0,Y0] = INTERSECTIONS(X1,Y1,X2,Y2) finds intersection points between
%   two curves defined by (X1,Y1) and (X2,Y2). Returns empty arrays if no
%   intersections exist.

% Default arguments
if nargin < 5
    robust = true; % Use more accurate but slower method
end

% Initialize outputs
x0 = [];
y0 = [];

% Check for trivial cases
if isempty(x1) || isempty(x2) || length(x1) ~= length(y1) || length(x2) ~= length(y2)
    return;
end

% Resample curves to ensure sufficient density
min_points = 100;
if length(x1) < min_points
    t = linspace(0,1,length(x1));
    tt = linspace(0,1,min_points);
    x1 = interp1(t,x1,tt,'linear');
    y1 = interp1(t,y1,tt,'linear');
end
if length(x2) < min_points
    t = linspace(0,1,length(x2));
    tt = linspace(0,1,min_points);
    x2 = interp1(t,x2,tt,'linear');
    y2 = interp1(t,y2,tt,'linear');
end

% Find segments that might intersect
[x0,y0] = curve_intersections(x1,y1,x2,y2,robust);

% Filter out duplicates
if ~isempty(x0)
    [~,unique_idx] = uniquetol([x0,y0],'ByRows',true);
    x0 = x0(unique_idx);
    y0 = y0(unique_idx);
end
end

function [x0,y0] = curve_intersections(x1,y1,x2,y2,robust)
% Core intersection finding logic
x0 = [];
y0 = [];
tol = 1e-12; % Numerical tolerance

% Check all segment pairs
for i = 1:length(x1)-1
    for j = 1:length(x2)-1
        % Get current segments
        seg1 = [x1(i:i+1); y1(i:i+1)];
        seg2 = [x2(j:j+1); y2(j:j+1)];
        
        % Find intersection
        [xi,yi] = segment_intersection(seg1,seg2,robust,tol);
        
        % Store if valid
        if ~isempty(xi) && ~isnan(xi)
            x0(end+1) = xi;
            y0(end+1) = yi;
        end
    end
end
end

function [xi,yi] = segment_intersection(seg1,seg2,robust,tol)
% Find intersection between two line segments
xi = [];
yi = [];

% Parametric equations
A = seg1(:,1); B = seg1(:,2);
C = seg2(:,1); D = seg2(:,2);

% Vector components
r = B - A;
s = D - C;

% Cross products
rxs = r(1)*s(2) - r(2)*s(1);
if abs(rxs) < tol % Segments are parallel
    return;
end

% Solve for parameters
t = ((C(1)-A(1))*s(2) - (C(2)-A(2))*s(1)) / rxs;
u = ((C(1)-A(1))*r(2) - (C(2)-A(2))*r(1)) / rxs;

% Check if intersection occurs within segments
if robust
    in_range = (t >= -tol && t <= 1+tol && u >= -tol && u <= 1+tol);
else
    in_range = (t >= 0 && t <= 1 && u >= 0 && u <= 1);
end

if in_range
    xi = A(1) + t*r(1);
    yi = A(2) + t*r(2);
end
end