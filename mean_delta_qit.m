function mu_delta_qit=mean_delta_qit(be,mu,si)
global I; global Q;
beta_q=beta_q_matrix(be);
sigma_qiNt=sigma_qiNt_vector(si);
mu_qiI=mu_qiI_vector(mu);
for q=1:Q
    for i=1:I
        mu_delta_qit{q,i}=beta_q{q}*(sigma_qiNt{q,i}+mu_qiI{q,i});
    end
end
end