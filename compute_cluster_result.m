function [purity, entropy, F_class] = compute_cluster_result(cluster_true, cluster_estimated)
real_cluster.first=cluster_true{1,1}; size_rf=size(real_cluster.first,2);
real_cluster.second=cluster_true{2,1}; size_rs=size(real_cluster.second,2); 
real_cluster.third=cluster_true{2,1};  size_rt=size(real_cluster.third,2);
obtained_cluster.first=cluster_estimated{1,1}; size_of=size(obtained_cluster.first,2);
obtained_cluster.second=cluster_estimated{2,1}; size_os=size(obtained_cluster.second,2);
obtained_cluster.third=cluster_estimated{3,1}; size_ot=size(obtained_cluster.third,2);
K=size_rf+size_rs+size_rt; 
inter_ff=size([real_cluster.first,obtained_cluster.first],2)-size(unique([real_cluster.first,obtained_cluster.first]),2);
inter_fs=size([real_cluster.first,obtained_cluster.second],2)-size(unique([real_cluster.first,obtained_cluster.second]),2);
inter_ft=size([real_cluster.first,obtained_cluster.third],2)-size(unique([real_cluster.first,obtained_cluster.third]),2);
inter_sf=size([real_cluster.second,obtained_cluster.first],2)-size(unique([real_cluster.second,obtained_cluster.first]),2);
inter_ss=size([real_cluster.second,obtained_cluster.second],2)-size(unique([real_cluster.second,obtained_cluster.second]),2);
inter_st=size([real_cluster.second,obtained_cluster.third],2)-size(unique([real_cluster.second,obtained_cluster.third]),2);
inter_tf=size([real_cluster.third,obtained_cluster.first],2)-size(unique([real_cluster.third,obtained_cluster.first]),2);
inter_ts=size([real_cluster.third,obtained_cluster.second],2)-size(unique([real_cluster.third,obtained_cluster.second]),2);
inter_tt=size([real_cluster.third,obtained_cluster.third],2)-size(unique([real_cluster.third,obtained_cluster.third]),2);
a=max([inter_ff,inter_sf,inter_tf]); b=max([inter_fs,inter_ss,inter_ts]); c=max([inter_ft,inter_st,inter_tt]);
purity=(1/K)*(a+b+c);
if inter_ff==0
    log_ff=0;
else
    log_ff=log2(inter_ff/size_of);
end
if inter_fs==0
    log_fs=0;
else
    log_fs=log2(inter_fs/size_os);
end
if inter_ft==0
    log_ft=0;
else
    log_ft=log2(inter_ft/size_ot);
end
if inter_sf==0
    log_sf=0;
else
    log_sf=log2(inter_sf/size_of);
end
if inter_ss==0
    log_ss=0;
else
    log_ss=log2(inter_ss/size_os);
end
if inter_st==0
    log_st=0;
else
    log_st=log2(inter_st/size_ot);
end
if inter_tf==0
    log_tf=0;
else
    log_tf=log2(inter_tf/size_of);
end
if inter_ts==0
    log_ts=0;
else
    log_ts=log2(inter_ts/size_os);
end
if inter_tt==0
    log_tt=0;
else
    log_tt=log2(inter_tt/size_ot);
end
entropy_id_first=-1/(log2(3))*(inter_ff/size_of*log_ff+inter_sf/size_of*log_sf+inter_tf/size_of*log_tf);
entropy_id_second=-1/(log2(3))*(inter_fs/size_os*log_fs+inter_ss/size_os*log_ss+inter_ts/size_os*log_ts);
entropy_id_third=-1/(log2(3))*(inter_ft/size_ot*log_ft+inter_st/size_ot*log_st+inter_tt/size_ot*log_tt);
entropy=1/K*(size_of*entropy_id_first+size_os*entropy_id_second+size_ot*entropy_id_third);
P_ff=inter_ff/size_of;R_ff=inter_ff/size_rf;
if P_ff==0 && R_ff==0
    F_class_ff=0;
else
    F_class_ff=2*P_ff*R_ff/(P_ff+R_ff);
end
P_fs=inter_fs/size_os;R_fs=inter_fs/size_rs;
if P_fs==0 && R_fs==0
    F_class_fs=0;
else
    F_class_fs=2*P_fs*R_fs/(P_fs+R_fs);
end
P_ft=inter_ft/size_ot;R_ft=inter_ft/size_rt;
if P_ft==0 && R_ft==0
    F_class_ft=0;
else
    F_class_ft=2*P_ft*R_ft/(P_ft+R_ft);
end
P_sf=inter_sf/size_of;R_sf=inter_sf/size_rf;
if P_sf==0 && R_sf==0
    F_class_sf=0;
else
    F_class_sf=2*P_sf*R_sf/(P_sf+R_sf);
end
P_ss=inter_ss/size_os;R_ss=inter_ss/size_rs;
if P_ss==0 && R_ss==0
    F_class_ss=0;
else
    F_class_ss=2*P_ss*R_ss/(P_ss+R_ss);
end
P_st=inter_st/size_ot;R_st=inter_st/size_rt;
if P_st==0 && R_st==0
    F_class_st=0;
else
    F_class_st=2*P_st*R_st/(P_st+R_st);
end
P_tf=inter_tf/size_of;R_tf=inter_tf/size_rf;
if P_tf==0 && R_tf==0
    F_class_tf=0;
else
    F_class_tf=2*P_tf*R_tf/(P_tf+R_tf);
end
P_ts=inter_ts/size_os;R_ts=inter_ts/size_rs;
if P_ts==0 && R_ts==0
    F_class_ts=0;
else
    F_class_ts=2*P_ts*R_ts/(P_ts+R_ts);
end
P_tt=inter_tt/size_ot;R_tt=inter_tt/size_rt;
if P_tt==0 && R_tt==0
    F_class_tt=0;
else
    F_class_tt=2*P_tt*R_tt/(P_tt+R_tt);
end
F_class_first=max([F_class_ff,F_class_fs,F_class_ft]);
F_class_second=max([F_class_sf,F_class_ss,F_class_st]);
F_class_third=max([F_class_tf,F_class_ts,F_class_tt]);
F_class=1/K*(size_rf*F_class_first+size_rs*F_class_second+size_rt*F_class_third);