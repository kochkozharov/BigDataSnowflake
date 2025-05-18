head -qn 1 исходные\ данные/MOCK_DATA.csv > mock_data_raw.csv
tail -qn +2 исходные\ данные/*.csv >> mock_data_raw.csv