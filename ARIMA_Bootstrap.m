function [AR_coeffs, MA_coeffs] = ARIMA_Bootstrap(p,d,q,data_Y)
mdl = estimate(arima(p,d,q), data_Y);

AR_coeffs = [];
MA_coeffs = [];

% Menyimpan koefisien pada persamaan time series
if p>0
    for i = 1:p
        AR_coeffs = [AR_coeffs, mdl.AR{i}];
    end
end

if q>0
    for i = 1:q
        MA_coeffs = [MA_coeffs, mdl.MA{i}];
    end
end