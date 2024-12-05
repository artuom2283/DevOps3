# Этап 1: Сборка программы (в временном образе)
FROM golang:1.20 AS builder

# Устанавливаем рабочую директорию для сборки
WORKDIR /go/src/app

# Клонируем репозиторий с программой
RUN git clone https://github.com/твой-репозиторий.git .

# Выполняем сборку программы
RUN go build -o myprogram .

# Этап 2: Создание минимального образа на основе Alpine
FROM alpine:latest

# Устанавливаем необходимые зависимости для работы программы
RUN apk add --no-cache libstdc++ libc6-compat

# Копируем скомпилированный исполняемый файл из первого этапа
COPY --from=builder /go/src/app/myprogram /home/myprogram

# Устанавливаем рабочую директорию
WORKDIR /home

# Устанавливаем точку входа
ENTRYPOINT ["./myprogram"]
