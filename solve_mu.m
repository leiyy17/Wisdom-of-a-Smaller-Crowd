function mu=solve_mu(be0,si0,y_it)
global I; global Q;
beta=beta_matrix(be0);
sigma_iNt=sigma_iNt_vector(si0);
Sigma_y_it=covariance_y_it(be0,si0);
mu=[];
for i=1:I
    m=inv(beta.'*inv(Sigma_y_it{i})*beta)*beta.'*inv(Sigma_y_it{i})*y_it{i}-sigma_iNt{i};
    mu_i{i}=m(1:Q);
    mu=[mu mu_i{i}];
end
mu=reshape(mu',Q*I,1);
end