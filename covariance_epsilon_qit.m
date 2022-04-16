function Sigma_epsilon_qit=covariance_epsilon_qit(be,si)
global t; global I; global Q; global K;
for t1=1:size(t)
    for t2=1:size(t)
        bt(t1,t2)=b(t(t1),t(t2));
    end
end
be=reshape(be,Q,K)';
si=reshape(si,I,Q)';
for q=1:Q
    for i=1:I
        Sigma_epsilon_qit{q,i}=[];
        for k=1:K
            Sigma_epsilon_kqi{k,i}=be(k,q)*si(q,i)*bt;
            Sigma_epsilon_qit{q,i}=blkdiag(Sigma_epsilon_qit{q,i},Sigma_epsilon_kqi{k,i});
        end
    end
end
end
