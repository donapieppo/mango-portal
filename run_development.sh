docker run --rm -it \
  -v $(pwd)/src:/app \
  -v $(pwd)/unstash/config_unibo.py:/app/config_unibo.py \
  -v $(pwd)/unstash/irods_zones_config_unibo.py:/app/irods_zones_config_unibo.py \
  -p 3000:3000 \
  -e API_URL="https://irods.unibo.it" \
  -e MANGO_CONFIG=config_unibo.py \
  -e IRODS_ZONES_CONFIG=irods_zones_config_unibo.py \
  -e FLASK_ENV=development \
  -e FLASK_DEBUG=1 \
  mango \
  python waitress_serve.py
#   flask run --host=0.0.0.0 --port=3000

