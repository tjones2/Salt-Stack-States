# vim: sts=2:ts=2:et:ai

{% for user, details in pillar['normal_user'].iteritems() %}
{{ user }}:
  user.present:
    - home: /home/{{ user }} 
    - password: {{ details['passwd'] }}
    - shell: /bin/bash
    - groups:  {{ details['groups'] }}
{% endfor %}
