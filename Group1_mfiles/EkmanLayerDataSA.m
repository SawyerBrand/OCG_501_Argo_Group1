%% Ekman_Layer_Data

clear all

wind = 'BigGyre_Wind.nc';

%% read in the wind data

wlon = ncread(wind,'longitude'); % read in the adjusted temp of the current float
wlat = ncread(wind,'latitude'); % read in the adjusted temp of the current float
windU = ncread(wind,'u10'); % read in the adjusted temp of the current float
windV = ncread(wind,'v10'); % read in the adjusted temp of the current float
wwtime = ncread(wind,'time'); % read in the adjusted temp of the current float
wtime = datenum(wwtime/24)+datenum('01-01-1900');

UTransport = [];
VTransport = [];
EkTransport = [];
EkDepth = [];
Curl = [];
Taux =[];
Tauy = [];

for j = 1:129
    
    taux = 0.0025*1.225*(windU(:,j,1,:).^2).*sign(windU(:,j,1,:));
    tauy = 0.0025*1.225*(windV(:,j,1,:).^2).*sign(windV(:,j,1,:));

    Taux= [Taux,taux];
    Tauy = [Tauy,tauy];

    curl1 = taux - tauy;
    Curl = [Curl,curl1];

    dEk = sqrt(0.1/abs(2*(7.27*10^-5)*sin(wlat(j))));
    EkDepth = [EkDepth,dEk];

    UU = tauy*(1/(1025*(2*(7.27*10^-5)*sin(wlat(j)))));
    UTransport = [UTransport,UU];

    VV = taux*(1/(1025*-1*(2*(7.27*10^-5)*sin(wlat(j)))));
    VTransport = [VTransport,VV];
end
% 0.0025*1.225*U^2

%% 
UA =UTransport;
VA = VTransport;
LONA = wlon;
LATA = wlat;

wind_x_grid = (LONA - (-179)) .* 111.5e3 .* cosd(nanmean(double(LATA))); 
wind_y_grid = (LATA - (-76)) .* 111.5e3;

[X,Y] = meshgrid(wind_x_grid,wind_y_grid);

EkTransport = [];
for t =1:2526

    Ekk = curl(X,Y,squeeze(squeeze(UA(:,:,:,t)))',squeeze(squeeze(VA(:,:,:,t)))');
    EkTransport = [Ekk,EkTransport]; 
end

EkTransport(EkTransport<-50)=NaN;

SAEK.EkTransport = EkTransport;
SAEK.UTransport = UTransport;
SAEK.VTransport = VTransport;

save SAmerica_Ekman.mat SAEK