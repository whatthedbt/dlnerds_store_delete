select * from {{ source('file_system', 'customer_raw')}}
