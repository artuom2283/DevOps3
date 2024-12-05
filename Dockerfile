# Этап сборки
FROM alpine AS build

# Установка необходимых инструментов и библиотек
RUN apk add --no-cache build-base make automake autoconf git pkgconfig

# Устанавливаем рабочую директорию
WORKDIR /home/app

# Клонирование репозитория
RUN git clone --branch branchHTTPserver https://github.com/artuom2283/DevOps3.git .

# Компиляция вручную (если нет CMake)
RUN g++ -std=c++17 -o myprogram HTTP_Server.cpp funcA.cpp

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
