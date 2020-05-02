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

## Criação de Máquinas
TODO

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
