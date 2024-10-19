%% ARIMA dan Bootstrap
%Membaca File
filename = 'Data Tinggi Muka Air.xlsx';
table = readtable(filename);
columnToTest = 2 ;% example
data_X = table2array(table(:,1));
data_Y = table2array(table(:,columnToTest));

lastValidIndex = find(~isnan(data_Y), 1, 'last');
if ~isempty(lastValidIndex)
    data_Y = data_Y(1:lastValidIndex);
else
    disp('No valid data in the selected column for forecasting.');
end

%Split data for training and testing
train_ratio = 0.7;
train_size = floor(train_ratio * length(data_Y));
train_data = data_Y(1:train_size); %Dibagi 1 dan 2 untuk jaga jaga ada diferensiasi
test_data = data_Y(train_size+1:end);


%Parameter
p = 3; % Lag AR
d = 0; % Orde Diferensiasi
q = 0; % Lag MA
mdl =  estimate(arima(p,d,q), train_data);

% Variabel Bootstrap
B = 12; % Panjang Blok Bootstrap
n = length(train_data) - B +1; % Banyaknya Blok
iterasi_bootstrap = 5;
% Matrix untuk menyimpan koefisien setiap iterasi
AR_coeffs_boot_iter_all = [];
MA_coeffs_boot_iter_all = [];
% Matrix yang menyimpan rata-rata koefisien dari bootstrap
AR_coeffs_bootstrap_mean = [];
MA_coeffs_bootstrap_mean = [];

for i = 1:iterasi_bootstrap
    data_bootstrap = [];
    for j = 1:n
        random = randi([1,n]);
        data_bootstrap = [data_bootstrap,train_data(random:(random + B - 1))'];
    end
    [AR_coeffs_boot_iter_one, MA_coeffs_boot_iter_one] = ARIMA_Bootstrap(p,d,q,data_bootstrap');
    AR_coeffs_boot_iter_all = [AR_coeffs_boot_iter_all; AR_coeffs_boot_iter_one];
    MA_coeffs_boot_iter_all = [MA_coeffs_boot_iter_all; MA_coeffs_boot_iter_one];
end

for i = 1:p
    AR_coeffs_bootstrap_mean = [AR_coeffs_bootstrap_mean, mean(AR_coeffs_boot_iter_all(:,i))];
end

for i = 1:q
    MA_coeffs_bootstrap_mean = [MA_coeffs_bootstrap_mean, mean(MA_coeffs_boot_iter_all(:,i))];
end

boot_mdl = arima('AR', AR_coeffs_bootstrap_mean, 'MA', MA_coeffs_bootstrap_mean, 'Constant', mdl.Constant, 'Variance', mdl.Variance, 'Distribution', mdl.Distribution);