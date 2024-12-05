FROM alpine AS build
RUN apk add --no-cache build-base make automake autoconf git pkgconfig glib-dev gtest-dev gtest cmake

WORKDIR /home/optima
RUN git clone --branch branchHTTPserver https://github.com/artuom2283/DevOps3.git
WORKDIR /home/optima/DevOps3

RUN autoconf
RUN ./configure
RUN cmake

FROM alpine
COPY --from=build /home/optima/DevOps3/myprogram /usr/local/bin/myprogram
ENTRYPOINT ["/usr/local/bin/myprogram"]