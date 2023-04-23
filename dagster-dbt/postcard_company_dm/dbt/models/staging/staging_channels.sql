{{ config(schema='staging') }}
with staging_channels as (
select channel_id, channel_name
from {{ref('raw_channels')}}
)
select channel_id as channel_key, channel_id as original_channel_id, channel_name
from staging_channels