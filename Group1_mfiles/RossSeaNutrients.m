%% Ross Sea Nutrients

clear all

files = dir('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/Antarctic/Ross_Sea/Nit_Chl/SD*.nc');

load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/Antarctic/AntarcticEkman.mat');


wlon = EK.wlon;
wlat = EK.wlat;
EkTransport = EK.Ekman;


NP = 0;

Lon = [];
Lat = [];
Nit = [];
EkDepth = [];
Temp =[];
Chl = [];
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
    ChlA = ncread(files(i).name,'CHLA_ADJUSTED');
    ChlQF = ncread(files(i).name,'CHLA_ADJUSTED_QC');
    NitA = ncread(files(i).name,'NITRATE_ADJUSTED'); 
    NitQF = ncread(files(i).name,'NITRATE_ADJUSTED_QC');
    LonA = ncread(files(i).name,'LONGITUDE');
    LatA = ncread(files(i).name,'LATITUDE');
    TimeAA = ncread(files(i).name,'JULD')+datenum(1950,01,01);
            
    dEk = sqrt(0.1/abs(2*(7.27*10^-5)*sin(LatA)));
    EkDepth = [EkDepth,dEk];

    TT = TempA(TempQF ~= '4');
    PP = PresA(PresQF ~= '4');
    SS = PsalA(PsalQF ~= '4');
    NN = NitA(NitQF ~= '4');
    PPN = PresA(NitQF ~= '4');
    CC = ChlA(ChlQF ~= '4');
    PPC = PresA(ChlQF ~= '4');


    TEMP100 = nanmean(TT(PP <= dEk));
    NIT100 = nanmean(NN(PPN <= dEk));
    %RHO100 = R;
    %PSAL100 = SS(PP < 100);
    CHL100 = nanmean(CC(PPC <= dEk));

    if LonA >=0
        Lon = [Lon,LonA];
    end
    if LonA <=0
       Lon = [Lon,LonA+360];
    end
        
    Lat = [Lat,LatA];
    Nit = [Nit,NIT100];
    Chl = [Chl,CHL100];
    Temp = [Temp,TEMP100];
    Time = [Time,TimeAA];
  
end

%% 
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
    
    %ChlAv = [ChlAv,Chl_Av];



Ekman = EKMAN;


[B,I] = sort(Time);

NUT.Lat = Lat(I);
NUT.Nit = Nit(I);
NUT.Chl = Chl(I);
NUT.Lon = Lon(I);
NUT.dEk = EkDepth(I);
NUT.Nit = Nit(I);
NUT.EkmanTransport = Ekman(I);
NUT.Time = B;

save SAmerica_Nut.mat NUT

close all

figure(1)
m_proj('lambert','long',[160 210],'lat',[-80 -68]);
title('Temp Data in Ross Sea')
colormap(cmocean('deep'))
caxis([-2,1])
ax=gca;
ax.FontSize=16;
hold on 
m_scatter(Lon,Lat,30,Temp,'filled')
shading('flat')
m_grid('box','fancy','tickdir','in');
m_coast('patch',[.6 .6 .6]);


figure(2)
m_proj('lambert','long',[160 210],'lat',[-80 -68]);
title('Nitrate Data in Ross Sea')
colormap(cmocean('balance'))
caxis([14,32])
ax=gca;
ax.FontSize=16;
hold on 
m_scatter(Lon,Lat,30,Nit,'filled')
shading('flat')
m_grid('box','fancy','tickdir','in');
m_coast('patch',[.6 .6 .6]);

figure(3)
m_proj('lambert','long',[160 210],'lat',[-80 -68]);
title('Chlorophyll Data in Ross Sea')
colormap(cmocean('balance'))
caxis([0,9])
ax=gca;
ax.FontSize=16;
hold on 
m_scatter(Lon,Lat,30,Chl,'filled')
shading('flat')
m_grid('box','fancy','tickdir','in');
m_coast('patch',[.6 .6 .6]);

%% 

figure(4)
m_proj('lambert','long',[160 210],'lat',[-80 -68]);
title('Ekman Transport in Ross Sea')
colormap(cmocean('balance'))
caxis([-0.00001,0.00001])
ax=gca;
ax.FontSize=16;
hold on 
m_scatter(Lon,Lat,30,Ekman,'filled')
shading('flat')
m_grid('box','fancy','tickdir','in');
m_coast('patch',[.6 .6 .6]);

disp(NP)