FROM python:3.11-slim

WORKDIR /app

RUN useradd -ms /bin/bash appuser && chown -R appuser:appuser /app

RUN apt-get update && apt-get install -y build-essential libffi-dev && rm -rf /var/lib/apt/lists/*

USER appuser

ENV PATH="/home/appuser/.local/bin:$PATH"

RUN pip install --no-cache-dir --upgrade pip

COPY --chown=appuser:appuser requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=appuser:appuser src ./src

ENV PYTHONPATH=/app

# Versao gravada na imagem (o CD passa --build-arg APP_VERSION=<tag>).
# Fica depois do pip install para nao invalidar o cache das dependencias.
ARG APP_VERSION=dev
ENV APP_VERSION=$APP_VERSION

EXPOSE 8000

CMD ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8000", "--log-level","info"]
