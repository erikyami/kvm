# Utilizando Hypervisor KVM

KVM (Kernel-based Virtual Machine) é uma solução de virtualização completa para Linux com hardware x86 que possuem extensões de virtualização (Intel VT ou AMD-V). Consiste de um módulo kernel carregável (kvm.ko), este módulo provê o núcleo infraestrutura de virtualização e um módulo específico para processador, kvm-intel.ko ou kvm-amd.ko.

Usando KVM, é possível executar várias Máquinas Virtuais rodando imagens Linux ou Windows sem modificação. Cada máquina virtual tem seu próprio hardware virtual: placa de rede, disco, adaptador gráfico, etc.

KVM é um software de código aberto. O componente kernel do KVM foi embutido no Linux na versão 2.6.20 do kernel.


## Prerequisitos

Verificando se o computador tem suporte a extensão de virtualização

```
grep -E 'vmx|svm' /proc/cpuinfo
```

## Instalação

### Fedora

```
$ dnf groupinfo virtualization


Group: Virtualization
Group-Id: virtualization
Description: These packages provide a virtualization environment.

Mandatory Packages:
   =virt-install

Default Packages:
   =libvirt-daemon-config-network
   =libvirt-daemon-kvm
   =qemu-kvm
   =virt-manager
   =virt-viewer

Optional Packages:
   guestfs-browser
   libguestfs-tools
   python-libguestfs
   virt-top
```

O seguinte comando vai instalar o pacote obrigatório e os pacotes padrões:

```
# dnf install @virtualization
```

Se quiser instalar os pacotes opcionais pode usar o comando:

```
# dnf group install --with-optional virtualization
```

Depois da instalação, iniciar o serviço libvirtd:

```
# systemctl start libvirtd
```

Para configurar a inicialização durante o boot:

```
# systemctl enable libvirtd
```

Para verificar se os módulos KVM foram carregados corretamente:

```
$ lsmod | grep kvm
kvm_amd                55563  0
kvm                   419458  1 kvm_amd
```

Se o comando listar **kvm_intel** ou **kvm_amd**, o KVM estará configurado no seu ambiente.

Fonte: https://docs.fedoraproject.org/en-US/quick-docs/getting-started-with-virtualization/index.html


## Networking

Por padrão, libvirt vai criar uma rede privada para suas VMs (guests) na máquina host.

Esta rede privada vai usar a subrede 192.168.x.x e não será acessível diretamente pela rede da máquina hospedeira (host). Porém, as máquinas virtuais podem usar a máquina host como um gateway e assim terem acesso ao mundo externo através dela. Se você precisar de serviçospara suas VMs e ter conectividade com outras máquinas de sua rede, você pode usar regras DNAT de iptables para realizar o forward em portas específicas, ou você pode configurar um ambiente em bridge (ponte).

Veja a [página de configuração de rede (libvirt)](https://wiki.libvirt.org/page/Networking) para mais informações de como configurar uma rede bridge.

## Criação de Máquinas

### Criando um guest com virt-install

`virt-install` é uma ferramenta de linha de comando para criar guests virtualizados.

Execute `virt-install --help` para acessar o help, ou você pode obter mais informações na página de manual em `man 1 virt-install`.

### Planejando Recursos da VM

Ajustar a RAM, vCPUs, e tamanho de Disco de acordo os recursos que estão disponíveis;

- Storage: Uma forma fácil de checar o tamanho de disco a partir do shell é utilizando o comando `df`:

```
# df -h
```

- Memória: Você pode checar sua memória disponível usando `free`:

```
# free -h
```

- vCPU: Você pode checar informações de seu processdor usando `lscpu`:

```
# lscpu
```

Ao alocar recursos para sua VM, tenha em mente os requisitos mínimos para a instalação do SO a ser instalado.


### Criando o disco para a VM

Por padrão, o libvirt storage pool fica em `/var/lib/libvirt/images`

Criando um disco de 20G no formato `qcow2`

```
# qemu-img create -f qcow2 /var/lib/libvirt/images/disco.qcow2 20G
```

### Criando a VM

Após verificar os recursos disponíveis no host, criar o disco rígido, é hora de criar de fato a VM:

```
NOME_VM='CentOS8'
DESCRICAO='Maquina CentOS 8'
RAM=2048
VCPUS=2
VARIANTE='centos8'
ISO='/mnt/dados/ISOs/CentOS-8/CentOS-8-x86_64-1905-dvd1/CentOS-8-x86_64-1905-dvd1.iso'

qemu-img create -f qcow2 /var/lib/libvirt/images/${NOME_VM}.qcow2 20G

virt-install --name ${NOME_VM} \
--description "${DESCRICAO}" \
--ram ${RAM} \
--vcpus ${VCPUS} \
--disk path=/var/lib/libvirt/images/${NOME_VM}.qcow2 \
--os-type linux \
--os-variant ${VARIANTE} \
--network bridge=virbr0 \
--graphics vnc,listen=127.0.0.1,port=5901 \
--cdrom ${ISO}

```

## Adicionando Discos

É possível adicionar novos discos a uma VM já criada. No exemplo abaixo será criado um disco `qcow2` de 4G de armazenamento.

Criando o disco:

```
qemu-img create -f qcow2 /var/lib/libvirt/images/${NOME_VM}-disco1.qcow2 4G
```

Realizando o `attach` do disco na VM:


```
sudo virsh -c qemu:///system attach-disk --domain ${NOME_VM} \
--source /var/lib/libvirt/images/${NOME_VM}-disco1.qcow2 \
--target vdc --persistent --subdriver qcow2
```

## Consultas

Listar Máquinas Virtuais:

```
$ virsh -c qemu:///system list --all
 Id   Nome                       Estado
--------------------------------------------
 -    centos7.0                  desligado
 -    k8s_master.hl.local        desligado
 -    k8s_node01.hl.local        desligado
 -    k8s_node02.hl.local        desligado
 -    nfs_nfs.hl.local           desligado
```
