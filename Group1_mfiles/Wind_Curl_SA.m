%% real wind curl time

wind = 'BIGGyre_Wind.nc';
%load('AntarcticArgo.mat')

wlon = ncread(wind,'longitude'); % read in the adjusted temp of the current float
wlat = ncread(wind,'latitude'); % read in the adjusted temp of the current float
wU = ncread(wind,'u10'); % read in the adjusted temp of the current float
wV = ncread(wind,'v10'); % read in the adjusted temp of the current float
wwtime = ncread(wind,'time'); % read in the adjusted temp of the current float
wtime = datenum(wwtime/24)+datenum('01-01-1900');

AvU = nanmean(wU(:,:,1,:),4); 
AvV = nanmean(wV(:,:,1,:),4); 


[X_grid,Y_grid] = meshgrid(wlon,wlat);

Curl = curl(X_grid,Y_grid,AvU',AvV');

%% plots

close all

figure(1)
m_proj('Lambert','long',[-170 -85],'lat',[-55 -15]);
ax=gca;
ax.FontSize=21;
hold on 
pc = m_pcolor(X_grid,Y_grid,Curl);

m_quiver(X_grid,Y_grid,AvU',AvV',1,'k');

m_grid('box','fancy','tickdir','in');
m_coast('patch',[.6 .6 .6]);

colormap(cmocean('balance'))
caxis([-1,1])

h = colorbar;
set(get(h,'title'),'string','m^2/s');
hold off
