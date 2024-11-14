function MMT=PCET_func(img,T)

% ��ͼ������ת����[-1 1]*[-1 1]֮��
N=size(img,1);
% x=0:(N-1);
% X=x/(N/2)-1;
% Y=x/(N/2)-1;
[X,Y]=meshgrid(-1:(2/(N-1)):1,-1:(2/(N-1)):1);

% ��ȡ��λԲ�ڵ�ͼ��img2
% [XX,YY]=meshgrid(-1:(2/(N-1)):1,-1:(2/(N-1)):1);
[theta,r] = cart2pol(X,Y); %ֱ������ת��Ϊ������
idx = uint8(r<=1);%�޶��˼���ķ�Χ������λԲ��
img2=img.*idx;
% figure,imshow(img2)

% �趨����(order)n���ظ���(repetition)l��ȡֵ��Χ
num=0;
for n=-T:T %����
    for l=-T:T % �ظ���
        if abs(n)+abs(l)<=T
            num=num+1;
            MMT(:,num)=[n;l]; %NL��һ�б�ʾ�������ڶ��б�ʾ�ظ���
        end
    end
end

%�������PCET��
MMT(3,:)=0;
R=r.^2; % ���Ƚ�r^2��������Ա����ֱ�ӵ���
MMT=complex(MMT);
for k=1:size(MMT,2)
    H=exp(i*( 2*pi*MMT(1,k).*R + MMT(2,k).*theta));
    MMT(3,k)=sum(sum( conj(H).*double(img2).*double(idx) )); 
    %------------------����һ��Ϊѭ���ı��������Ƚ���------------------------
    %     for s=1:N
    %         for t=1:N
    %             if idx(s,t)~=0
    %                 f=img2(s,t); % ���ػҶ�ֵ
    %                 H=exp(i*( 2*pi*MMT(1,k)*R(s,t) + MMT(2,k)*theta(s,t) ));
    %                 MMT(3,k) = MMT(3,k)+conj(H)*double(f);
    %             end
    %         end
    %     end
    %-----------------------------------����������------------------------------
end
MMT(3,:)=MMT(3,:)*4/(pi*N^2); % �����PCET��
MMT_real=abs(MMT);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ͼ���ع�
% 
% im_rec=zeros(N);
% for s=1:N
%     for t=1:N
%         H=exp(i*( 2*pi*MMT(1,:)*R(s,t) + MMT(2,:)*theta(s,t) ));
%         im_rec(s,t) = im_rec(s,t)+sum( H.*MMT(3,:));
%         %------------------����һ��Ϊѭ���ı��������Ƚ���------------------------
%         %         for k=1:size(MMT,2)
%         %             H=exp(i*( 2*pi*MMT(1,k)*R(s,t) + MMT(2,k)*theta(s,t) ));
%         %             im_rec(s,t) = im_rec(s,t)+H*MMT(3,k);
%         %         end
%         %-----------------------------------����������--------------------------
%     end
% end
% 
% im_rec=im_rec.*double(idx);%ֻȡ��λԲ�ڲ�
% figure,imshow(uint8((abs(im_rec))))