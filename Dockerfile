FROM python:3.6-slim

ENV FLASK_APP=/workspace/app/main.py
ENV PYTHONPATH=/workspace/:$PYTHONPATH

WORKDIR /workspace

ADD ./requirements.txt .

RUN pip install -r requirements.txt

ADD ./app ./app

CMD ["flask", "run", "--host=0.0.0.0"]
