function [ Iw_reversible, T, Iw2, d_int, dq_beta, mask, w_ex, w_be, dr]= PHT_version(I, MODE, nMax, Delta, num, T_init, gamma, G)
tic;
rng(0,'twister');
%% Initialize
N=size(I,1);
w =randi([0,1],1,num); 
d_0 = (1/2-1/16)*Delta*ones(1,num); 
d_1 = d_0 + (Delta/2);
%% Calculate PHT momment

MMT=PCET_func(I,nMax);

%% 首先确认水印嵌入顺序
temp(1,:) = abs(MMT(1,:)+1i*MMT(2,:)); 
temp(2,:)=MMT(1,:); 
temp(3,:)=MMT(2,:); 
temp(4,:)=MMT(3,:); 
[Mnm,ind]=sortrows(temp'); 
Mnm = Mnm'; ind = ind'; 
for k = 1 : length(Mnm)
    if mod(Mnm(3,k), 4) ~= 0
        T(k) = T_init-Mnm(1,k)*gamma;
    end
end 
%% 确认嵌入的矩
moment = 0;
for k = 1 : length(Mnm)
    if mod(Mnm(3,k), 4) ~= 0  &&  (abs(Mnm(2,k))+abs(Mnm(3,k)))>=G 
        if Mnm(2,k) == 0 && Mnm(3,k) > 0
            moment = moment + 1;
            tem(moment)=k;
        elseif Mnm(2,k) > 0
            moment = moment + 1;
            tem(moment)=k;
        end
    end
end
insert_palace = tem(1:num); 
%% 水印嵌入
moment = 0;
for k = 1 : length(Mnm)
    if ismember(k,insert_palace)
        moment = moment + 1;
        MRnm(k)=(Mnm(4,k)/Mnm(4,1))*T(k);
        MRnm_j(1,k)=round((abs(MRnm(k))-d_0(moment))/Delta)*Delta+d_0(moment); 
        MRnm_j(2,k)=round((abs(MRnm(k))-d_1(moment))/Delta)*Delta+d_1(moment); 
        d_int(moment)  = round(abs(MRnm_j(w(moment)+1,k))-abs(MRnm(k)));
        dec_R(moment) = abs(MRnm_j(w(moment)+1,k))-abs(MRnm(k)) - d_int(moment);
        MRw(k) = abs(MRnm_j(w(moment)+1,k)) - dec_R(moment);
        Mw(k) = (abs(MRw(k))/abs(MRnm(k)))*Mnm(4,k);
        if MODE == 1
            [~,col]=find(Mnm(2,:)==-Mnm(2,k) & Mnm(3,:)==-Mnm(3,k));
            Mw(col) = conj(Mw(k));
            M_1(1,k)=Mnm(1,k);M_1(2,k)=Mnm(2,k);M_1(3,k)=Mnm(3,k);
            M_1(4,k)=Mw(k)-Mnm(4,k);
            M_1(1,col)=Mnm(1,col);M_1(2,col)=Mnm(2,col);M_1(3,col)=Mnm(3,col);
            M_1(4,col)=Mw(col)-Mnm(4,col); % The watermark is embedded in the changed moment, which is then reconstructed
        end
    end
end

Irw1=PCET_reconstruct_func(N,M_1); %rekonstruksi gambar

Irw1(isnan(Irw1))=0; 
Iw2 = round(double(I) + Irw1);
Iw2(Iw2>255)=255;
Iw2(Iw2<0)=0;


% %% 
MMT_2=PCET_func(uint8(Iw2),nMax);

temp_w2(1,:) = abs(MMT_2(1,:)+1i*MMT_2(2,:)); 
temp_w2(2,:)=MMT_2(1,:);
temp_w2(3,:)=MMT_2(2,:); 
temp_w2(4,:)=MMT_2(3,:); 
[Mnm_w2,ind_w2]=sortrows(temp_w2'); 
Mnm_w2 = Mnm_w2'; ind_w2 = ind_w2'; 

%% 
moment = 0;
for k = 1 : length(Mnm_w2)
    if ismember(k,insert_palace)
        moment = moment + 1;
        MRnm_w(k) = (Mnm_w2(4,k)/Mnm_w2(4,1))*T(k);
        KK_2(moment)=Mnm_w2(4,k); 
        MRnm_w_j(1,k)=round((abs(MRnm_w(k))-d_0(moment))/Delta)*Delta+d_0(moment); 
        MRnm_w_j(2,k)=round((abs(MRnm_w(k))-d_1(moment))/Delta)*Delta+d_1(moment); 
        if (abs(MRnm_w(k))-abs(MRnm_w_j(1,k)))^2 <= (abs(MRnm_w(k))-abs(MRnm_w_j(2,k)))^2 
            w_ex(moment) = 0;
        else
            w_ex(moment) = 1;
        end
        w_be(moment)=w(moment); 
        MRnm_re(k) = abs(MRnm_w(k))-d_int(moment);
        Mnm_re(k) = abs(MRnm_re(k)/abs(MRnm_w(k)))*Mnm_w2(4,k);
        if MODE == 1 
            [~,col]=find(Mnm_w2(2,:)==-Mnm_w2(2,k) & Mnm_w2(3,:)==-Mnm_w2(3,k));
            Mnm_re(col) = conj(Mnm_re(k));
            M_3(1,k)=Mnm_w2(1,k);M_3(2,k)=Mnm_w2(2,k);M_3(3,k)=Mnm_w2(3,k);
            M_3(4,k)=Mnm_re(k)-Mnm_w2(4,k);
            M_3(1,col)=Mnm_w2(1,col);M_3(2,col)=Mnm_w2(2,col);M_3(3,col)=Mnm_w2(3,col);
            M_3(4,col)=Mnm_re(col)-Mnm_w2(4,col); 
        end
    end
end

%% Watermark-Removed Image Generation
if MODE==1
    Irw_re=PCET_reconstruct_func(N,M_3); %重构出中间无水印图像 
end
Irw_re(isnan(Irw_re))=0;
I_re = round(Irw_re + Iw2);
I_re(I_re>255)=255;
I_re(I_re<0)=0;

%%  Computing dr
[X,Y]=meshgrid(-1:(2/(N-1)):1,-1:(2/(N-1)):1);
[~,r] = cart2pol(X,Y); 
idx = uint8(r<=1);

temp = 0;
for i = 1 : N
    for j = 1 : N
        if (idx(i, j) == 1)
            temp = temp + 1;
            err_incircle(temp) = uint8(I_re(i,j))-I(i,j);
            continue
        end
    end
end
% % % Encode
tem_length1 = length(dec2bin(max(abs(err_incircle))));
[ dq_1 ] = signed_to_bin(err_incircle,tem_length1+1);
dq_C = cell(1,1);
dq_C{1} = dq_1;
dq_data = Arith07(dq_C);
[ dq_D ] = unsigned_to_bin( dq_data,8 );
dq_beta=dq_D;

% Decode
data_2=dq_beta;
[ data ] = bin_to_unsigned( data_2,8);
xR = Arith07(data');
d1_2 = xR{1};
[ d1 ] =  bin_to_signed( d1_2(:)',tem_length1+1);

%% Reversible Embedding Stage
xstep = 2/(N-1);
ystep = 2/(N-1);
[X,Y] = meshgrid(-1:xstep:1, 1:-ystep:-1);
[theta,rho] = cart2pol(X, Y);
inside = find(rho<=1);
mask = zeros(N,N);
mask(inside) = ones(size(inside));

err = dq_beta;
err=logical(err);
[Iw_reversible, ~, Ok, ~, ~, ~, ~, ~, ~] ...
        = reversible_embedding(Iw2, err, N, N, mask);

% Computing dr
[X,Y]=meshgrid(-1:(2/(N-1)):1,-1:(2/(N-1)):1);
[~,r] = cart2pol(X,Y); 
idx = uint8(r<=1);

for i = 1 : N
    for j = 1 : N
        if (idx(i, j) == 1)
            dr(i,j) = uint8(I(i,j)-I_re(i,j));
        elseif (idx(i,j) == 0)
            dr(i,j) = idx(i,j);
            continue
        end
    end
end

