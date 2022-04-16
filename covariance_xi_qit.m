function Sigma_xi_qit=covariance_xi_qit(si)
global t; global I; global Q;
for t1=1:size(t)
    for t2=1:size(t)
        at(t1,t2)=a(t(t1),t(t2));
    end
end
si=reshape(si,I,Q)';
for i=1:I
    for q=1:Q
        Sigma_xi_qit{q,i}=si(q,i).^2*at;
    end
end
end