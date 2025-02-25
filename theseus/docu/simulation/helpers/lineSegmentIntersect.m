function g = lineSegmentIntersect(indL,XY,D,l0)
%LINESEGMENTINTERSECT Intersections of line segments.
%   OUT = LINESEGMENTINTERSECT(XY1,XY2) finds the 2D Cartesian Coordinates of
%   intersection points between the set of line segments given in XY1 and XY2.
%
%   XY1 and XY2 are N1x4 and N2x4 matrices. Rows correspond to line segments. 
%   Each row is of the form [x1 y1 x2 y2] where (x1,y1) is the start point and 
%   (x2,y2) is the end point of a line segment:
%
%                  Line Segment
%       o--------------------------------o
%       ^                                ^
%    (x1,y1)                          (x2,y2)
%
%   OUT is a structure with fields:
%
%   'intAdjacencyMatrix' : N1xN2 indicator matrix where the entry (i,j) is 1 if
%       line segments XY1(i,:) and XY2(j,:) intersect.
%
%   'intMatrixX' : N1xN2 matrix where the entry (i,j) is the X coordinate of the
%       intersection point between line segments XY1(i,:) and XY2(j,:).
%
%   'intMatrixY' : N1xN2 matrix where the entry (i,j) is the Y coordinate of the
%       intersection point between line segments XY1(i,:) and XY2(j,:).
%
%   'intNormalizedDistance1To2' : N1xN2 matrix where the (i,j) entry is the
%       normalized distance from the start point of line segment XY1(i,:) to the
%       intersection point with XY2(j,:).
%
%   'intNormalizedDistance2To1' : N1xN2 matrix where the (i,j) entry is the
%       normalized distance from the start point of line segment XY1(j,:) to the
%       intersection point with XY2(i,:).
%
%   'parAdjacencyMatrix' : N1xN2 indicator matrix where the (i,j) entry is 1 if
%       line segments XY1(i,:) and XY2(j,:) are parallel.
%
%   'coincAdjacencyMatrix' : N1xN2 indicator matrix where the (i,j) entry is 1 
%       if line segments XY1(i,:) and XY2(j,:) are coincident.

% Version: 1.00, April 03, 2010
% Version: 1.10, April 10, 2010
% Author:  U. Murat Erdem

% CHANGELOG:
%
% Ver. 1.00: 
%   -Initial release.
% 
% Ver. 1.10:
%   - Changed the input parameters. Now the function accepts two sets of line
%   segments. The intersection analysis is done between these sets and not in
%   the same set.
%   - Changed and added fields of the output. Now the analysis provides more
%   information about the intersections and line segments.
%   - Performance tweaks.

% I opted not to call this 'curve intersect' because it would be misleading
% unless you accept that curves are pairwise linear constructs.
% I tried to put emphasis on speed by vectorizing the code as much as possible.
% There should still be enough room to optimize the code but I left those out
% for the sake of clarity.
% The math behind is given in:
%   http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
% If you really are interested in squeezing as much horse power as possible out
% of this code I would advise to remove the argument checks and tweak the
% creation of the OUT a little bit.

[n_rows,~] = size(XY);


%%% Prepare matrices for vectorized computation of line intersection points.
%-------------------------------------------------------------------------------
X1 = repmat(XY(:,1),1,n_rows);
X2 = repmat(XY(:,3),1,n_rows);
Y1 = repmat(XY(:,2),1,n_rows);
Y2 = repmat(XY(:,4),1,n_rows);

X4_X3 = (X2'-X1');
Y1_Y3 = (Y1-Y1');
Y4_Y3 = (Y2'-Y1');
X1_X3 = (X1-X1');
X2_X1 = (X2-X1);
Y2_Y1 = (Y2-Y1);


numerator_a = X4_X3 .* Y1_Y3 - Y4_Y3 .* X1_X3;
numerator_b = X2_X1 .* Y1_Y3 - Y2_Y1 .* X1_X3;
denominator = Y4_Y3 .* X2_X1 - X4_X3 .* Y2_Y1;

u_a = numerator_a ./ denominator;
u_b = numerator_b ./ denominator;

% Find the adjacency matrix A of intersecting lines.
INT_B = (u_a >= 0.0000000001) & (u_a <= 0.9999999999) & (u_b >= 0.0000000001) & (u_b <= 0.9999999999);
INT_X = X1+X2_X1.*u_a;

% Arrange output.
[ns, ms] = find(INT_B);
if(~isempty(ns))
    g = [u_a(INT_B) u_b(INT_B) indL(ns)' indL(ms)' INT_X(INT_B)];
else
    g = [];
end
end

