function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
%   cost of using theta as the parameter for linear regression to fit the 
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost and gradient of regularized linear 
%               regression for a particular choice of theta.
%
%               You should set J to the cost and grad to the gradient.
%

%calculating hypothesis
h = X * theta;
sum_square_term = sum((h - y).^2);
J = sum_square_term/(2*m);

J = J + lambda*sum(theta(2:end).^2)/(2*m);

%claculating gradient
diff = h-y;
grad = (X'*diff)/m;
%adding extra term for regularization in theta from 2nd term to last
grad(2:end) = grad(2:end) + (lambda/m)*theta(2:end); 









% =========================================================================

grad = grad(:);

end