function mu_y_it=mean_y_it(be,mu,si)
global I;
beta=beta_matrix(be);
sigma_iNt=sigma_iNt_vector(si);
mu_iI=mu_iI_vector(mu);
for i=1:I
    mu_y_it{i}=beta*(sigma_iNt{i}+mu_iI{i});
end
end