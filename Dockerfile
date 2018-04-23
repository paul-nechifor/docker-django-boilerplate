FROM python:3.6-alpine

RUN set -ex && \
    apk add --no-cache --virtual .build-deps \
        gcc \
        make \
        libc-dev \
        musl-dev \
        linux-headers \
        pcre-dev \
        postgresql-dev && \
    pip install --no-cache-dir \
        'Django>=2.0,<2.1' \
        'psycopg2>=2.7.4,<2.8' \
        'uwsgi>=2.0.17,<2.1' && \
    apk add --virtual .python-rundeps libcrypto1.0 libpq libssl1.0 musl pcre zlib && \
    apk del .build-deps && \
    addgroup -g 1000 -S user && \
    adduser -g 1000 -S user -G user && \
    mkdir /app

WORKDIR /app
USER user
ADD ./src/ /app/
# RUN ./manage.py migrate

EXPOSE 8000

ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE=project.settings
ENV UWSGI_WSGI_FILE=project/wsgi.py
ENV UWSGI_HTTP=:8000
ENV UWSGI_MASTER=1
ENV UWSGI_WORKERS=2
ENV UWSGI_THREADS=8
ENV UWSGI_UID=1000
ENV UWSGI_GID=1000
ENV UWSGI_LAZY_APPS=1
ENV UWSGI_WSGI_ENV_BEHAVIOR=holy

CMD ["uwsgi", "--http-auto-chunked", "--http-keepalive"]
