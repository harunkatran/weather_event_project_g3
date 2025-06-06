WITH weather_daily_raw AS (
                    SELECT airport_code
                            ,station_id
                            ,JSON_ARRAY_ELEMENTS(extracted_data -> 'data') AS json_data
                    FROM {{source('raw_data','weather_daily_Jan2025')}}
),
daily_flattened AS (
                    SELECT airport_code
                            ,station_id
                            ,(json_data ->> 'date')::DATE AS date
                            ,(json_data ->> 'tavg')::NUMERIC AS avg_temp_c
                            ,(json_data ->> 'tmin')::NUMERIC AS min_temp_c
                            ,(json_data ->> 'tmax')::NUMERIC AS max_temp_c
                            ,(json_data ->> 'prcp')::NUMERIC AS precipitation_mm
                            ,(json_data ->> 'snow')::NUMERIC::INTEGER AS max_snow_mm
                            ,(json_data ->> 'wdir')::NUMERIC::INTEGER AS avg_wind_direction
                            ,(json_data ->> 'wspd')::NUMERIC AS avg_wind_speed
                            ,(json_data ->> 'wpgt')::NUMERIC AS avg_peakgust
                            ,(json_data ->> 'pres')::NUMERIC AS avg_pressure_hpa
                            ,(json_data ->> 'tsun')::NUMERIC::INTEGER AS sun_minutes
                        FROM weather_daily_raw
)
SELECT * FROM daily_flattened