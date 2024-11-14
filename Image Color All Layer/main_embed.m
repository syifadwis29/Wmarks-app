clc;
clear;
%% Parameters Setting
G=9;
Delta=32;
gamma=30;

%% 256bit
MODE = 1; %RRW-PCET
nMax=20; %
num=256; %
T_init = 8500;% 


%% Images Reading
file_path =  'images\';
img_path_list = dir(strcat(file_path,'*.tif'));
img_num = length(img_path_list);

if img_num > 0 
    temp=0;
    for j =1:1
        image_name = img_path_list(j).name;
        image =  imread(strcat(file_path,image_name));
        mysize=size(image);
        N = size(image,1);
        image=imresize(uint8(image),[512 512]);
        if numel(mysize)>2
            if mysize(3) ==3
                red = image(:,:,1);
                green = image(:,:,2);
                blue = image(:,:,3);
            else
                image=rgb2gray(image); 
            end
        end
          
       %% Embedding Process %%
       temp=temp+1;
       [ Iw_reversibler, Tr, Iw2r, d_intr, dq_betar, maskr, w_exr, w_be, drr]...
           = PHT_version(red, MODE, nMax, Delta, num, T_init , gamma, G);     
                
       temp=temp+1;
       [ Iw_reversibleg, Tg, Iw2g, d_intg, dq_betag, maskg, w_exg, w_be, drg]...
           = PHT_version(green, MODE, nMax, Delta, num, T_init , gamma, G);

       temp=temp+1;
       [ Iw_reversibleb, Tb, Iw2b, d_intb, dq_betab, maskb, w_exb, w_be, drb]...
           = PHT_version(blue, MODE, nMax, Delta, num, T_init , gamma, G);
                   
       Card(temp,:) = [j;T_init ];

       % PSNR Robust Embedding
       Iw2 = cat(3, Iw2r, Iw2g, Iw2b);
       psnr_ro_em = psnr(image,uint8(Iw2))

       % PSNR Reversible Embedding
       Iw_reversible = cat(3, Iw_reversibler, Iw_reversibleg, Iw_reversibleb);
       psnr_em = psnr(image,uint8(Iw_reversible))
       imwrite(uint8(Iw_reversible),'Iw_reversible.jpg')

       % BER tanpa attack
       BER = sum(abs(w_be-w_exr) +  abs(w_be-w_exg) + abs(w_be-w_exb));
       BER_em = BER/length(w_be);
       display(BER_em,'BER_em');

       [Iw_reversible] = attack(Iw_reversible);

       red_em = Iw_reversible(:,:,1);
       green_em = Iw_reversible(:,:,2);
       blue_em = Iw_reversible(:,:,3);   


       %% Extraction Process %%
       % Red
       temp=temp+1;
       [Iw_eksr, w_exr, w_be]...
          = ekstraksi(red_em, MODE, num, G, nMax, Tr, Delta, Iw2r, d_intr, maskr, drr);
       % Green
       temp=temp+1;
       [Iw_eksg, w_exg, w_be]...
           = ekstraksi(green_em, MODE, num, G, nMax, Tg, Delta, Iw2g, d_intg, maskg, drg);
       % Blue
       temp=temp+1;
       [Iw_eksb, w_exb, w_be]...
           = ekstraksi(blue_em, MODE, num, G, nMax, Tb, Delta, Iw2b, d_intb, maskb, drb);

       % PSNR Reversible Extraction
       % Iw_eks_re = cat(3, Iw_1r, Iw_1g, Iw_1b);
       % psnr_eks_re = psnr(image, uint8(Iw_eks_re))

       % PSNR Robust Extraction
       Iw_eks_ro =  cat(3,Iw_eksr,Iw_eksg,Iw_eksb);
       imwrite(uint8(Iw_eks_ro),'Iw_recovery.jpg');
       psnr_eks = psnr(image,uint8(Iw_eks_ro))
       
       ter = abs(sum(w_be-w_exr));
       BER_attack_red = ter/length(w_be);
       display(BER_attack_red,'BER_attack_red');

       teg = abs(sum(w_be-w_exg));
       BER_attack_green = teg/length(w_be);
       display(BER_attack_green,'BER_attack_green');

       teb = abs(sum(w_be-w_exb));
       BER_attack_blue = teb/length(w_be);
       display(BER_attack_blue,'BER_attack_blue');
       
       %% BER
       for k=1:num
           te(k) = sum(w_exr(k) + w_exg(k) + w_exb(k));
           te(k) = te(k)/3;
           if te(k) >= 0.5
               w(k) = 1;
           else 
               w(k) = 0;
           end
       end

       te = abs(sum(w_be-w)); 
       ber = te/num;
       fprintf('%.4f\n', ber) 

       %% cara paper
       % Xu, et all (2018)
       % BER_attack = te/length(w_be);
       % display(BER_attack,'BER_try2');

       % BERR = sum(abs(BER_attack_red)+abs(BER_attack_green)+abs(BER_attack_blue)); % langsung dirata"kan 
       % BER_try = BERR/3;
       % display(BER_try,'BER_try3');

       %%
       % for k=1:num
       %     BEr = sum(abs(xor(w_exr(k),w_be(k)))+abs(xor(w_be(k),w_exg(k)))+abs(xor(w_be(k),w_exb(k)))); % Shen, et all (2007)           
       % end
       % ber = BEr/length(w_be);
       % display(ber,'BER_try4');
       % 
       % BEr = sum(abs(xor(w_exr,w_be))+abs(xor(w_be,w_exg))+abs(xor(w_be,w_exb))); % Shen, et all (2007)           
       % ber = BEr/length(w_be);
       % display(ber,'BER_try4');


       
       % te = sum(abs(w_be-w_exr)+abs(w_be-w_exg)+abs(w_be-w_exb)); % Xu, et all (2018)
       % BER_attack = te/N*N;
       % display(BER_attack,'BER_try 5')

       toc;
    end
end
