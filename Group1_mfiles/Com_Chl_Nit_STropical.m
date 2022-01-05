%% S America Comparitive Plots

clear all


filesNit = dir('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/SouthAmerica/Chl_Nit/Gyre_Nitrate/SD*.nc');
filesChl = dir('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/SouthAmerica/Chl_Nit/Gyre_Chloro/SD*.nc');


load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/SouthAmerica/Chl_Nit/Gyre_Chloro/SAmerica_Chl.mat');
load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/SouthAmerica/Chl_Nit/Gyre_Nitrate/SAmerica_Nit.mat');

Lat =[];
Lon = [];

NITERINO = [];
CHLERINO = [];


numbermonths = [];
EKKERs = [];

z_interp = [1:1:2000];

figure(5)
hold on

for i=1:length(filesNit)
    %NP =NP+1;
    
    nit = [];
    
    file = filesNit(i).name;

    PresA = ncread(file,'PRES_ADJUSTED');
    PresQF = ncread(file,'PRES_ADJUSTED_QC');
    NitA = ncread(file,'NITRATE_ADJUSTED'); 
    NitQF = ncread(file,'NITRATE_ADJUSTED_QC');
    LonA = ncread(file,'LONGITUDE');
    LatA = ncread(file,'LATITUDE');
    TimeA = ncread(file,'JULD')+datenum(1950,01,01);
    
    
    TA = datenum(TimeA);
    TB = datetime(TA,'ConvertFrom','datenum');
    
    M = month(TB);
    
    if ((M == 12)|(M == 1)| (M == 2))&(NIT.Ekman(1,i) <=0)
        
        %disp(size(PresA))

        dEk = sqrt(0.1/abs(2*(7.27*10^-5)*sin(LatA)));
        %EkDepth = [EkDepth,dEk];


        PP = PresA(PresQF ~= '4');
        NN = NitA((NitQF ~= '4')&(PresQF ~= '4'));
        PPN = PresA((NitQF ~= '4')&(PresQF ~= '4'));       
        
        if length(NN) >1
            numbermonths = [numbermonths +1];
            
            nit     = [nit  interp1(PPN,  NN,  z_interp, 'linear', NaN)];  

            NITERINO = [NITERINO, nit];
            %NITINTERM = [NITINTERM,reshape(NITERINO,[i,2000])];
            %CHLINTERM = [CHLINTERM,reshape(CHLERINO,[i,2000])];
            EKKERs = [EKKERs,dEk];
        end
        
    end

end

[uck,nummonths] = size(numbermonths);

Nitrate_Profiles = reshape(NITERINO,[(nummonths),2000]);

numbermonths = [];

for i=1:length(filesChl)
    %NP =NP+1;
    chl=[];
    
    file = filesChl(i).name;

    PresA = ncread(file,'PRES_ADJUSTED');
    PresQF = ncread(file,'PRES_ADJUSTED_QC');
    ChlA = ncread(file,'CHLA_ADJUSTED');
    ChlQF = ncread(file,'CHLA_ADJUSTED_QC');
    LonA = ncread(file,'LONGITUDE');
    LatA = ncread(file,'LATITUDE');
    TimeA = ncread(file,'JULD')+datenum(1950,01,01);
    
    
    TA = datenum(TimeA);
    TB = datetime(TA,'ConvertFrom','datenum');
    
    M = month(TB);
    
    if ((M == 12)|(M == 1)| (M == 2))&(CHL.Ekman(1,i) <=0)
        
        %disp(size(PresA))

        dEk = sqrt(0.1/abs(2*(7.27*10^-5)*sin(LatA)));
        %EkDepth = [EkDepth,dEk];


        PP = PresA(PresQF ~= '4');
        CC = ChlA((ChlQF ~= '4')&(PresQF ~= '4'));
        PPC = PresA((ChlQF ~= '4')&(PresQF ~= '4'));
        
        if length(CC) >1
            numbermonths = [numbermonths +1];
            
            chl    = [chl interp1(PPC,  CC, z_interp, 'linear', NaN)];  

            CHLERINO = [CHLERINO, chl];
            %NITINTERM = [NITINTERM,reshape(NITERINO,[i,2000])];
            %CHLINTERM = [CHLINTERM,reshape(CHLERINO,[i,2000])];
            EKKERs = [EKKERs,dEk];
        end
    end

end
[uck,nummonths] = size(numbermonths);

Chlorophyll_Profiles = reshape(CHLERINO,[(nummonths),2000]);



%% take averages 
AvChl = [];
AvNit = [];

for ii = 1:2000
    CC = Chlorophyll_Profiles(:,ii);
    C = mean(CC,'omitnan');%(CC>=28));
    AvChl = [AvChl,C];
    
    NN = Nitrate_Profiles(:,ii);
    N = mean(NN,'omitnan');
    AvNit = [AvNit,N];

end

%% plots
MovMean_AvNit = movmean(AvNit,100,'omitnan');
MovMean_AvChl = movmean(AvChl,5,'omitnan');

close all


figure(1)
ax = gca;
ax.FontSize = 16;

subplot(1,2,1)
ax = gca;
ax.FontSize = 16;

hold on
set(gca,'YDir','reverse')
nit = plot(MovMean_AvNit,z_interp,'r-','linewidth',3);
m60 = line([30,37],[60,60],'linewidth',3);
ek = line([30,37],[nanmean(EKKERs),nanmean(EKKERs)],'linewidth',3,'color','c');
xlim([30,37]);
ylim([0,600])
lgd = legend([nit,m60,ek],'Average Nitrate Profile','60 m line','Average Ekman Depth','Location','southwest');
lgd.FontSize =18;
hold off

subplot(1,2,2)
ax = gca;
ax.FontSize = 16;
hold on
set(gca,'YDir','reverse')
chl = plot(MovMean_AvChl,z_interp,'b-','LineWidth',3);
m60 = line([-1,3],[60,60],'linewidth',3);
ek = line([-1,3],[nanmean(EKKERs),nanmean(EKKERs)],'linewidth',3,'color','c');
xlim([-1,1])
ylim([0,600])
lgd2 = legend([chl,m60,ek],'Average Chlorophyll Profile','60 m line','Average Ekman Depth','Location','southeast');
lgd2.FontSize =18;
hold off