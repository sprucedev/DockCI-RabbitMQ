FROM rabbitmq

RUN rabbitmq-plugins enable --offline rabbitmq_auth_backend_http
RUN rabbitmq-plugins enable --offline rabbitmq_web_stomp

EXPOSE 15674

