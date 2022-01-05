%% South America Oxyg


clear all


files = dir('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/SouthAmerica/Dissolved_Oxygen/SD*.nc');

load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/SouthAmerica/SouthAmericaBigEkman.mat');

wlon = EK.wlon;
wlat = EK.wlat;
EkTransport = EK.Ekman;

NP = 0;

Lon = [];
Lat = [];
Doxy = [];
EkDepth = [];
Temp = [];
Time = [];

for i=1:length(files)
    NP =NP+1;
    
    file = files(i);
    
    TempA = ncread(files(i).name,'TEMP_ADJUSTED'); % read in the adjusted temp of the current float
    TempQF = ncread(files(i).name,'TEMP_ADJUSTED_QC');
    PresA = ncread(files(i).name,'PRES_ADJUSTED');
    PresQF = ncread(files(i).name,'PRES_ADJUSTED_QC');
    PsalA = ncread(files(i).name,'PSAL_ADJUSTED');
    PsalQF = ncread(files(i).name,'PSAL_ADJUSTED_QC');
    DoxyA = ncread(files(i).name,'DOXY_ADJUSTED'); 
    DoxyQF = ncread(files(i).name,'DOXY_ADJUSTED_QC');
    LonA = ncread(files(i).name,'LONGITUDE');
    LatA = ncread(files(i).name,'LATITUDE');
    TimeA = ncread(files(i).name,'JULD')+datenum(1950,01,01);
            
    dEk = sqrt(0.1/abs(2*(7.27*10^-5)*sin(LatA)));
    EkDepth = [EkDepth,dEk];

    TT = TempA;
    PP = PresA;
    SS = PsalA;
    DD = DoxyA;
    PPN = PresA;
    PPC = PresA;


    TEMP100 = nanmean(TT(PP <= 60));
    DOXY100 = nanmean(DD(PPN <= 60));

    if LonA >=0
        Lon = [Lon,LonA];
    end
    if LonA < 0
       Lon = [Lon,LonA+360];
    end
        
    Lat = [Lat,LatA];
    Doxy = [Doxy,DOXY100];
    Temp = [Temp,TEMP100];
    Time = [Time,TimeA];
  
end


% 

% EKMAN = [];
% for i=1:length(files)
%     
%     Lonn = ncread(files(i).name,'LONGITUDE');
%     Latt = ncread(files(i).name,'LATITUDE');
%     
%     NP = size(Lonn,2);
%     
%     for j = 1:NP
%         %disp('hi')
%         
%         EkInterm = [];
%         CurlInterm = [];
%         
%         for k = 1:length(wlon)
%             for l = 1:length(wlat)
%                     if ((abs(Lonn(j) - (wlon(k))) <=0.125)&(abs(Latt(j) - wlat(l)) <=0.125))
%                         EkUA= EkTransport(l,k);
%                         EkInterm = [EkInterm,EkUA];
% 
%                     end
%                 
%             end
%         
%         end
%         
%         EKMAN = [EKMAN,EkInterm(1)];
%         
%     end
%     
%     %ChlAv = [ChlAv,Chl_Av];
% 
% end
% 
% [B,I] = sort(Time);
% 
% Ekman = EKMAN;
% 
% %% 
% DOXY.Lat = Lat(I);
% DOXY.Doxy = Doxy(I);
% DOXY.Lon = Lon(I);
% DOXY.dEk = EkDepth(I);
% DOXY.EkTransport = Ekman;
% DOXY.Time = B;
% 
% save SAmerica_Doxy.mat DOXY
% 
% %%
% close all
% 
% figure(1)
% m_proj('lambert','long',[210 290],'lat',[-45 -09]);
% title('Dissolved Oxygen - S America Floats')
% colormap(cmocean('matter'))
% caxis([190,270])
% ax=gca;
% ax.FontSize=16;
% hold on 
% m_scatter(Lon,Lat,35,Doxy,'filled')
% shading('flat')
% m_grid('box','fancy','tickdir','in');
% m_coast('patch',[.6 .6 .6]);
% h = colorbar;
% set(get(h,'title'),'string','micromol/kg');
% 
% figure(2)
% m_proj('lambert','long',[210 290],'lat',[-45 -09]);
% title('Temperature - S America Floats')
% colormap(cmocean('deep'))
% caxis([11 29])
% ax=gca;
% ax.FontSize=16;
% hold on 
% m_scatter(Lon,Lat,35,Temp,'filled')
% shading('flat')
% m_grid('box','fancy','tickdir','in');
% m_coast('patch',[.6 .6 .6]);
% h = colorbar;
% set(get(h,'title'),'string','C');
% 
% figure(3)
% m_proj('lambert','long',[210 290],'lat',[-45 -09]);
% title('Ekman Transport - S America Floats')
% colormap(cmocean('speed'))
% caxis([-0.00001,0.00001])
% ax=gca;
% ax.FontSize=16;
% hold on 
% m_scatter(Lon,Lat,35,Ekman,'filled')
% shading('flat')
% m_grid('box','fancy','tickdir','in');
% m_coast('patch',[.6 .6 .6]);
% h = colorbar;
% set(get(h,'title'),'string','m');


disp(NP)