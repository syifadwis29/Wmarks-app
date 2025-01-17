classdef utama2_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        WmarksUIFigure       matlab.ui.Figure
        AboutUsButton        matlab.ui.control.Button
        Image3               matlab.ui.control.Image
        SaveImageButton      matlab.ui.control.Button
        Panel_2              matlab.ui.container.Panel
        BrowseImageButton_2  matlab.ui.control.Button
        ExtractionButton     matlab.ui.control.Button
        EkstraksiDropDown    matlab.ui.control.DropDown
        AttackButton         matlab.ui.control.Button
        Panel                matlab.ui.container.Panel
        BrowseImageButton    matlab.ui.control.Button
        EmbeddingDropDown    matlab.ui.control.DropDown
        EmbeddingButton      matlab.ui.control.Button
        Image                matlab.ui.control.Image
        GuideButton          matlab.ui.control.Button
        Wmarks10Label        matlab.ui.control.Label
        Image2_2             matlab.ui.control.Image
        UIAxes2              matlab.ui.control.UIAxes
        UIAxes               matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: BrowseImageButton
        function BrowseImageButtonPushed(app, event)
        % global image1;
        %      [file, path] = uigetfile({'*.*'},"Chose Image");
        % 
        % image1 = imread(fullfile(path, file));
        % imshow(image1, 'Parent', app.UIAxes);
global image1;

[file, path] = uigetfile({'*.*'}, "Choose Image");

if isequal(file, 0) || isequal(path, 0)
    % User didn't select a file
    warndlg('No image selected. Please choose an image.', 'Warning');
    % Optionally, you can clear the axes or set a default image
    cla(app.UIAxes);
    
else
    % User selected a file
    try
        image1 = imread(fullfile(path, file));
        imshow(image1, 'Parent', app.UIAxes);
      
    catch
        % In case there's an error reading the file
        errordlg('Error loading the image. Please try again.', 'Error');
        cla(app.UIAxes);
       
    end
end
        end

        % Button pushed function: GuideButton
        function GuideButtonPushed(app, event)
     
    d = dialog('Position',[600 600 500 300],'Name','Guide');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[40 160 420 80],...
               'FontSize', 11,...
               'String','Wmarks is a digital image watermarking application. This software allows you to embed and extract watermarks using various PHT (Polar Harmonic Transform) methods.');
                

    btn = uicontrol('Parent',d,...
               'Position',[210 40 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');


            
        end

        % Button pushed function: EmbeddingButton
        function EmbeddingButtonPushed(app, event)

    global image1
    global images
    global image2

    switch app.EmbeddingDropDown.Value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                case 'PHT LQIM'
                    % Show progress dialog
    progressDlg = uiprogressdlg(app.WmarksUIFigure, 'Title', 'Embedding...', 'Indeterminate', 'on');

    % Resize and preprocess the image
    images = imresize(uint8(image1), [512, 512]);
    mysize = size(images);

    if numel(mysize) > 2
        if mysize(3) == 2
            images = images(:,:,1);
        else
            images = rgb2gray(images);
        end
    end

    % Ensure the image is 256x256 if it isn't 512x512
    [image_Rows, image_Cols] = size(images);
    if image_Rows ~= 512 || image_Cols ~= 512
        images = imresize(uint8(images), [256, 256]);
    end

    % Parameters Setting
    G = 9;
    Delta = 32;
    gamma = 30;
    MODE = 1; % RRW-PCET
    N = 22;
    num = 256;
    T_init = 8500;

    % Embed watermark
    % Embed watermark
    [psnr1, BER_no_attack] = PHT_version2(images, MODE, N, Delta, num, T_init, gamma, G);

    

    image2 =  imread('embed.bmp');
    imshow(image2, 'Parent', app.UIAxes2);
    progressDlg.Value = 1;
    close(progressDlg);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case 'PHT MSS'

                    % Show progress dialog
    progressDlg = uiprogressdlg(app.WmarksUIFigure, 'Title', 'Embedding...', 'Indeterminate', 'on');

    % Resize and preprocess the image
    images = imresize(uint8(image1), [512, 512]);
    mysize = size(images);

    if numel(mysize) > 2
        if mysize(3) == 2
            images = images(:,:,1);
        else
            images = rgb2gray(images);
        end
    end

    % Ensure the image is 256x256 if it isn't 512x512
    [image_Rows, image_Cols] = size(images);
    if image_Rows ~= 512 || image_Cols ~= 512
        images = imresize(uint8(images), [256, 256]);
    end

    % Parameters Setting
    G = 5;
    Delta = 32;
    gamma = 30;
    MODE = 1; % RRW-PCET
    N = 20;
    num = 256;
    T_init = 8500;
    
    % Embed watermark
    [psnr1, BER_no_attack] = PHT_version2(images, MODE, N, Delta, num, T_init, gamma, G);

    

    image2 =  imread('embed.bmp');
    imshow(image2, 'Parent', app.UIAxes2);
    progressDlg.Value = 1;
    close(progressDlg);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                case 'PHT DCQIM'
    % Show progress dialog
    progressDlg = uiprogressdlg(app.WmarksUIFigure, 'Title', 'Embedding...', 'Indeterminate', 'on');

    % Resize and preprocess the image
    images = imresize(uint8(image1), [512, 512]);
    mysize = size(images);

    if numel(mysize) > 2
        if mysize(3) == 2
            images = images(:,:,1);
        else
            images = rgb2gray(images);
        end
    end

    % Ensure the image is 256x256 if it isn't 512x512
    [image_Rows, image_Cols] = size(images);
    if image_Rows ~= 512 || image_Cols ~= 512
        images = imresize(uint8(images), [256, 256]);
    end

    % Parameters Setting
    G = 3;
    Delta = 32;
    gamma = 30;
    MODE = 1; % RRW-PCET
    N = 24;
    num = 256;
    T_init = 8500;
    % Embed watermark
    [psnr1, BER_no_attack] = PHT_version2(images, MODE, N, Delta, num, T_init, gamma, G);

    

    image2 =  imread('embed.bmp');
    imshow(image2, 'Parent', app.UIAxes2);
    progressDlg.Value = 1;
    close(progressDlg);
                    
            
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% backup
    % % Show progress dialog
    % progressDlg = uiprogressdlg(app.WmarksUIFigure, 'Title', 'Embedding...', 'Indeterminate', 'on');
    % 
    % % Resize and preprocess the image
    % images = imresize(uint8(image1), [512, 512]);
    % mysize = size(images);
    % 
    % if numel(mysize) > 2
    %     if mysize(3) == 2
    %         images = images(:,:,1);
    %     else
    %         images = rgb2gray(images);
    %     end
    % end
    % 
    % % Ensure the image is 256x256 if it isn't 512x512
    % [image_Rows, image_Cols] = size(images);
    % if image_Rows ~= 512 || image_Cols ~= 512
    %     images = imresize(uint8(images), [256, 256]);
    % end
    % 
    % % Parameters Setting
    % G = 9;
    % Delta = 32;
    % gamma = 30;
    % MODE = 1; % RRW-PCET
    % N = 20;
    % num = 256;
    % T_init = 8500;
    % 
    % % Embed watermark
    % % Embed watermark
    % [psnr1, BER_no_attack] = PHT_version2(images, MODE, N, Delta, num, T_init, gamma, G);
    % 
    % 
    % 
    % image2 =  imread('embed.bmp');
    % imshow(image2, 'Parent', app.UIAxes2);
    % progressDlg.Value = 1;
    % close(progressDlg);
        end

        % Button pushed function: ExtractionButton
        function ExtractionButtonPushed(app, event)
    global image1
    global images
    global image2

    % Show progress dialog
    progressDlg = uiprogressdlg(app.WmarksUIFigure, 'Title', 'Embedding...', 'Indeterminate', 'on');

    % Resize and preprocess the image
    images = imresize(uint8(image1), [512, 512]);
    mysize = size(images);

    if numel(mysize) > 2
        if mysize(3) == 2
            images = images(:,:,1);
        else
            images = rgb2gray(images);
        end
    end

    % Ensure the image is 256x256 if it isn't 512x512
    [image_Rows, image_Cols] = size(images);
    if image_Rows ~= 512 || image_Cols ~= 512
        images = imresize(uint8(images), [256, 256]);
    end

    % Parameters Setting
    G = 9;
    Delta = 32;
    gamma = 30;
    MODE = 1; % RRW-PCET
    N = 20;
    num = 256;
    T_init = 8500;

    % Embed watermark and extract the unwatermarked image
    [psnr1,  BER_no_attack]= PHT_versionoriginal(images, MODE, N, Delta, num, T_init, gamma, G);

    
    image2 =  imread('recovery.bmp');
    % image2 =  imread('Removed_Watermark');
    imshow(image2, 'Parent', app.UIAxes2);
    progressDlg.Value = 1;
    close(progressDlg);
        end

        % Button pushed function: SaveImageButton
        function SaveImageButtonPushed(app, event)
              global image2
            [file, path] = uiputfile({'*.png', 'PNG Files (*.png)'; '*.bmp', 'BMP Files (*.bmp)'; '*.jpg', 'JPEG Files (*.jpg)'}, 'Save Watermarked Image');
            if ischar(file) && ischar(path)
                imwrite(image2, fullfile(path, file));
            end
        end

        % Button pushed function: AttackButton
        function AttackButtonPushed(app, event)
% Show progress dialog
progressDlg = uiprogressdlg(app.WmarksUIFigure, 'Title', 'Attacking...', 'Indeterminate', 'on');

img_watermarked = imread('embed.bmp');

% Apply JPEG compression
imwrite(img_watermarked, 'jpeg_compressed_image.jpg', 'jpg', 'Quality', 50);
img_jpeg = imread('jpeg_compressed_image.jpg');

% Apply JPEG2000 compression
imwrite(img_watermarked, 'jpeg2000_compressed_image.jp2', 'jp2', 'CompressionRatio', 20);
img_jpeg2000 = imread('jpeg2000_compressed_image.jp2');

% Add Gaussian noise
img_noisy = imnoise(img_watermarked, 'gaussian', 0, 0.1);

% Apply Gaussian filtering
img_gaussian = imgaussfilt(img_noisy, 3);

% Apply median filtering
img_median = medfilt2(img_noisy, [3 3]);

% Apply Wiener filtering
img_wiener = wiener2(img_noisy, [3 3]);

% Apply averaging filtering
h = fspecial('average', 3);
img_average = imfilter(img_noisy, h, 'replicate');

% Add salt and pepper noise
img_salt_pepper = imnoise(img_watermarked, 'salt & pepper', 0.05);

% Add speckle noise
img_speckle = imnoise(img_watermarked, 'speckle', 0.05);

% Apply histogram equalization
img_he = histeq(img_watermarked);

% Apply sharpening
img_sharpen = imsharpen(img_watermarked, 'amount', 0.5);

% Calculate PSNR
psnr_jpeg = psnr(img_watermarked, img_jpeg);
psnr_jpeg2000 = psnr(img_watermarked, img_jpeg2000);
psnr_gaussian = psnr(img_watermarked, img_gaussian);
psnr_median = psnr(img_watermarked, img_median);
psnr_wiener = psnr(img_watermarked, img_wiener);
psnr_average = psnr(img_watermarked, img_average);
psnr_salt_pepper = psnr(img_watermarked, img_salt_pepper);
psnr_speckle = psnr(img_watermarked, img_speckle);
psnr_he = psnr(img_watermarked, img_he);
psnr_sharpen = psnr(img_watermarked, img_sharpen);

[height, width] = size(img_watermarked);

ber_jpeg = ber_calc(double(img_watermarked) > 127, double(img_jpeg) > 127, height, width);
ber_jpeg2000 = ber_calc(double(img_watermarked) > 127, double(img_jpeg2000) > 127, height, width);
ber_gaussian = ber_calc(double(img_watermarked) > 127, double(img_gaussian) > 127, height, width);
ber_median = ber_calc(double(img_watermarked) > 127, double(img_median) > 127, height, width);
ber_wiener = ber_calc(double(img_watermarked) > 127, double(img_wiener) > 127, height, width);
ber_average = ber_calc(double(img_watermarked) > 127, double(img_average) > 127, height, width);
ber_salt_pepper = ber_calc(double(img_watermarked) > 127, double(img_salt_pepper) > 127, height, width);
ber_speckle = ber_calc(double(img_watermarked) > 127, double(img_speckle) > 127, height, width);
ber_he = ber_calc(double(img_watermarked) > 127, double(img_he) > 127, height, width);
ber_sharpen = ber_calc(double(img_watermarked) > 127, double(img_sharpen) > 127, height, width);

% Define the BER function
function ber = ber_calc(watermark, img, height, width)
    % Calculate the number of error bits
    error_bits = sum(sum(xor(watermark, img)));
    
    % Calculate the BER
    ber = error_bits / (height * width);
end

fprintf('BER (JPEG): %f\n', ber_jpeg);
fprintf('BER (JPEG2000): %f\n', ber_jpeg2000);
fprintf('BER (Gaussian): %f\n', ber_gaussian);
fprintf('BER (Median): %f\n', ber_median);
fprintf('BER (Wiener): %f\n', ber_wiener);
fprintf('BER (Averaging): %f\n', ber_average);

% figure("Name","Attack Result", 'NumberTitle', 'off');
% subplot(4, 3, 1); imshow(img_jpeg); 
% title(sprintf('JPEG QF=50%%\nPSNR: %.2f\nBER: %.2f', psnr_jpeg, ber_jpeg));
% subplot(4, 3, 2); imshow(img_jpeg2000); 
% title(sprintf('JPEG2000 CR=20\nPSNR: %.2f\nBER: %.2f', psnr_jpeg2000, ber_jpeg2000));
% subplot(4, 3, 3); imshow(img_gaussian); 
% title(sprintf('Gaussian Filter 3x3\nPSNR: %.2f\nBER: %.2f', psnr_gaussian, ber_gaussian));
% subplot(4, 3, 4); imshow(img_median); 
% title(sprintf('Median Filter 3x3\nPSNR: %.2f\nBER: %.2f', psnr_median, ber_median));
% subplot(4, 3, 5); imshow(img_wiener); 
% title(sprintf('Wiener Filter 3x3\nPSNR: %.2f\nBER: %.2f', psnr_wiener, ber_wiener));
% subplot(4, 3, 6); imshow(img_average); 
% title(sprintf('Average Filter\nPSNR: %.2f\nBER: %.2f', psnr_average, ber_average)); 
% subplot(4, 3, 7); imshow(img_salt_pepper); 
% title(sprintf('Salt and Pepper 0.05\nPSNR: %.2f\nBER: %.2f', psnr_salt_pepper, ber_salt_pepper));
% subplot(4, 3, 8); imshow(img_speckle); 
% title(sprintf('Speckle 0.05\nPSNR: %.2f\nBER: %.2f', psnr_speckle, ber_speckle));
% subplot(4, 3, 9); imshow(img_he); 
% title(sprintf('Histogram Equalization\nPSNR: %.2f\nBER: %.2f', psnr_he, ber_he));
% subplot(4, 3, 10); imshow(img_sharpen); 
% title(sprintf('Sharpen 0.5\nPSNR: %.2f\nBER: %.2f', psnr_sharpen, ber_sharpen));
% 
% progressDlg.Value = 1;
% close(progressDlg);

figure("Name", "Attack Result", 'NumberTitle', 'off', 'Position', [100, 100, 1200, 900]);

% Adjust subplot spacing
subplot_handle = subplot(4, 3, 1);
p = get(subplot_handle, 'Position');
p(3) = p(3) * 0.9;  % Reduce width by 10%
p(4) = p(4) * 0.9;  % Reduce height by 10%
set(subplot_handle, 'Position', p);

% Plot results
subplot(4, 3, 1); imshow(img_jpeg); 
title(sprintf('JPEG qf=50%%\nPSNR: %.2f\nBER: %.2f', psnr_jpeg, ber_jpeg));
subplot(4, 3, 2); imshow(img_jpeg2000); 
title(sprintf('JPEG2000 CR=20\nPSNR: %.2f\nBER: %.2f', psnr_jpeg2000, ber_jpeg2000));
subplot(4, 3, 3); imshow(img_gaussian); 
title(sprintf('Gaussian Filter 3x3\nPSNR: %.2f\nBER: %.2f', psnr_gaussian, ber_gaussian));
subplot(4, 3, 4); imshow(img_median); 
title(sprintf('Median Filter 3x3\nPSNR: %.2f\nBER: %.2f', psnr_median, ber_median));
subplot(4, 3, 5); imshow(img_wiener); 
title(sprintf('Wiener Filter 3x3\nPSNR: %.2f\nBER: %.2f', psnr_wiener, ber_wiener));
subplot(4, 3, 6); imshow(img_average); 
title(sprintf('Average Filter\nPSNR: %.2f\nBER: %.2f', psnr_average, ber_average)); 
subplot(4, 3, 7); imshow(img_salt_pepper); 
title(sprintf('Salt and Pepper 0.05\nPSNR: %.2f\nBER: %.2f', psnr_salt_pepper, ber_salt_pepper));
subplot(4, 3, 8); imshow(img_speckle); 
title(sprintf('Speckle 0.05\nPSNR: %.2f\nBER: %.2f', psnr_speckle, ber_speckle));
subplot(4, 3, 9); imshow(img_he); 
title(sprintf('Histogram Equalization\nPSNR: %.2f\nBER: %.2f', psnr_he, ber_he));
subplot(4, 3, 10); imshow(img_sharpen); 
title(sprintf('Sharpen 0.5\nPSNR: %.2f\nBER: %.2f', psnr_sharpen, ber_sharpen));

% Adjust font size for all subplots
ax = findobj(gcf, 'type', 'axes');
set(ax, 'FontSize', 10);

progressDlg.Value = 1;
close(progressDlg);
        end

        % Button pushed function: BrowseImageButton_2
        function BrowseImageButton_2Pushed(app, event)
        % global image1;
        % [file, path] = uigetfile({'*.*'},"Chose Image");
        % 
        % image1 = imread(fullfile(path, file));
        % imshow(image1, 'Parent', app.UIAxes);
global image1;

[file, path] = uigetfile({'*.*'}, "Choose Image");

if isequal(file, 0) || isequal(path, 0)
    % User didn't select a file
    warndlg('No image selected. Please choose an image.', 'Warning');
    % Optionally, you can clear the axes or set a default image
    cla(app.UIAxes);
    
else
    % User selected a file
    try
        image1 = imread(fullfile(path, file));
        imshow(image1, 'Parent', app.UIAxes);
      
    catch
        % In case there's an error reading the file
        errordlg('Error loading the image. Please try again.', 'Error');
        cla(app.UIAxes);
       
    end
end
        end

        % Button pushed function: AboutUsButton
        function AboutUsButtonPushed(app, event)
  
d = dialog('Position',[600 600 500 400],'Name','About Us');

% Title string
title_string = "ROBUST REVERSIBLE WATERMARKING IN TWO STAGES ON DIGITAL IMAGES";

% Team information string
team_string = sprintf("\nTeam:");
team_members = {
    "Afi Athallah Syamsulhadi Putra / 1101204066"
    "Lulu Balqis Zianka Faza / 1101200196"
    "Mirza Alifia Hanum / 1101204296"
    "Nurafifah Annida / 1101202549"
    "Syifa Dwi Sulistyowati / 1101204456"
};
team_advisor = {
    "Advisor:"
    "Ledya Novamizanti, S.Si., M.T. / 10830054"
    "Dr. Gelar Budiman, S.T,M.T. / 1101200196"
};
team_string = [team_string sprintf("%s\n", team_members{:})];
team_string = [team_string sprintf("%s\n", team_advisor{:})];

% Create title text control (centered)
title_txt = uicontrol('Parent', d, ...
    'Style', 'text', ...
    'Position', [40 320 420 60], ... % Adjust position and size as needed
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'String', title_string, ...
    'HorizontalAlignment', 'center', ...
    'Max', 2, ... % Allow multiple lines
    'Min', 0);

% Create team information text control (left-aligned)
team_txt = uicontrol('Parent', d, ...
    'Style', 'text', ...
    'Position', [40 20 420 300], ... % Adjust position and size as needed
    'FontSize', 12, ...
    'String', team_string, ...
    'HorizontalAlignment', 'left', ...
    'Max', 20, ... % Allow multiple lines
    'Min', 0, ...
    'Enable', 'inactive'); % Make the text box read-only

    btn = uicontrol('Parent',d,...
               'Position',[210 40 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create WmarksUIFigure and hide until all components are created
            app.WmarksUIFigure = uifigure('Visible', 'off');
            colormap(app.WmarksUIFigure, 'gray');
            app.WmarksUIFigure.Position = [100 100 1024 600];
            app.WmarksUIFigure.Name = 'Wmarks';
            app.WmarksUIFigure.Icon = fullfile(pathToMLAPP, 'Wmarks icon.png');
            app.WmarksUIFigure.Resize = 'off';

            % Create UIAxes
            app.UIAxes = uiaxes(app.WmarksUIFigure);
            title(app.UIAxes, 'Host Image')
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            app.UIAxes.ZTick = [];
            app.UIAxes.LineWidth = 0.1;
            app.UIAxes.Box = 'on';
            colormap(app.UIAxes, 'gray')
            app.UIAxes.Position = [140 105 301 261];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.WmarksUIFigure);
            title(app.UIAxes2, 'Result Image')
            app.UIAxes2.FontWeight = 'bold';
            app.UIAxes2.XTick = [];
            app.UIAxes2.XTickLabel = '';
            app.UIAxes2.YTick = [];
            app.UIAxes2.YTickLabel = '';
            app.UIAxes2.Box = 'on';
            app.UIAxes2.Position = [569 105 312 268];

            % Create Image2_2
            app.Image2_2 = uiimage(app.WmarksUIFigure);
            app.Image2_2.Position = [1 -20 149 76];
            app.Image2_2.ImageSource = fullfile(pathToMLAPP, 'toppng.com-white-vevo-png-thumbnail-clipart-freeuse-stock-vevo-template-1396x571.png');

            % Create Wmarks10Label
            app.Wmarks10Label = uilabel(app.WmarksUIFigure);
            app.Wmarks10Label.Position = [27 11 69 22];
            app.Wmarks10Label.Text = 'Wmarks 1.0';

            % Create GuideButton
            app.GuideButton = uibutton(app.WmarksUIFigure, 'push');
            app.GuideButton.ButtonPushedFcn = createCallbackFcn(app, @GuideButtonPushed, true);
            app.GuideButton.FontWeight = 'bold';
            app.GuideButton.Position = [825 544 115 37];
            app.GuideButton.Text = 'Guide';

            % Create Image
            app.Image = uiimage(app.WmarksUIFigure);
            app.Image.Position = [961 536 49 51];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'png-transparent-red-and-gray-logo-telkom-university-sepuluh-nopember-institute-of-technology-logo-university-of-california-berkeley-awards-miscellaneous-angle-text.png');

            % Create Panel
            app.Panel = uipanel(app.WmarksUIFigure);
            app.Panel.Position = [140 388 316 101];

            % Create EmbeddingButton
            app.EmbeddingButton = uibutton(app.Panel, 'push');
            app.EmbeddingButton.ButtonPushedFcn = createCallbackFcn(app, @EmbeddingButtonPushed, true);
            app.EmbeddingButton.FontWeight = 'bold';
            app.EmbeddingButton.Position = [164 14 115 37];
            app.EmbeddingButton.Text = 'Embedding';

            % Create EmbeddingDropDown
            app.EmbeddingDropDown = uidropdown(app.Panel);
            app.EmbeddingDropDown.Items = {'PHT LQIM', 'PHT MSS', 'PHT DCQIM'};
            app.EmbeddingDropDown.FontWeight = 'bold';
            app.EmbeddingDropDown.Position = [164 68 117 22];
            app.EmbeddingDropDown.Value = 'PHT LQIM';

            % Create BrowseImageButton
            app.BrowseImageButton = uibutton(app.Panel, 'push');
            app.BrowseImageButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseImageButtonPushed, true);
            app.BrowseImageButton.Icon = fullfile(pathToMLAPP, 'image.png');
            app.BrowseImageButton.IconAlignment = 'right';
            app.BrowseImageButton.FontWeight = 'bold';
            app.BrowseImageButton.Position = [18 32 127 37];
            app.BrowseImageButton.Text = 'Browse Image';

            % Create AttackButton
            app.AttackButton = uibutton(app.WmarksUIFigure, 'push');
            app.AttackButton.ButtonPushedFcn = createCallbackFcn(app, @AttackButtonPushed, true);
            app.AttackButton.FontWeight = 'bold';
            app.AttackButton.Position = [485 420 56 34];
            app.AttackButton.Text = 'Attack';

            % Create Panel_2
            app.Panel_2 = uipanel(app.WmarksUIFigure);
            app.Panel_2.Position = [569 388 321 101];

            % Create EkstraksiDropDown
            app.EkstraksiDropDown = uidropdown(app.Panel_2);
            app.EkstraksiDropDown.Items = {'PHT LQIM', 'PHT MSS ', 'PHT DCQIM'};
            app.EkstraksiDropDown.FontWeight = 'bold';
            app.EkstraksiDropDown.Position = [163 68 117 22];
            app.EkstraksiDropDown.Value = 'PHT LQIM';

            % Create ExtractionButton
            app.ExtractionButton = uibutton(app.Panel_2, 'push');
            app.ExtractionButton.ButtonPushedFcn = createCallbackFcn(app, @ExtractionButtonPushed, true);
            app.ExtractionButton.FontWeight = 'bold';
            app.ExtractionButton.Position = [163 14 115 37];
            app.ExtractionButton.Text = 'Extraction';

            % Create BrowseImageButton_2
            app.BrowseImageButton_2 = uibutton(app.Panel_2, 'push');
            app.BrowseImageButton_2.ButtonPushedFcn = createCallbackFcn(app, @BrowseImageButton_2Pushed, true);
            app.BrowseImageButton_2.Icon = fullfile(pathToMLAPP, 'image.png');
            app.BrowseImageButton_2.IconAlignment = 'right';
            app.BrowseImageButton_2.FontWeight = 'bold';
            app.BrowseImageButton_2.Position = [21 32 124 37];
            app.BrowseImageButton_2.Text = 'Browse Image';

            % Create SaveImageButton
            app.SaveImageButton = uibutton(app.WmarksUIFigure, 'push');
            app.SaveImageButton.ButtonPushedFcn = createCallbackFcn(app, @SaveImageButtonPushed, true);
            app.SaveImageButton.FontWeight = 'bold';
            app.SaveImageButton.Position = [455 55 115 37];
            app.SaveImageButton.Text = 'Save Image';

            % Create Image3
            app.Image3 = uiimage(app.WmarksUIFigure);
            app.Image3.Position = [-12 488 278 113];
            app.Image3.ImageSource = fullfile(pathToMLAPP, 'Wmarks.png');

            % Create AboutUsButton
            app.AboutUsButton = uibutton(app.WmarksUIFigure, 'push');
            app.AboutUsButton.ButtonPushedFcn = createCallbackFcn(app, @AboutUsButtonPushed, true);
            app.AboutUsButton.Icon = fullfile(pathToMLAPP, '11062103.png');
            app.AboutUsButton.IconAlignment = 'right';
            app.AboutUsButton.FontWeight = 'bold';
            app.AboutUsButton.Position = [904 23 106 33];
            app.AboutUsButton.Text = 'About Us';

            % Show the figure after all components are created
            app.WmarksUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = utama2_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.WmarksUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.WmarksUIFigure)
        end
    end
end