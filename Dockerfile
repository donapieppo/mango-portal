FROM python:3.12
WORKDIR /app

# no .pyc and buffer logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

ENV TZ=Europe/Rome

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        tzdata \
        libimage-exiftool-perl \
        poppler-utils \
        ca-certificates \
        curl && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# ARG TIKA_URL=http://localhost:9998/
ARG TIKA_URL=""
ENV TIKA_URL=$TIKA_URL
ENV spOption="ManGO_portal"
ENV API_URL=""
ENV SERVICE_HOST="0.0.0.0"
ENV SERVICE_PORT=3000
ENV MANGO_CONFIG=config_basic.py
ENV IRODS_ZONES_CONFIG=irods_zones_config_minimal.py

COPY src  /app/
COPY unstash/src /app/

# COPY build-labels.json /app/static/build-info.json
# EXPOSE 3000

CMD ["python", "waitress_serve.py"]

