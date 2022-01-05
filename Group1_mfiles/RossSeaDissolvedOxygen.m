%% RossSeaDO

files = dir('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/Antarctic/Ross_Sea/Ross_Sea_DO/SD*.nc');

NP = 0;

Lon = [];
Lat = [];
Doxy = [];
EkDepth = [];
Temp =[];
Time = [];

load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/Antarctic/AntarcticEkman.mat');


wlon = EK.wlon;
wlat = EK.wlat;
EkTransport = EK.Ekman;

%% read in the wind data

wlon = EK.wlon; % read in the adjusted temp of the current float
wlat = EK.wlat; % read in the adjusted temp of the current float
Ek = EK.Ekman; 
CURL = EK.Curl;
wtime = EK.wtime;

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
    PPD = PresA;
    
    TT = TempA(TempQF ~= '4');
    PP = PresA(PresQF ~= '4');
    SS = PsalA(PsalQF ~= '4');
    DD = DoxyA(DoxyQF ~= '4');
    PPD = PresA(DoxyQF ~= '4');


    TEMP100 = nanmean(TT(PP <= dEk));
    DD100 = nanmean(DD(PPD <= dEk));
    %RHO100 = R;
    %PSAL100 = SS(PP < 100);

    if LonA >=0
        Lon = [Lon,LonA];
    end
    if LonA < 0
       Lon = [Lon,LonA+360];
    end
        
    Lat = [Lat,LatA];
    Doxy = [Doxy,DD100];
    Temp = [Temp,TEMP100];
    Time = [Time,TimeA];
  
end

EKMAN = [];


NP = size(Lon,2);

for j = 1:NP
    %disp('hi')

    EkInterm = [];
    CurlInterm = [];

    if Lon(j) <=180
        %disp(Lon(j))

        for k = 1:length(wlon)
            for l = 1:length(wlat)
                    if ((abs(Lon(j) - (wlon(k))) <=0.125)&(abs(Lat(j) - wlat(l)) <=0.125))
                        EkUA= EkTransport(l,k);
                        EkInterm = [EkInterm,EkUA];

                    end

            end

        end
    end  

    if Lon(j) > 180
        disp(Lon(j))

        for k = 1:length(wlon)
            for l = 1:length(wlat)
                    if ((abs(Lon(j) - (wlon(k)+360)) <=0.125)&(abs(Lat(j) - wlat(l)) <=0.125))
                        EkUA= EkTransport(l,k);
                        EkInterm = [EkInterm,EkUA];
                    end
                    
                   

            end

        end
    end  

    EKMAN = [EKMAN,EkInterm(1)];
    %disp(size(EkInterm))
    %disp(size(EKMAN))

end


%%
[B,I] = sort(Time);

AA.Temp = Temp(I);
AA.Doxy = Doxy(I);
AA.Time = B;
AA.EkDepth = EkDepth(I);
%AA.UTransport = UTransport;
%AA.VTransport = VTransport;
AA.EkTransport = EKMAN;
AA.Lon = Lon(I);
AA.Lat = Lat(I);
%save UFSTransport  UTransport  ilon  yc 
save AntarcticArgoDO.mat  AA


close all

figure(3)
m_proj('lambert','long',[160 210],'lat',[-80 -68]);
title('Av DO over surface 60 m in Ross Sea')
colormap(cmocean('algae'))
caxis([264 390])
ax=gca;
ax.FontSize=16;
hold on 
m_scatter(Lon,Lat,30,Doxy,'filled')
shading('flat')
m_grid('box','fancy','tickdir','in');
m_coast('patch',[.6 .6 .6]);

figure(4)
m_proj('lambert','long',[160 210],'lat',[-80 -68]);
title('Av T over surface 60 m in Ross Sea')
colormap(cmocean('balance'))
caxis([-2 2])
ax=gca;
ax.FontSize=16;
hold on 
m_scatter(Lon,Lat,30,Temp,'filled')
shading('flat')
m_grid('box','fancy','tickdir','in');
m_coast('patch',[.6 .6 .6]);


disp(NP)