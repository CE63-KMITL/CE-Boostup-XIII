# CE-Boostup-XIII-Plan

### [Old UI demo](https://azpepoze.github.io/CE-13_Front-end_DEMO/pages/login/)

### [UI Design](https://www.figma.com/design/DLuSS1PvVuIioo4F5Z2czn/CE-Boostup-XIII)

### [Notion (Private)](https://www.notion.so/1694feb84c898050bf5ff027530773ce?v=16a4feb84c89802287e5000c88848f05)

### [Gantt chart (Public)](https://thinkable-bonsai-731.notion.site/1694feb84c898050bf5ff027530773ce)

## Diagram

![Plan](./Plan.svg)

## docker compose (คร่าวๆ)

```docker
name: "CE-Boostup-XIII"

volumes:
  database_data:


networks:
  default:
    driver: bridge

services:
  backend:
    build: CE-Boostup-XIII-Backend
    container_name: CE-Boostup-XIII-Backend
    environment:
      PORT: 3000
      DB_HOST: "CE-Boostup-XIII-Database"
      DB_PORT: 5432
      DB_USERNAME: ${DB_USERNAME}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_NAME: ${DB_NAME}
      IS_DEVELOPMENT: ${DEV_MODE}
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 500M
        reservations:
          cpus: '0.25'
          memory: 100M
    ports:
      - 3000:3000
    depends_on:
      - database
    restart: always

  frontend:
    build: CE-Boostup-XIII-Frontend
    container_name: CE-Boostup-XIII-Frontend
    environment:
      IS_DEVELOPMENT: ${DEV_MODE}
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 500M
        reservations:
          cpus: '0.25'
          memory: 100M
    ports:
      - 3001:3001
    restart: always

  compiler:
    build: CE-Boostup-XIII-Compiler
    container_name: CE-Boostup-XIII-Compiler
    environment:
      IS_DEVELOPMENT: ${DEV_MODE}
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 500M
        reservations:
          cpus: '0.25'
          memory: 100M
    ports:
      - 3002:3002
    restart: always

  database:
    image: postgres
    container_name: CE-Boostup-XIII-Database
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 500M
        reservations:
          cpus: '0.25'
          memory: 100M
    environment:
      POSTGRES_USER: ${DB_USERNAME}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    ports:
      - 5432:5432
    volumes:
      - database_data:/var/lib/postgresql/data
    restart: always
```
