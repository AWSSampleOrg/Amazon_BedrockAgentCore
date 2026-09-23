FROM --platform=linux/arm64 python:3.14-slim

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

USER 1000

EXPOSE 9000

CMD ["python", "a2a_runtime.py"]
