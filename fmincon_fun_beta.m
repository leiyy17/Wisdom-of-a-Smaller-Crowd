function f=fmincon_fun_beta(x,y_it,si,mu)
global I;
Sigma_y_it=covariance_y_it(x,si);
mu_y_it=mean_y_it(x,mu,si);
f=0;
for i=1:I
    f=f+log(det(Sigma_y_it{i}))+(y_it{i}-mu_y_it{i}).'*(inv(Sigma_y_it{i}))*(y_it{i}-mu_y_it{i});
end
end