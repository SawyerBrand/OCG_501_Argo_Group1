%% real wind curl time

wind = 'SO_Wind.nc';
%load('AntarcticArgo.mat')

wlon = ncread(wind,'longitude'); % read in the adjusted temp of the current float
wlat = ncread(wind,'latitude'); % read in the adjusted temp of the current float
wU = ncread(wind,'u10'); % read in the adjusted temp of the current float
wV = ncread(wind,'v10'); % read in the adjusted temp of the current float
wwtime = ncread(wind,'time'); % read in the adjusted temp of the current float
wtime = datenum(wwtime/24)+datenum('01-01-1900');

AvU = nanmean(wU(:,:,1,:),4); 
AvV = nanmean(wV(:,:,1,:),4); 


[X_grid,Y_grid] = meshgrid(wlon+360,wlat);

Curl = curl(X_grid,Y_grid,AvU',AvV');

[X_grid1,Y_grid1] = meshgrid(wlon,wlat);

Curl1 = curl(X_grid1,Y_grid1,AvU',AvV');

%% plots

close all

figure(1)

m_proj('lambert','long',[150 220],'lat',[-80 -64]);
ax=gca;
ax.FontSize=21;
hold on 
pc = m_pcolor(X_grid,Y_grid,Curl);
pc1 = m_pcolor(X_grid1,Y_grid1,Curl1);

m_quiver(X_grid,Y_grid,AvU',AvV',0.5,'k');
m_quiver(X_grid1,Y_grid1,AvU',AvV',0.5,'k');

m_grid('box','fancy','tickdir','in');
m_coast('patch',[.6 .6 .6]);

colormap(cmocean('balance'))
caxis([-2,2])

h = colorbar;
set(get(h,'title'),'string','m^2/s');


hold off
