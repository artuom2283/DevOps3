# Этап сборки
FROM alpine AS build

# Установка необходимых инструментов и библиотек
RUN apk add --no-cache build-base make automake autoconf git pkgconfig cmake

# Устанавливаем рабочую директорию
WORKDIR /home/app

# Клонирование репозитория
RUN git clone --branch branchHTTPserver https://github.com/artuom2283/DevOps3.git .

# Выполнение сборки
RUN cmake .
RUN make

# Этап минимального образа для запуска
FROM alpine

# Установка необходимых библиотек для выполнения программы
RUN apk --no-cache add libstdc++

# Копирование исполняемого файла из этапа сборки
COPY --from=build /home/app/myprogram /usr/local/bin/myprogram

# Установка рабочей директории
WORKDIR /home

# Открываем порт
EXPOSE 8081

# Установка команды запуска
ENTRYPOINT ["/usr/local/bin/myprogram"]
