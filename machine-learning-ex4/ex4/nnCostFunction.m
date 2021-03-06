function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

nX = [ones(m,1) X];
Z2 = Theta1 * nX';
A2 = sigmoid(Z2);
A2 = [ones(1,m); A2];
Z3 = Theta2 * A2;
A3 = sigmoid(Z3);
%h_theta_(x) = A3;
H = A3;
%now we need to map y as a vector first take transpose of y i.e ny = y'
%and the replace each element of y was a vector of that number
%for eg if there is two then replace two with 10 by 1 vector
%such that value at index 2 equal to one and else where zero
y = y';
t = zeros(num_labels,m);
%t is the mapping of y as a vector of 10 by 1 in it' each column
for i=1:m
    t(y(i),i) = 1;
end
%inside term of sigma
sigma_term = t.*log(H) + (1-t).*log(1-H);
J = -sum(sum(sigma_term))/m;
%part:1 completed

%calculating second part
J = J + lambda*(sum(sum(Theta1(:,2:end).^2)) + sum(sum(Theta2(:,2:end).^2)))/(2*m);




%calculating thrid part
big_delta_1 = zeros(size(Theta1));
big_delta_2 = zeros(size(Theta2));

for i=1:m
    a_1 = X(i,:)';
    a_1 = [1 ; a_1];
    z_2 = Theta1 * a_1;
    a_2 = sigmoid(z_2);
    a_2 = [1 ; a_2];
    z_3 = Theta2 * a_2;
    a_3 = sigmoid(z_3);
    delta_3 = a_3 - t(:,i);
    z_2 = [1 ; z_2];
    delta_2 = (Theta2'*delta_3).*(sigmoidGradient(z_2));
    delta_2 = delta_2(2:end);
    %finding big_delta
    big_delta_1 = big_delta_1 + delta_2*(a_1');
    big_delta_2 = big_delta_2 + delta_3*(a_2');
end

%calculating gradient for regularised neural network
Theta1_grad = (1/m)*big_delta_1;
Theta1_grad(:,2:end) = Theta1_grad(:,2:end) + (lambda/m)*Theta1(:,2:end); 
Theta2_grad = (1/m)*big_delta_2;
Theta2_grad(:,2:end) = Theta2_grad(:,2:end) + (lambda/m)*Theta2(:,2:end);



% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
