{%- from "cups/map.jinja" import service with context %}
{%- if service.enabled %}

cups_pkgs:
  pkg.latest:
  - names: {{ service.pkgs }}

{%- if service.running %}
cups:
  service.running:
  - require:
    - pkg: cups_pkgs
{%- if grains.get('noservices') %}
  - onlyif: /bin/false
{%- endif %}

cups-browsed:
  service.running:
  - require:
    - pkg: cups_pkgs
{%- if grains.get('noservices') %}
  - onlyif: /bin/false
{%- endif %}

{%- for p, pcfg in service.printers.items() %}

{{ p }}:
  {%- if pcfg.get('enabled', True) %}
  printer.present:
    - description: {{ pcfg.description }}
    - uri: {{ pcfg.uri }}
    {%- if pcfg.location is defined %}
    - location: {{ location }}
    {%- endif %}
    {%- if pcfg.model is defined %}
    - model: {{ pcfg.model }}
    {%- endif %}
    {%- if pcfg.interface is defined %}
    - interface: {{ pcfg.interface }}
    {%- endif %}
    {%- if pcfg.ppd is defined %}
    - ppd: {{ pcfg.ppd }}
    {%- endif %}
    {%- if pcfg.options is defined %}
    - options: {{ pcfg.options | tojson }}
    {%- endif %}

  {%- else %}
  printer.absent:
  {%- endif %}
    - require:
      - service: cups
      - service: cups-browsed

{%- endfor %}

{%- endif %}

{%- endif %}
