ceph-ansible
============
Ansible playbooks for Ceph, the distributed filesystem.

Please refer to our hosted documentation here: http://docs.ceph.com/ceph-ansible/master/

You can view documentation for our ``stable-*`` branches by substituting ``master`` in the link
above for the name of the branch. For example: http://docs.ceph.com/ceph-ansible/stable-3.0/ 

Manual
------

::

    # ssh into each node:
    firewall-cmd --zone=public --add-service=ceph-mon --permanent
    firewall-cmd --zone=public --add-service=ceph --permanent
    firewall-cmd --zone=public --add-port=6789/tcp --permanent
    firewall-cmd --reload

Run
---

::

    ANSIBLE_HOST_KEY_CHECKING=False --user cephdeploy ansible-playbook -i inventory_file site.yml.sample
