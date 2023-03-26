# Using GitHub Container Registry with Kubernetes

## Create Access Tokens
https://github.com/settings/tokens

## Create .dockerconfigjson file
```bash
echo -n "username:123123adsfasdf123123" | base64
dXNlcm5hbWU6MTIzMTIzYWRzZmFzZGYxMjMxMjM=
```
Create file with contant:
```bash
{
    "auths":
    {
        "ghcr.io":
            {
                "auth":"dXNlcm5hbWU6MTIzMTIzYWRzZmFzZGYxMjMxMjM="
            }
    }
}
```

## Create kube secret
```bash
kubectl create secret generic <secret name> \
    --from-file=.dockerconfigjson=<path/to/.dockerconfigjson> \
    --type=kubernetes.io/dockerconfigjson
```

## Use secret in kube manifests
```bash
apiVersion: apps/v1
kind: Deployment
spec:
  ...
  template:
    ...
    spec:
      imagePullSecrets:
      - name: <secret name>
```
