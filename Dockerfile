# Dockerfile
FROM python:3.11-slim

WORKDIR /app

# system packages
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        build-essential libpq-dev gettext git \
 && rm -rf /var/lib/apt/lists/*

# copy source (Coolify clones the repo for us)
COPY . .

# python deps
RUN pip install --no-cache-dir -r requirements.txt

# collect static files & translations
RUN python manage.py collectstatic --noinput || true
RUN python manage.py compilemessages || true

# default start command
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh", "gunicorn", "--bind", "0.0.0.0:8000", "horilla.wsgi:application"]
