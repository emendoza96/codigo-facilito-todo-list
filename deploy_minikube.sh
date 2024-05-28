eval $(minikube -p minikube docker-env)
docker image prune -a -f
kubectl apply -f deployment-prod.yml

AUX_PID=$(lsof -t -i :3000)
if [ -n "$AUX_PID" ]; then
    sudo kill $AUX_PID
fi

sleep 40

nohup kubectl port-forward svc/todo-list-service 3000:3000 --address 0.0.0.0 > /dev/null 2>&1 &