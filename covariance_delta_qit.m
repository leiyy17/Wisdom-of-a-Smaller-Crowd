function Sigma_delta_qit=covariance_delta_qit(be,si)
global I; global Q;
beta_q=beta_q_matrix(be);
Sigma_xi_qit=covariance_xi_qit(si);
Sigma_epsilon_qit=covariance_epsilon_qit(be,si);
for q=1:Q
    for i=1:I
        Sigma_delta_qit{q,i}=beta_q{q}*Sigma_xi_qit{q,i}*beta_q{q}.'+Sigma_epsilon_qit{q,i};
    end
end
end