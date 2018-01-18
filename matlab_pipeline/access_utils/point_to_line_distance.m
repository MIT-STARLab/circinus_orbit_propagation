function dist = point_to_line_distance(pt, l1, l2)
% find closest point on line l1 -> l2 to the point pt

% taken from https://www.mathworks.com/matlabcentral/answers/95608-is-there-a-function-in-matlab-that-calculates-the-shortest-distance-from-a-point-to-a-line

% all are 3-d vectors
% l1 is first point on line
% l2 is second point on line
% pt is the point

a = l1 - l2;
b = pt - l2;
dist = norm(cross(a,b)) / norm(a);  % cross product gives area of parallelogram. Dividing by side of parallelogram gives height.