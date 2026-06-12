# ktcloud-msa-microservice

The single, generic Helm chart shared by **every** KTCloud MSA service. ArgoCD
renders it (from the `template` branch) against a per-service overlay in
`ktcloud-msa/ktcloud-msa-values` via multi-source `$values`.

## Conventions baked into the templates

- `{{ .Release.Name }}` is the service name — used for the Deployment, Service,
  ConfigMap and pod selector labels. Selector labels are **not** derived from
  the chart name, so the chart can be renamed safely.
- The container runs Spring Boot with
  `--spring.config.location=optional:file:/config/application.yaml`. The whole
  `appConfig:` map from values is rendered into a ConfigMap mounted there — the
  only config-injection mechanism.
- The Service exposes `80 → appConfig.server.port` (default 8080). A second
  `grpc` port (9090) is added **only if `appConfig.grpc.server` is set** — that
  conditional is the contract for whether a service speaks gRPC.

## Optional features (toggled from values)

`templates/` also ships HPA, KEDA `ScaledObject`, PDB, NetworkPolicy, Istio
`VirtualService`/`DestinationRule`/`PeerAuthentication`, canary Deployment,
ServiceMonitor, External Secrets, RBAC and a JWT secret — each gated by a values
flag so a minimal service renders just Deployment + Service + ConfigMap.

## Local render (mirrors what ArgoCD does)

```sh
helm dependency build .
helm template auth-service-release . \
  -f ../ktcloud-msa-values/ktcloud-msa-auth-service/values-release.yaml \
  --namespace ktcloud-market-msa-release
```
