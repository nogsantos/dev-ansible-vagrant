# Ansible files

Docker container to provisioning with ansible. Enables to create and edit files on the host and run ansible commands in the container.

Use it for development/tests environment

## Premisses

- [Docker](https://docs.docker.com/install/)
- [docker-compose](https://docs.docker.com/compose/install/)
- [Vagrant](https://www.vagrantup.com/)

## Vagrant

**Create a target VM**

```bash
vagrant up
```

_By default, the box is `ubuntu/focal64` named as `ubuntu20`. For more VM options, add them on the `environment.yaml` file_

**Access the box**

```bash
vagrant ssh
```

**Config VM SSH access**

In host,

execute to add in host vagrant config, trust identity

```bash
$ ssh-add $(vagrant ssh-config ubuntu20 | egrep 'IdentityFile .*' | cut -d ' ' -f 4)
```

export VM ssh port to `SSH_PORT`

```bash
$ export SSH_PORT=$(vagrant ssh-config ubuntu20 | egrep 'Port .*' | cut -d ' ' -f 4)
```

## Ansible

**Container up**

```bash
$ docker-compose up -d
```

**View container**

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
...                 ...                 "/bin/bash"         ...                 ...                 22/tcp              ansible
```

In container Ansible work dir is `/etc/ansible`

## Generate the keys

On Host

SSH keys must be generated and hosted in `src/keys` dir.

### Generate ssh keys

_Don't add a passfrase_

```bash
$ ssh-keygen -t rsa -b 4096 -f [key-name] -C [user]
```

### Copy the pubic key to target

```bash
$ ssh-copy-id -i [key-name].pub [user]@[target-address]
```

### Optional: Test the connection

After copy the key, test the access using the private key

```bash
$ ssh -i [private-key] [user]@[target-address]
```

## Configure

In `src/conf/ansible.cfg`, define the default private key

```text
private_key_file = /etc/ansible/keys/ansible
```

Add, or change target hosts in `src/conf/hosts`

## Run the playbook

```bash
$ docker exec -it ansible ansible-playbook playbooks/helloword.yml
```
