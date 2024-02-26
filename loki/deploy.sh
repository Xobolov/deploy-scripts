echo "load env.."
. env.sh \
bash ../remove.sh "$CONTAINER_NAME"
docker run \
  --rm \
  --entrypoint htpasswd \
  httpd:2 -Bbn $USERNAME $PASSWORD >> $NGINX_AUTH_PATH/$CONTAINER_NAME/.htpasswd

docker run -d \
    -v $SERVICE_PATH/config:/mnt/config \
    -v $SERVICE_PATH/data:$DATA_PATH \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    --network main \
    grafana/loki:$VERSION \
    -config.file=/mnt/config/$CONFIG_FILE
chmod -R a+rwx $SERVICE_PATH/data
