FROM python:3.9.18-bullseye
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
COPY ./django-app /django-app
WORKDIR /django-app
RUN pip3 install -r requirements.txt
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "polling.wsgi:application"]
EXPOSE 8000