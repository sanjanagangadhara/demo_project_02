--column name query

{% set json_column_query %}
select distinct json.key as column_names 
from  {{ source('source_table', 'BLOB_DEMO') }},
lateral flatten(input=> RESPONSE) json
{% endset %}


{% set results = run_query(json_column_query) %}

{% if execute %}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}

select
RESPONSE,

{% for column_name in results_list %}
RESPONSE[0]:{{ column_name }} as {{ column_name }} {% if not loop.last %}, {% endif %}
{% endfor %}

from {{ source('source_table', 'BLOB_DEMO') }}
