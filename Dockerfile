# Первый этап: сборка приложения
FROM gcc:latest AS build

# Устанавливаем рабочую директорию
WORKDIR /usr/src/app

# Клонируем репозиторий из GitHub
RUN git clone --branch branchHTTPserver https://github.com/artuom2283/DevOps3.git .

# Проверяем содержимое директории
RUN ls -la

# Скомпилируем приложение
RUN g++ -std=c++17 -I. -o myprogram HTTP_Server.cpp funcA.cpp

# Второй этап: минимальный образ для запуска
FROM alpine:latest

# Устанавливаем необходимые зависимости
RUN apk --no-cache add libstdc++ libc6-compat

# Устанавливаем рабочую директорию
WORKDIR /home

# Копируем исполняемый файл из первого этапа
COPY --from=build /usr/src/app/myprogram .

# Делаем порт доступным
EXPOSE 8081

# Устанавливаем команду для запуска приложения
ENTRYPOINT ["./myprogram"]
