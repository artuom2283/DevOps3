FROM alpine AS build
RUN apk add --no-cache build-base make automake autoconf git pkgconfig glib-dev gtest-dev gtest cmake perl m4 libtool

WORKDIR /home/optima
RUN git clone --branch branchHTTPserver https://github.com/artuom2283/DevOps3.git
WORKDIR /home/optima/DevOps3

RUN aclocal
RUN autoconf
RUN ./configure
RUN cmake
RUN make clean
RUN make

FROM alpine
RUN apk add --no-cache libstdc++ libgcc
COPY --from=build /home/optima/DevOps3/myprogram /usr/local/bin/myprogram
RUN chmod +x /usr/local/bin/myprogram
ENTRYPOINT ["/usr/local/bin/myprogram"]