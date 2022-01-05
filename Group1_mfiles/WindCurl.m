
clear all

wind = 'SO_Wind.nc';
load('AntarcticArgo.mat')

wlon = ncread(wind,'longitude'); % read in the adjusted temp of the current float
wlat = ncread(wind,'latitude'); % read in the adjusted temp of the current float
wU = ncread(wind,'u10'); % read in the adjusted temp of the current float
wV = ncread(wind,'v10'); % read in the adjusted temp of the current float
wwtime = ncread(wind,'time'); % read in the adjusted temp of the current float
wtime = datenum(wwtime/24)+datenum('01-01-1900');

load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/Antarctic/Ross_Sea/Nit_Chl/SAmerica_Nut.mat');
load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/Antarctic/Ross_Sea/Ross_Sea_DO/AntarcticArgoDO.mat');

DLON = AA.Lon;
DLAT = AA.Lat;

CLON = NUT.Lon;
CLAT = NUT.Lat;

NLON = NUT.Lon;
NLAT = NUT.Lat;

%%
Curl = [];
Taux = [];
Tauy = [];

Taux1 = [];
Tauy1 = [];


for i = 1:length(wlon)
    for j = 1:length(wlat)
        taux1 = squeeze(squeeze(0.0025*1.225*wU(i,j,1,32).^2.*sign(wU(i,j,1,32))));
        tauy1 = squeeze(squeeze(0.0025*1.225*wV(i,j,1,32).^2.*sign(wV(i,j,1,32))));
        Taux1 = [Taux1,taux1];
        Tauy1 = [Tauy1,tauy1];
    end
end

wind_x_grid = (wlon - (-179)) * 111.5e3 * cosd(nanmean(double(wlat))); 
wind_y_grid = (wlat - (-76)) * 111.5e3;

Taux1 = reshape(Taux1,[length(wlat),length(wlon)]);
Tauy1 = reshape(Tauy1,[length(wlat),length(wlon)]);

Curl1 = curl(wind_x_grid,wind_y_grid,Taux1,Tauy1);

Ekman1 = (1/(1025*(2*(7.27*10^-5)*sin(-70)))).*Curl1;

Curl1 = reshape(Curl1,[length(wlat),length(wlon)]);
Ekman1 = reshape(Ekman1,[length(wlat),length(wlon)]);

%figure(1)
%contourf(wlat,wlon,Curl1')

close all
% figure(1)
% title('Wind Stress Curl with Antarctic Float Locations')
% colormap(cmocean('balance'))
% caxis([-0.000001,0.000001])
% ax=gca;
% ax.FontSize=16;
% hold on 
% pcolor(wlon,wlat,Curl)
% shading('flat')
% plot(AA.Lon-360,AA.Lat,'k.','markersize',15)
% %quiver(wlon,wlat,Taux,Tauy,2,'filled','linewidth',2)
% h = colorbar;
% set(get(h,'label'),'string','N/m^2');
% hold off
% 
% figure(2)
% title('Ekman Pumping with Antarctic Float Locations')
% colormap(cmocean('balance'))
% caxis([-0.000005,0.000005])
% ax=gca;
% ax.FontSize=16;
% hold on 
% pcolor(wlon,wlat,Ekman)
% shading('flat')
% scatter(AA.Lon-360,AA.Lat,20,AA.Ekman,'filled','MarkerEdgeColor','k')
% %plot(AA.Lon-360,AA.Lat,'k.','markersize',15)
% %quiver(wlon,wlat,Taux,Tauy,2,'filled','linewidth',2)
% h = colorbar;
% set(get(h,'label'),'string','m^2/s');
% hold off

EK.wlon = wlon;
EK.wlat = wlat;
EK.Curl =Curl1;
EK.Taux = Taux1;
EK.Tauy = Tauy1;
EK.Ekman = Ekman1;
EK.wtime = wtime;

save AntarcticEkman.mat  EK

%%
close all

figure(3)
m_proj('Robinson','long',[140 230],'lat',[-85 -64]);
colormap(cmocean('balance'))
caxis([-0.000009,0.000009])
ax=gca;
ax.FontSize=16;
hold on 
m_pcolor(wlon+360,wlat,Ekman1)
m_pcolor(wlon,wlat,Ekman1)
shading('flat')

m_grid('box','fancy','tickdir','in');
m_coast('patch',[.6 .6 .6]);
h = colorbar;
set(get(h,'title'),'string','m^2/s');