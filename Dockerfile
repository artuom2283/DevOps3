# Этап сборки
FROM alpine AS build

# Установка необходимых инструментов
RUN apk add --no-cache build-base git

# Устанавливаем рабочую директорию
WORKDIR /home

# Клонируем репозиторий
RUN git clone --branch branchHTTPserver https://github.com/artuom2283/DevOps3.git .

# Компиляция вручную
RUN g++ -std=c++17 -o http_server HTTP_Server.cpp funcA.cpp

# Этап минимального образа для запуска
FROM alpine:latest

# Установка необходимых библиотек
RUN apk --no-cache add libstdc++

# Копирование исполняемого файла
COPY --from=build myprogram /usr/local/bin/myprogram

# Открываем порт
EXPOSE 8081

# Установка команды запуска
ENTRYPOINT ["/usr/local/bin/myprogram"]
