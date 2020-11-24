FROM ruby:2.7

WORKDIR /app
COPY . .

RUN script/bootstrap

EXPOSE 5000
ENTRYPOINT ["script/server"]
