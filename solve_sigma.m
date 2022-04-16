function si=solve_sigma(be0,mu,y_it,si0)
tol_em=0.001;  maxiter_em=100;
global Q; global I;
for iter_em=1:maxiter_em
    mu_delta_qit=mean_delta_qit(be0,mu,si0);
    Sigma_delta_qit=covariance_delta_qit(be0,si0);
    Sigma_y_it=covariance_y_it(be0,si0);
    mu_y_it=mean_y_it(be0,mu,si0);
    xs=reshape(si0,I,Q)';
    for q=1:Q
        for i=1:I
            A=mu_delta_qit{q,i}+Sigma_delta_qit{q,i}*inv(Sigma_y_it{i})*(y_it{i}-mu_y_it{i});
            B=Sigma_delta_qit{q,i}*inv(Sigma_y_it{i})*(Sigma_y_it{i}-Sigma_delta_qit{q,i});
            x0=xs(q,i);
            lb=0.0001; ub=1; 
            options=optimset('Algorithm','sqp','Display', 'off');
            [x]=fmincon(@(x)fmincon_fun_sigma(x,A,B,be0,mu,q,i),x0,[],[],[],[],lb,ub,[],options);
            sig(q,i)=x;
        end
    end
    si=reshape(sig',Q*I,1);
    if norm(si-si0)<tol_em
        break;
    end
    si0=si;
end
end