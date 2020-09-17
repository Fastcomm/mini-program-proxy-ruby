#!/bin/bash

STAGE=${STAGE:=development}
PORT=${PORT:=6000}

RAILS_ENV=${STAGE} bundle exec rails server --port $PORT --binding=0.0.0.0