
clear all

wind = 'BIGGyre_Wind.nc';
%load('AntarcticArgo.mat')

wlon = ncread(wind,'longitude'); % read in the adjusted temp of the current float
wlat = ncread(wind,'latitude'); % read in the adjusted temp of the current float
wU = ncread(wind,'u10'); % read in the adjusted temp of the current float
wV = ncread(wind,'v10'); % read in the adjusted temp of the current float
wwtime = ncread(wind,'time'); % read in the adjusted temp of the current float
wtime = datenum(wwtime/24)+datenum('01-01-1900');

Curl = [];
Taux1 = [];
Tauy1 = [];

Taux2 = [];
Tauy2 = [];

for i = 1:length(wlon)
    for j = 1:length(wlat)
        taux1 = squeeze(squeeze(0.0025*1.225*wU(i,j,1,1).^2.*sign(wU(i,j,1,2))));
        tauy1 = squeeze(squeeze(0.0025*1.225*wV(i,j,1,1).^2.*sign(wV(i,j,1,2))));
        Taux1 = [Taux1,taux1];
        Tauy1 = [Tauy1,tauy1];
        
        taux2 = squeeze(squeeze(0.0025*1.225*wU(i,j,1,7).^2.*sign(wU(i,j,1,7))));
        tauy2 = squeeze(squeeze(0.0025*1.225*wV(i,j,1,7).^2.*sign(wV(i,j,1,7))));
        Taux2 = [Taux2,taux2];
        Tauy2 = [Tauy2,tauy2];
    end
end

wind_x_grid = (wlon - (-179)) * 111.5e3 * cosd(nanmean(double(wlat))); 
wind_y_grid = (wlat - (-76)) * 111.5e3;

Taux1 = reshape(Taux1,[length(wlat),length(wlon)]);
Tauy1 = reshape(Tauy1,[length(wlat),length(wlon)]);

Taux2 = reshape(Taux2,[length(wlat),length(wlon)]);
Tauy2 = reshape(Tauy2,[length(wlat),length(wlon)]);

Curl1 = curl(wind_x_grid,wind_y_grid,Taux1,Tauy1);
Curl2 = curl(wind_x_grid,wind_y_grid,Taux2,Tauy2);

Ekman1 = (1/(1025*(2*(7.27*10^-5)*sin(-70)))).*Curl1;
Ekman2 = (1/(1025*(2*(7.27*10^-5)*sin(-70)))).*Curl2;

Curl1 = reshape(Curl1,[length(wlat),length(wlon)]);
Ekman1 = reshape(Ekman1,[length(wlat),length(wlon)]);
Curl2 = reshape(Curl2,[length(wlat),length(wlon)]);
Ekman2 = reshape(Ekman2,[length(wlat),length(wlon)]);
Taux = reshape(Taux1,[length(wlat),length(wlon)]);
Tauy = reshape(Tauy1,[length(wlat),length(wlon)]);

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
EK.Curl =Curl;
EK.Taux = Taux;
EK.Tauy = Tauy;
EK.Ekman = Ekman2;
EK.wtime = wtime;

save SouthAmericaBigEkman.mat  EK

%% plots

figure(3)
m_proj('Robinson','long',[-170 -85],'lat',[-55 -15]);
colormap(cmocean('balance'))
caxis([-0.000005,0.000005])
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
