function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the U and W matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);


% You need to return the following values correctly
J = 0;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost function and gradient for collaborative
%               filtering. Concretely, you should first implement the cost
%               function (without regularization) and make sure it is
%               matches our costs. After that, you should implement the
%               gradient and use the checkCostFunction routine to check
%               that the gradient is correct. Finally, you should implement
%               regularization.
%
% Notes: X - num_movies  x num_features matrix of movie features
%        Theta - num_users  x num_features matrix of user features
%        Y - num_movies x num_users matrix of user ratings of movies
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the
%            i-th movie was rated by the j-th user
%
% You should set the following variables correctly:
%
%        X_grad - num_movies x num_features matrix, containing the
%                 partial derivatives w.r.t. to each element of X
%        Theta_grad - num_users x num_features matrix, containing the
%                     partial derivatives w.r.t. to each element of Theta
%
%%%%%%%%
% Compute the cost (unregularized)

Y_predicted = X * Theta'; % estimate; num_movies x num_users
% squared_cost_term = (Y_predicted - Y).^2; % squared cost; num_movies x num_users
% squared_cost_rated = squared_cost_term .* R; % only count the cost for rated movies; num_movies x num_users
% J = sum(sum(squared_cost_rated))/2;
J = sum(sum(
         (((X * Theta') - Y).^2).*R
    ))/2;

%%%%%%%%
% Compute gradients along X and Theta
% X_grad should be a matrix same size as X (num_movies x num_features)
X_grad = ((Y_predicted - Y).*R)*Theta; % num_movies x num_users * num_users x num_features

% Theta_grad should be a matrix same size as Theta (num_users * num_features)
Theta_grad = ((Y_predicted - Y).*R)' * X; % num_users x num_movies * num_movies x num_features

%%%%%%%%
% Regularized cost function terms
regularization_Theta_term = lambda/2 * sum(sum(Theta.^2));
regularization_X_term = lambda/2 * sum(sum(X.^2));

J = J + regularization_Theta_term + regularization_X_term;

% Regularized gradient terms
regularization_X_grad = lambda * X;
regularization_Theta_grad = lambda * Theta;

X_grad = X_grad + regularization_X_grad;
Theta_grad = Theta_grad + regularization_Theta_grad;




% =============================================================

grad = [X_grad(:); Theta_grad(:)];

end
