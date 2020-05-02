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
TODO

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
