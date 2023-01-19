ARG DT_PYTHON_TAG

# start by pulling the python image
FROM python:$DT_PYTHON_TAG

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# install the dependencies and packages in the requirements file
RUN apk add gcc musl-dev libffi-dev

# copy every content from the local file to the image
COPY ./temp /app

# switch working directory
WORKDIR /app

# install the dependencies and packages in the requirements.txt file
RUN if [[ -f "/app/requirements.txt" ]]; then pip install -r requirements.txt ; fi
# install the dependencies and packages in the poetry file
ARG DT_POETRY_VERSION
RUN if [[ -f "/app/pyproject.toml" ]]; then pip install "poetry==$DT_POETRY_VERSION" && poetry config virtualenvs.create false && poetry install --no-root --no-interaction --no-ansi ; fi

# Delete the project files from image
RUN rm -rf /app

# configure the container to run in an executed manner
ENTRYPOINT ["python"]

CMD ["manage.py", "runserver", "0.0.0.0:5000"]
