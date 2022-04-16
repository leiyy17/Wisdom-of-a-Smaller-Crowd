function Sigma_epsilon_it=covariance_epsilon_it(be,si)
global t; global I; global Q; global K;
for t1=1:size(t)
    for t2=1:size(t)
        bt(t1,t2)=b(t(t1),t(t2));
    end
end
be=reshape(be,Q,K)';
si=reshape(si,I,Q)';
for i=1:I
    Sigma_epsilon_it{i}=[];
    for k=1:K
        Sigma_epsilon_ki{k,i}=be(k,:)*si(:,i)*bt;
        Sigma_epsilon_it{i}=blkdiag(Sigma_epsilon_it{i},Sigma_epsilon_ki{k,i});
    end
end
end
