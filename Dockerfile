# Этап сборки
FROM alpine AS build

# Установка необходимых инструментов
RUN apk add --no-cache build-base git

# Устанавливаем рабочую директорию
WORKDIR /home/app

# Клонируем репозиторий
RUN git clone --branch branchHTTPserver https://github.com/artuom2283/DevOps3.git .

# Компиляция вручную
RUN g++ -std=c++17 -I/home/app -o myprogram HTTP_Server.cpp funcA.cpp

# Этап минимального образа для запуска
FROM alpine

# Установка необходимых библиотек
RUN apk --no-cache add libstdc++

# Копирование исполняемого файла
COPY --from=build /home/app/myprogram /usr/local/bin/myprogram

# Открываем порт
EXPOSE 8081

# Установка команды запуска
ENTRYPOINT ["/usr/local/bin/myprogram"]
