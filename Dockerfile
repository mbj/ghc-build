FROM registry.hub.docker.com/library/alpine:3.16

# Setup for userns mapped single user
RUN echo $'build:x:0:0:build:/opt/build:/bin/ash\n\
nobody:x:65534:65534:nobody:/:/sbin/nologin\n\A'\
> /etc/passwd
RUN echo $'build:x:0:build\n\
nobody:x:65534:\n\A'\
> /etc/group

# Setup apk public key
RUN echo $'-----BEGIN PUBLIC KEY-----\n\
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmDBxtI4tBKeyOg/jVIRF\n\
I82kpx10xhnxty/Rv/9AoMH231twNowKzJkZeZ9dgri7z7k7Ub1mKmYAdZKSC1Vu\n\
fnuLjbPiIZfZdH+PL2pInV5Yr55QXyoTd+9vC5+L7fI1OrgFVmiRWxKl2nDAUGNl\n\
xQPmHpStAKi+Np9eWgc2xTiImLgnPM7Ofic+4+jJladIA2MMJU7nFYbBY+AypNEa\n\
jEEk+gX7qsv/aP7trT98uuik/xfKK8E2IP4uIisTsPAlbhd/bEob4NkSUrHBCLzX\n\
PnmDDWaQUSHdbuW2x56d76jR9AOPznAi6YgOmhhWYxtn6SiQcOxbD3uIAGF5wQtO\n\
9QIDAQAB\n\
-----END PUBLIC KEY-----'\
>> /etc/apk/keys/mbj.rsa.pub

RUN echo $'\
@mbj https://mbj-apk.s3.dualstack.us-east-1.amazonaws.com\n'\
>> /etc/apk/repositories

# Setup build directory
RUN mkdir -p -m 0700 /opt/build

# Install dependencies
RUN apk add            \
  --no-cache           \
  --                   \
  alex                 \
  autoconf             \
  automake             \
  bash                 \
  binutils-dev         \
  cabal                \
  curl                 \
  file                 \
  g++                  \
  gcc                  \
  ghc                  \
  git                  \
  gmp-dev              \
  grep                 \
  happy                \
  libffi               \
  libffi-dev           \
  linux-headers        \
  make                 \
  musl-dev             \
  musl-locales         \
  ncurses-dev          \
  ncurses-static       \
  ncurses-terminfo     \
  openssl-libs-static  \
  postgresql13-dev@mbj \
  python3              \
  stack@mbj            \
  tar                  \
  xz                   \
  zlib-dev             \
  zlib-static

RUN mkdir /etc/stack && echo $'system-ghc: true\n\
ghc-options:\n\
  $everything: -j -Rghc-timing +RTS -N -A128m -RTS\n'\
>> /etc/stack/config.yaml
