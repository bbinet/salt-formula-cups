{%- if pillar.cups is defined %}
include:
{%- if pillar.cups.service is defined %}
- cups.service
{%- endif %}
{%- endif %}
