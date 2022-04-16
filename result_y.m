function L=result_y(model,y_it)
global I;
Sigma_y_it=covariance_y_it(model.beta,model.sigma);
mu_y_it=mean_y_it(model.beta,model.mu,model.sigma);
L=0;
for i=1:I
    L=L+log(det(Sigma_y_it{i}))+(y_it{i}-mu_y_it{i}).'*(inv(Sigma_y_it{i}))*(y_it{i}-mu_y_it{i});
end
end