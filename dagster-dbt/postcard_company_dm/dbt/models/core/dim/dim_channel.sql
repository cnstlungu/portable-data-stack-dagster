{{
config(
materialized = 'table',
unique_key = 'channel_key',
schema = 'core'
)
}}


SELECT 
    channel_key, 
    original_channel_id, 
    channel_name
FROM 
    {{ref('staging_channels')}}
