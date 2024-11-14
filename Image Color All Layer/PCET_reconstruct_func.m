function [im_rec] = PCET_reconstruct_func(N,Mnm)

[X,Y]=meshgrid(-1:(2/(N-1)):1,-1:(2/(N-1)):1);
[theta,r] = cart2pol(X,Y); %ֱ������ת��Ϊ������
idx = uint8(r<=1);%�޶��˼���ķ�Χ������λԲ��
R=r.^2; % ���Ƚ�r^2��������Ա����ֱ�ӵ���
im_rec=zeros(N);
for s=1:N
    for t=1:N
        H=exp(i*(2*pi*Mnm(2,:)*R(s,t) + Mnm(3,:)*theta(s,t) ));
        im_rec(s,t) = im_rec(s,t)+sum(H.*Mnm(4,:));
    end
end
im_rec=im_rec.*double(idx);%ֻȡ��λԲ�ڲ�
% im_rec=abs(im_rec);
end

