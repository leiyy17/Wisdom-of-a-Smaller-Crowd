clear;clc;system('taskkill /F /IM EXCEL.EXE');
bin=importdata('./quantile_data.xlsx');
para_data=bin.data.Sheet3;
global K; global Q;  global I;
forecast_data=para_data; forecast_data(1,:)=[];
c=forecast_data(:,1:2);
K=numel(find(forecast_data(:,1)==forecast_data(1,1) & forecast_data(:,2)==forecast_data(1,2)));
Q=4; I=8; num=8; repN=50;
result=importdata('result_error');
result_beta=result.data(11,2:K*Q+1);beta=reshape(result_beta,Q,K)';
result_sigma=result.data(11,K*Q+2:K*Q+Q*I+1);sigma=reshape(result_sigma,I,Q)';
result_mu=result.data(11,K*Q+Q*I+2:K*Q+2*Q*I+1);mu=reshape(result_mu,I,Q)';
GDP_real=[2.53 2.91 2.91 1.64 1.64 1.64 2.37 2.93];
rho_matrix_1=corrcoef(mu(1,1:8),GDP_real); rho_1=rho_matrix_1(1,2);
rho_matrix_2=corrcoef(mu(2,1:8),GDP_real); rho_2=rho_matrix_2(1,2);
rho_matrix_3=corrcoef(mu(3,1:8),GDP_real); rho_3=rho_matrix_3(1,2);
rho_matrix_4=corrcoef(mu(4,1:8),GDP_real); rho_4=rho_matrix_4(1,2);
rho_matrix_5=corrcoef(mu(5,1:8),GDP_real); rho_5=rho_matrix_5(1,2);
figure(1)
axy1=plot(mu(1,1:8),'b','linewidth',1); hold on
axy2=plot(mu(2,1:8),'g','linewidth',1); hold on
axy3=plot(mu(3,1:8),'y','linewidth',1); hold on
axy4=plot(mu(4,1:8),'color',[160 32 240]/255,'linewidth',1); hold on
axy5=plot(mu(5,1:8),'color',[255 97 0]/255,'linewidth',1); hold on
axy6=plot(GDP_real,'-r*','linewidth',1);
legend([axy1(1),axy2(1),axy3(1),axy4(1),axy5(1),axy6(1)],...
    'Mean of Cue 1','Mean of Cue 2','Mean of Cue 3','Mean of Cue 4','Mean of Cue 5',...
    'Real GDP Growth Rate','Location','SouthOutside','Orientation','horizon','NumColumns',3);
xlabel('Variables');ylabel('Cues');
figure(2)
cluster_sort=[16,4,15,17,19,1,18,2,9,11,20,3,7,13,5,6,8,10,12,14];
beta_sort=beta(cluster_sort,:);
b=bar(beta_sort,'stack');
set(b(1),'FaceColor','b')
set(b(2),'Facecolor','g')
set(b(3),'Facecolor','y')
set(b(4),'FaceColor',[160 32 240]/255)
set(b(5),'Facecolor',[255 97 0]/255)
legend('Weight on Cue 1','Weight on Cue 2','Weight on Cue 3','Weight on Cue 4','Weight on Cue 5',...
    'Location','SouthOutside','Orientation','horizon','NumColumns',3);
xlabel('Experts');ylabel('Weights');
