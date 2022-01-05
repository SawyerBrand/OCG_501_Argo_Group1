%% Correlation Code
clear all

%% Southern America

load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/SouthAmerica/Chl_Nit/Gyre_Chloro/SAmerica_Chl.mat');
load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/SouthAmerica/Chl_Nit/Gyre_Nitrate/SAmerica_Nit.mat');
load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/SouthAmerica/Dissolved_Oxygen/SAmerica_Doxy.mat');

Chl = CHL.Chl((~isnan(CHL.Chl))&(~isnan(CHL.Ekman)));
ChlEk = CHL.Ekman((~isnan(CHL.Chl))&(~isnan(CHL.Ekman)));

CHLCORRSA = corrcoef(Chl,ChlEk);

disp('The corr coefficient between chlorophyll and ekman transport in S America is: ')
disp(CHLCORRSA);

Nit = NIT.Nit((~isnan(NIT.Nit))&(~isnan(NIT.Ekman)));
NitEk = NIT.Ekman((~isnan(NIT.Nit))&(~isnan(NIT.Ekman)));

NITCORRSA = corrcoef(Nit,NitEk);

disp('The corr coefficient between Nitrate and ekman transport in S America is: ')
disp(NITCORRSA);

DO = DOXY.Doxy((~isnan(DOXY.Doxy))&(~isnan(DOXY.EkTransport)));
DOXYEk = DOXY.EkTransport((~isnan(DOXY.Doxy))&(~isnan(DOXY.EkTransport)));

DOXYCORRSA = corrcoef(DO,DOXYEk);

disp('The corr coefficient between DOXY and ekman transport in S America is: ')
disp(DOXYCORRSA);

clear all
%% Southern Ocean

load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/Antarctic/Ross_Sea/Nit_Chl/SAmerica_Nut.mat');
load('/Users/sawyerbrand/Documents/MATLAB/501_Project/Argo_Data/Antarctic/Ross_Sea/Ross_Sea_DO/AntarcticArgoDO.mat');

Chl = NUT.Chl((~isnan(NUT.Chl))&(~isnan(NUT.EkmanTransport)));
ChlEk = NUT.EkmanTransport((~isnan(NUT.Chl))&(~isnan(NUT.EkmanTransport)));

CHLCORRSA = corrcoef(Chl,ChlEk);

disp('The corr coefficient between chlorophyll and ekman transport in S Ocean is: ')
disp(CHLCORRSA);

Nit = NUT.Nit((~isnan(NUT.Nit))&(~isnan(NUT.EkmanTransport)));
NitEk = NUT.EkmanTransport((~isnan(NUT.Nit))&(~isnan(NUT.EkmanTransport)));

NITCORRSA = corrcoef(Nit,NitEk);

disp('The corr coefficient between Nitrate and ekman transport in S Ocean is: ')
disp(NITCORRSA);

DO = AA.Doxy((~isnan(AA.Doxy))&(~isnan(AA.EkTransport)));
DOXYEk = AA.EkTransport((~isnan(AA.Doxy))&(~isnan(AA.EkTransport)));

DOXYCORRSA = corrcoef(DO,DOXYEk);

disp('The corr coefficient between DOXY and ekman transport in S Ocean is: ')
disp(DOXYCORRSA);