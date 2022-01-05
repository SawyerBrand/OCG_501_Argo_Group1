%% South American Data
clear all

load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/SouthAmerica/Chl_Nit/Gyre_Chloro/SAmerica_Chl.mat')
load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/SouthAmerica/Chl_Nit/Gyre_Nitrate/SAmerica_Nit.mat')
load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/SouthAmerica/Dissolved_Oxygen/SAmerica_Doxy.mat')

NLat = NIT.Lat;
NLon = NIT.Lon;
Nit = NIT.Nit;

CLat = CHL.Lat;
CLon = CHL.Lon;
Chl = CHL.Chl;

DLat = DOXY.Lat;
DLon = DOXY.Lon;
Doxy = DOXY.Doxy;

close all

figure(1)
ax=gca;
ax.FontSize =22;
m_proj('lambert','long',[180 290],'lat',[-55 -09]);
%title('South Pacific Subtropical Gyre Float Locations','FontSize',26)

hold on 
caxis(ax,[200,300]);
A = m_scatter(DLon,DLat,45,'red','filled');

B = m_scatter(CLon,CLat,65,'b','filled');

C = m_scatter(NLon,NLat,25,'c','filled');

shading('flat');
m_grid('box','fancy','tickdir','in');
m_coast('patch',[.6 .6 .6]);
lgd = legend([A,B,C],'Dissolved Oxygen Profiles','Chlorophyll Profiles','Nitrate Profiles');
lgd.FontSize = 22;


%cb2 = colorbar(ax3,'Position',[1.5 .11 .0675 .815]);