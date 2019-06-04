FROM ruby:alpine
LABEL maintainer="Daniel Poßmann <daniel.possmann@boerse-go.de>"

RUN apk add --update ruby-json ca-certificates && \
    gem install -N sinatra && \
    rm -rf /var/cache/apk/*

EXPOSE 4567
ADD . /

ENTRYPOINT ["ruby", "/server.rb"]
CMD ["-o","0.0.0.0"]
