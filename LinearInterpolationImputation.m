function table = LinearInterpolationImputation(filename)
    % Membaca tabel dari file
    table = readtable(filename);

    % Mendapatkan nama-nama kolom numerik
    numeric_column_names = table.Properties.VariableNames(2:end);
    
    % Iterasi melalui setiap kolom numerik
    for col = 1:length(numeric_column_names)
        % Mengonversi data dalam kolom ke dalam bentuk array
        column_data = table2array(table(:, numeric_column_names{col}));
        
        % Menemukan indeks terakhir data valid untuk kolom ini (yg bukan NaN)
        last_valid_index = find(~isnan(column_data), 1, 'last');
        
        % Identifikasi missing values yang bisa diimputasi
        % Cari missing values hanya antara data valid
        missing_indices = find(isnan(column_data(1:last_valid_index)));
        
        % Menggunakan interpolasi linear untuk mengisi nilai yang hilang
        if ~isempty(missing_indices)
            % Mendapatkan indeks dari nilai yang tidak hilang
            valid_indices = find(~isnan(column_data));
            
            % Mendapatkan nilai yang tidak hilang
            valid_data = column_data(valid_indices);
            
            % Menggunakan interpolasi linear
            column_data(missing_indices) = interp1(valid_indices, valid_data, missing_indices, 'linear');
        end
        
        % Mengganti kolom dalam tabel dengan data yang telah diproses
        table.(numeric_column_names{col}) = column_data;
    end
end
