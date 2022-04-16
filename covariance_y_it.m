function Sigma_y_it=covariance_y_it(be,si)
global I;
beta=beta_matrix(be);
Sigma_xi_it=covariance_xi_it(si);
Sigma_epsilon_it=covariance_epsilon_it(be,si);
for i=1:I
    Sigma_y_it{i}=beta*Sigma_xi_it{i}*beta.'+Sigma_epsilon_it{i};
end
end