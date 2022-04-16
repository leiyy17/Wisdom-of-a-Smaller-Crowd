function Sigma_xi_it=covariance_xi_it(si)
global t; global I; global Q; global N;
si=reshape(si,I,Q)';
for i=1:I
    Sigma_xi_it{i}=zeros(Q*N,Q*N);
    for q=1:Q
        for n=1:size(t)
            for m=1:size(t)
                Sigma_xi_it{i}((n-1)*Q+q,(m-1)*Q+q)=si(q,i).^2*a(t(n),t(m));
            end
        end
    end
end
end