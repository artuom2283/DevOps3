#!/bin/bash

check_container_busy() {
    container=$1
    # Отримуємо використання CPU контейнера
    usage=$(docker stats --no-stream --format "{{.CPUPerc}}" "$container" 2>/dev/null | sed 's/%//')
    if [ -z "$usage" ]; then
        echo "idle"  # Контейнер не активний
        return
    fi
    usage=${usage%%.*}  # Перетворення використання на ціле число
    if [ "$usage" -gt 80 ]; then
        echo "busy"
    else
        echo "idle"
    fi
}

launch_container() {
    container=$1
    core=$2
    echo "Запуск $container на CPU ядрі $core"
    docker run -d --cpuset-cpus="$core" --name "$container" artem2283/newprogram
}

terminate_container() {
    container=$1
    echo "Завершення $container"
    docker stop "$container" && docker rm "$container"
}

update_container() {
    container=$1
    echo "Оновлення $container"
    docker stop "$container"
    docker rm "$container"
    launch_container "$container" "${container: -1}"
}

# Основний цикл
while true; do
    echo "Початок нової ітерації головного циклу"

    # Перевірка, чи srv1 працює
    if ! docker ps --filter "name=srv1" | grep -q "srv1"; then
        echo "srv1 не працює, запускаємо"
        launch_container srv1 0
    fi

    # Перевірка і завершення srv1, якщо він простояв 30 секунд
    if docker ps --filter "name=srv1" | grep -q "srv1"; then
        echo "Перевіряємо, чи srv1 простоює"
        if [ "$(check_container_busy srv1)" == "idle" ]; then
            echo "srv1 простоює, очікуємо 30 секунд перед завершенням"
            sleep 30
            # Перевірка ще раз після 30 секунд
            if [ "$(check_container_busy srv1)" == "idle" ]; then
                echo "srv1 все ще простоює, завершуємо"
                terminate_container srv1
            else
                echo "srv1 більше не простоює, пропускаємо завершення"
            fi
        fi
    else
        echo "srv1 не працює, пропускаємо перевірку простою"
    fi

    # Запуск srv2 після 15 секунд, якщо srv1 зайнятий
    if docker ps --filter "name=srv1" | grep -q "srv1"; then
        echo "srv1 працює, перевіряємо, чи srv2 має бути запущений"
        if [ "$(check_container_busy srv1)" == "busy" ]; then
            sleep 30  
            if ! docker ps --filter "name=srv2" | grep -q "srv2"; then
                echo "Запуск srv2"
                launch_container srv2 1
            fi
        fi
    fi

    # Запуск srv3 після 15 секунд, якщо srv2 зайнятий
    if docker ps --filter "name=srv2" | grep -q "srv2"; then
        echo "srv2 працює, перевіряємо, чи srv3 має бути запущений"
        if [ "$(check_container_busy srv2)" == "busy" ]; then
            sleep 30  
            if ! docker ps --filter "name=srv3" | grep -q "srv3"; then
                echo "Запуск srv3"
                launch_container srv3 2
            fi
        fi
    fi

    # Перевірка і завершення srv2, якщо він простояв 15 секунд
    if docker ps --filter "name=srv2" | grep -q "srv2"; then
        echo "Перевіряємо, чи srv2 простоює"
        if [ "$(check_container_busy srv2)" == "idle" ]; then
            echo "srv2 простоює, очікуємо 30 секунд перед завершенням"
            sleep 30  
            # Перевірка ще раз після 15 секунд
            if [ "$(check_container_busy srv2)" == "idle" ]; then
                echo "srv2 все ще простоює, завершуємо"
                terminate_container srv2
            else
                echo "srv2 більше не простоює, пропускаємо завершення"
            fi
        fi
    else
        echo "srv2 не працює, пропускаємо перевірку простою"
    fi

    # Перевірка і завершення srv3, якщо він простояв 15 секунд (лише після завершення srv2)
    if ! docker ps --filter "name=srv2" | grep -q "srv2"; then
        if docker ps --filter "name=srv3" | grep -q "srv3"; then
            echo "Перевіряємо, чи srv3 простоює"
            if [ "$(check_container_busy srv3)" == "idle" ]; then
                echo "srv3 простоює, очікуємо 30 секунд перед завершенням"
                sleep 30  
                # Перевірка ще раз після 15 секунд
                if [ "$(check_container_busy srv3)" == "idle" ]; then
                    echo "srv3 все ще простоює, завершуємо"
                    terminate_container srv3
                else
                    echo "srv3 більше не простоює, пропускаємо завершення"
                fi
            fi
        else
            echo "srv3 не працює, пропускаємо перевірку простою"
        fi
    fi

    # Перевірка нової версії образу та оновлення контейнерів
    echo "Отримуємо останню версію образу..."
    output=$(docker pull artem2283/newprogram:latest)
    echo "$output"  # Виводимо результат для відладки

    # Перевірка, чи було завантажено новий образ
    if echo "$output" | grep -q "Downloaded newer image"; then
        echo "Знайдено новий образ, оновлюємо контейнери..."
        for container in srv1 srv2 srv3; do
            if docker ps --filter "name=$container" | grep -q "$container"; then
                update_container $container
            fi
        done
    else
        echo "Новий образ не знайдено, пропускаємо оновлення."
    fi

    sleep 30  
done
