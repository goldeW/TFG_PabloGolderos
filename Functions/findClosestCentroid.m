function [CentroidsAssigned, J]=findClosestCentroid(X,CentroidsPosition)
%FINDCLOSESTCENTROIDS computes the centroid memberships for every example
%   idx = FINDCLOSESTCENTROIDS (X, centroids) returns the closest centroids
%   in idx for a dataset X where each row is a single example. idx = m x 1 
%   vector of centroid assignments (i.e. each entry in range [1..K])
%

% Set K
K = size(CentroidsPosition, 1);

% You need to return the following variables correctly.
CentroidsAssigned = zeros(size(X,1), 1);

% ====================== YOUR CODE HERE ======================
% Instructions: Go over every example, find its closest centroid, and store
%               the index inside idx at the appropriate location.
%               Concretely, idx(i) should contain the index of the centroid
%               closest to example i. Hence, it should be a value in the 
%               range 1..K
%
% Note: You can use a for-loop over the examples to compute this.
%

%Your code here
J=0;

for i = 1:size(X, 1)
  d=zeros(K,1);

  for k = 1:K
   d(k)=sqrt(sum((X(i,:)-CentroidsPosition(k,:)).^2));
  
  end
  [min_d, CentroidsAssigned(i)]=min(d);
  J=J+min_d;

end
m=size(X,1);
J=J/m;

% =============================================================

end


