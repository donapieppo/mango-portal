FROM node:22-alpine AS frontend-build
WORKDIR /frontend/src
COPY src/package*.json ./
RUN npm install
COPY src ./
RUN npm run build

FROM python:3.12

# no .pyc and buffer logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

ENV TZ=Europe/Rome

WORKDIR /app
COPY requirements-mango-flow.txt requirements.txt

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        tzdata \
        libimage-exiftool-perl \
        poppler-utils \
        ca-certificates \
        curl && \
    rm -rf /var/lib/apt/lists/*

RUN pip install -r requirements.txt

ENV API_URL=""
ENV SERVICE_HOST="0.0.0.0"
ENV SERVICE_PORT=3000
ENV MANGO_CONFIG=config_basic.py
ENV IRODS_ZONES_CONFIG=irods_zones_config_minimal.py

ARG TIKA_URL=http://localhost:9998/
ENV TIKA_URL=$TIKA_URL
ENV spOption="ManGO_portal"

COPY src  /app/
COPY --from=frontend-build /frontend/src/static/dist /app/static/dist

COPY unstash/src /app/
COPY build-labels.json /app/static/build-info.json

EXPOSE 3000
CMD ["python", "waitress_serve.py"]
