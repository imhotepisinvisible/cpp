# Start resque worker
#
# VERSION 0.1
#
# Builds a new container image and starts resque worker.

FROM rails:latest

WORKDIR /app

ENTRYPOINT ["bundle", "exec"]
CMD ["rake", "resque:work", "QUEUE=*","VERBOSE=1"]