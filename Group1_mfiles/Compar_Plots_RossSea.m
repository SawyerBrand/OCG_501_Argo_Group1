%% Ross Sea Comparitive Plots

clear all


files = dir('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/Antarctic/Ross_Sea/Nit_Chl/SD*.nc');


load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/Antarctic/Ross_Sea/Nit_Chl/SAmerica_Nut.mat');

Lat =[];
Lon = [];

NITERINO = [];
CHLERINO = [];


numbermonths = [];
EKKERs = [];

figure(5)
hold on

for i=1:length(files)
    %NP =NP+1;
    
    nit = [];
    chl = [];
    
    file = files(i);
    
    TempA = ncread(files(i).name,'TEMP_ADJUSTED'); % read in the adjusted temp of the current float
    TempQF = ncread(files(i).name,'TEMP_ADJUSTED_QC');
    PresA = ncread(files(i).name,'PRES_ADJUSTED');
    PresQF = ncread(files(i).name,'PRES_ADJUSTED_QC');
    PsalA = ncread(files(i).name,'PSAL_ADJUSTED');
    PsalQF = ncread(files(i).name,'PSAL_ADJUSTED_QC');
    ChlA = ncread(files(i).name,'CHLA_ADJUSTED');
    ChlQF = ncread(files(i).name,'CHLA_ADJUSTED_QC');
    NitA = ncread(files(i).name,'NITRATE_ADJUSTED'); 
    NitQF = ncread(files(i).name,'NITRATE_ADJUSTED_QC');
    LonA = ncread(files(i).name,'LONGITUDE');
    LatA = ncread(files(i).name,'LATITUDE');
    TimeA = ncread(files(i).name,'JULD')+datenum(1950,01,01);
    
    
    TA = datenum(TimeA);
    TB = datetime(TA,'ConvertFrom','datenum');
    
    M = month(TB);
    
    if ((M == 12)|(M == 1)| (M == 2))&(NUT.EkmanTransport(1,i) >=0)
        
        numbermonths = [numbermonths +1];
        %disp(size(PresA))

        dEk = sqrt(0.1/abs(2*(7.27*10^-5)*sin(LatA)));
        %EkDepth = [EkDepth,dEk];

        TT = TempA(TempQF ~= '4');
        PP = PresA(PresQF ~= '4');
        SS = PsalA(PsalQF ~= '4');
        NN = NitA(NitQF ~= '4');
        PPN = PresA(NitQF ~= '4');
        CC = ChlA(ChlQF ~= '4');
        PPC = PresA(ChlQF ~= '4');
        plot(NN,PPN,'b.')

        z_interp = [1:1:2000];
        

        nit     = [nit  interp1(PPN,  NN,  z_interp, 'linear', NaN)]; 
        chl    = [chl interp1(PPC,  CC, z_interp, 'linear', NaN)]; 
        plot(nit,z_interp,'r.')

        NITERINO = [NITERINO, nit];
        CHLERINO = [CHLERINO, chl];
        %NITINTERM = [NITINTERM,reshape(NITERINO,[i,2000])];
        %CHLINTERM = [CHLINTERM,reshape(CHLERINO,[i,2000])];
        EKKERs = [EKKERs,dEk];
    end

end
[uck,nummonths] = size(numbermonths);

Nitrate_Profiles = reshape(NITERINO,[(nummonths),2000]);
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
MovMean_AvNit = movmean(AvNit,10,'omitnan');
MovMean_AvChl = movmean(AvChl,10,'omitnan');

close all


figure(1)
ax = gca;
ax.FontSize = 16;

subplot(1,2,1)
ax = gca;
ax.FontSize = 16;

hold on
set(gca,'YDir','reverse')
nit = plot(AvNit,z_interp,'r-','linewidth',3);
m60 = line([25,35],[60,60],'linewidth',3);
ek = line([25,35],[nanmean(EKKERs),nanmean(EKKERs)],'linewidth',3,'color','c');
xlim([25,35]);
ylim([0,600])
lgd = legend([nit,m60,ek],'Average Nitrate Profile','60 m line','Average Ekman Depth','Location','southwest')
lgd.FontSize =18;
hold off

subplot(1,2,2)
ax = gca;
ax.FontSize = 16;
hold on
set(gca,'YDir','reverse')
chl = plot(AvChl,z_interp,'b-','LineWidth',3);
m60 = line([-1,3],[60,60],'linewidth',3);
ek = line([-1,3],[nanmean(EKKERs),nanmean(EKKERs)],'linewidth',3,'color','c');
xlim([-1,3])
ylim([0,600])
lgd2 = legend([chl,m60,ek],'Average Chlorophyll Profile','60 m line','Average Ekman Depth','Location','southeast')
lgd2.FontSize =18;
hold off

