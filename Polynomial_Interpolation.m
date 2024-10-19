function data_polinom = Polynomial_Interpolation(filename, order)
    % Membaca tabel dari file
    data_polinom = readtable(filename);

    % Mendapatkan nama-nama kolom numerik, mengasumsikan kolom pertama bukan numerik
    numeric_column_names = data_polinom.Properties.VariableNames(2:end);

    % Interpolasi per kolom numerik
    for col = 1:length(numeric_column_names)
        col_name = numeric_column_names{col};
        column_data = table2array(data_polinom(:, col_name));

        % Menemukan indeks terakhir data valid untuk kolom ini (yg bukan missing)
        last_valid_index = find(~isnan(column_data), 1, 'last');

        % Mengidentifikasi missing values yang bisa diimputasi di antara data valid
        missing_indices = find(isnan(column_data(1:last_valid_index)));

        % Mencari indeks yang tidak kosong di antara data valid
        non_missing_indices = find(~isnan(column_data(1:last_valid_index)));
        non_missing_values = column_data(non_missing_indices);

        % Melakukan interpolasi polinomial jika ada data yang cukup untuk interpolasi
        if length(non_missing_indices) > order
            p = polyfit(non_missing_indices, non_missing_values, order);
            interpolated_values = polyval(p, missing_indices);

            % Mengganti missing values dengan nilai yang diinterpolasi
            column_data(missing_indices) = interpolated_values;

            % Mengganti kolom dalam tabel dengan data yang telah diproses
            data_polinom.(col_name) = column_data;
        end
    end
end
