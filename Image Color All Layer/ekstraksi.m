function [Iw_eks, w_ex, w_be] = ekstraksi(I, MODE, num, G, nMax, T, Delta, Iw2, d_int, mask, dr)
rng(0,'twister');
N=size(I,1);
w =randi([0,1],1,num);
d_0 = (1/2-1/16)*Delta*ones(1,num); 
d_1 = d_0 + (Delta/2);

%% Reversible Extraction
% [Iw_reversible,err_info] = reversible_decodding(I, N, N, mask);

% data_2=err_info;
% [ data ] = bin_to_unsigned( data_2,8);
% xR = Arith07(data');
% d1_2 = xR{1};
% tem_length1 = length(dec2bin(max(abs(err_info))));
% [ d1 ] =  bin_to_signed( d1_2(:)',tem_length1+1);

% %% Computing dr
% [X,Y]=meshgrid(-1:(2/(N-1)):1,-1:(2/(N-1)):1);
% [~,r] = cart2pol(X,Y); 
% idx = uint8(r<=1);
% 
% for i = 1 : N
%     for j = 1 : N
%         if (idx(i, j) == 1)
%             dr = uint8(d1(1:1:size(d1,1)));
%         elseif (idx(i,j) == 0)
%             dr(i,j) = idx(i,j);
%         continue
%         end
%     end
% end

%% RObust Extraction
MMT_1=PCET_func(uint8(I),nMax);

temp_w1(1,:) = abs(MMT_1(1,:)+1i*MMT_1(2,:)); 
temp_w1(2,:)=MMT_1(1,:);
temp_w1(3,:)=MMT_1(2,:); 
temp_w1(4,:)=MMT_1(3,:); 
[Mnm_w1,ind_w1]=sortrows(temp_w1'); 
Mnm_w1 = Mnm_w1'; ind_w1 = ind_w1'; 

%% 确认嵌入的矩
moment = 0;
for k = 1 : length(Mnm_w1)
    if mod(Mnm_w1(3,k), 4) ~= 0  &&  (abs(Mnm_w1(2,k))+abs(Mnm_w1(3,k)))>=G 
        if Mnm_w1(2,k) == 0 && Mnm_w1(3,k) > 0
            moment = moment + 1;
            tem(moment)=k;
        elseif Mnm_w1(2,k) > 0
            moment = moment + 1;
            tem(moment)=k;
        end
    end
end
insert_palace = tem(1:num); 

%%
moment = 0;
for k = 1 : length(Mnm_w1)
    if ismember(k,insert_palace)
        moment = moment + 1;
        MRnm_w1(k) = (Mnm_w1(4,k)/Mnm_w1(4,1))*T(k);
        KK_2(moment)=Mnm_w1(4,k);
        MRnm_w1_j(1,k)=round((abs(MRnm_w1(k))-d_0(moment))/Delta)*Delta+d_0(moment); 
        MRnm_w1_j(2,k)=round((abs(MRnm_w1(k))-d_1(moment))/Delta)*Delta+d_1(moment); 
        if (abs(MRnm_w1(k))-abs(MRnm_w1_j(1,k)))^2 <= (abs(MRnm_w1(k))-abs(MRnm_w1_j(2,k)))^2 
            w_ex(moment) = 0;
        else
            w_ex(moment) = 1;
        end
        w_be(moment)=w(moment); 
        MRnm_re1(k) = abs(MRnm_w1(k))-d_int(moment);
        Mnm_re1(k) = abs(MRnm_re1(k)/abs(MRnm_w1(k)))*Mnm_w1(4,k);
        if MODE == 1 
            [~,col]=find(Mnm_w1(2,:)==-Mnm_w1(2,k) & Mnm_w1(3,:)==-Mnm_w1(3,k));
            Mnm_re1(col) = conj(Mnm_re1(k));
            M_4(1,k)=Mnm_w1(1,k);M_4(2,k)=Mnm_w1(2,k);M_4(3,k)=Mnm_w1(3,k);
            M_4(4,k)=Mnm_re1(k)-Mnm_w1(4,k);
            M_4(1,col)=Mnm_w1(1,col);M_4(2,col)=Mnm_w1(2,col);M_4(3,col)=Mnm_w1(3,col);
            M_4(4,col)=Mnm_re1(col)-Mnm_w1(4,col);  
        end
    end
end


%%
Irw_re1=PCET_reconstruct_func(N,M_4); %重构出中间无水印图

Irw_re1(isnan(Irw_re1))=0;
I_re_1 = round(double(real(Irw_re1)) + double(real(Iw2)));
I_re_1(I_re_1>255)=255;
I_re_1(I_re_1<0)=0;


Iw_eks = uint8(I_re_1) + dr;
end

