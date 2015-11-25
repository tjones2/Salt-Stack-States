# vim: sts=2:ts=2:et:ai

{% set vpn = salt['pillar.get']('pptp', {}) %}

#pkg to be installed or to make sure are installed
packages:
  pkg.installed:
    - pkgs: 
      - pptpd

#append pptp.conf
edit_pptp_conf:
  file.append:
    - name: {{ vpn.config }}
    - text:
      - {{ vpn.localip }}
      - {{ vpn.remoteip }}
#users
users_pptp:
  file.append:
    - name: {{ vpn.ppp_chap }}
    - text: {{ vpn.user }}

#Bug Edit to show pptp running https://bugs.launchpad.net/ubuntu/+source/pptpd/+bug/1296835
edit_pptp:
  file.blockreplace:
    - name: /etc/init.d/pptpd
    - marker_start: 'status)'
    - marker_end: ';;'
    - content: 'status_of_proc -p "$PIDFILE" "$DAEMON" "$NAME" && exit 0 || exit $?'
 
#service running
service:
  service.running:
    - name: pptpd
    - watch:
      - file: users_pptp

#edit sysctl/IPtables

{% set ip = salt['pillar.get']('pptp:iptables', {}) %}
{% for iptables in ip %}

edit_{{ iptables }}:
  cmd.run:
    - name: {{ iptables }}
    - order: last

{% endfor %}

