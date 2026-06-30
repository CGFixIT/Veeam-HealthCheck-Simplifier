FROM python:3.13-slim AS base

LABEL maintainer="CGFixIT"
LABEL description="Veeam Health Check Simplifier — processes VBR exports into remediation artifacts"

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY vhc_simplifier.py .

RUN python -m py_compile vhc_simplifier.py

RUN useradd --create-home --shell /bin/bash vhc
USER vhc

ENTRYPOINT ["python", "vhc_simplifier.py"]
CMD ["--demo", "--quiet"]
