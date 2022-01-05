%% Wind Rose Fucking About 

%% RossSea

wind = 'RossSea_Gyre_Wind.nc';

wlat = ncread(wind,'latitude');
wlon = ncread(wind,'longitude');
wwtime = ncread(wind,'time');
wtime = datenum(wwtime/24)+datenum('01-01-1900');
WTIME = datetime(wtime, 'ConvertFrom', 'datenum', 'Format', 'MM');
m = month(WTIME);
u10 = ncread(wind,'u10');
v10 = ncread(wind,'v10');

%% 

ind = find((m == 02));


TEST = u10(:,:,1,ind);
U = u10(:,:,1,ind);
V = v10(:,:,1,ind);

close all
figure(1)
quiver(wlon,wlat,u10(:,:,1,1)',v10(:,:,1,1)')


% to get a wind rose, we need to get the direction of the wind from the x
% and y components
% http://tornado.sfsu.edu/geosciences/classes/m430/Wind/WindDirection.html 

dir = (180/3.14) * atan2(V,U);
 
speed = sqrt((U.^2)+(V.^2));
 

wind_rose(dir,speed)

%% RossSea

wind = 'SA_Wind.nc';

wlat = ncread(wind,'latitude');
wlon = ncread(wind,'longitude');
wwtime = ncread(wind,'time');
wtime = datenum(wwtime/24)+datenum('01-01-1900');
WTIME = datetime(wtime, 'ConvertFrom', 'datenum', 'Format', 'MM');
m = month(WTIME);
u10 = ncread(wind,'u10');
v10 = ncread(wind,'v10');

%% 

ind = find((m == 02));


TEST = u10(:,:,1,ind);
U = u10(:,:,1,ind);
V = v10(:,:,1,ind);

figure
quiver(wlon,wlat,u10(:,:,1,1)',v10(:,:,1,1)')


% to get a wind rose, we need to get the direction of the wind from the x
% and y components
% http://tornado.sfsu.edu/geosciences/classes/m430/Wind/WindDirection.html 

dir = (180/3.14) * atan2(V,U);
 
speed = sqrt((U.^2)+(V.^2));



wind_rose(dir,speed)
 
  function wind_rose(wind_direction,wind_speed)
    %WIND_ROSE Plot a wind rose
    %   this plots a wind rose
    figure
    pax = polaraxes;
    pax.FontSize = 25;
    polarhistogram(deg2rad(wind_direction(wind_speed<25)),deg2rad(0:10:360),'FaceColor',[0 0 0],'displayname','20 - 25 m/s');
    hold on
    pax.FontSize = 25;
    polarhistogram(deg2rad(wind_direction(wind_speed<20)),deg2rad(0:10:360),'FaceColor',[0 0.25 0],'displayname','15 - 20 m/s');
    polarhistogram(deg2rad(wind_direction(wind_speed<15)),deg2rad(0:10:360),'FaceColor',[0 0.45 0]','displayname','10 - 15 m/s');
    polarhistogram(deg2rad(wind_direction(wind_speed<10)),deg2rad(0:10:360),'FaceColor',[0 0.65 0],'displayname','5 - 10 m/s');
    polarhistogram(deg2rad(wind_direction(wind_speed<5)),deg2rad(0:10:360),'FaceColor',[0 1 0],'displayname','0 - 5 m/s');
    pax.ThetaDir = 'clockwise';
    pax.ThetaZeroLocation = 'top';
    legend('Show')
  end
  
  
