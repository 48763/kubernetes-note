# Contexts

Context 是 Kubernetes Api 的連線配置，配置會有三大部分: [`clusters`](#clusters) 、 [`users`](#user) 和 [`contexts`](#context) ，各個解釋如下: 

```
clusters:
- cluster:
    server: # Kubernetes Api 的連線資訊
    certificate-authority-data: # Kubernetes Api 的證書
  name: # cluster 的自定義名稱
contexts:
- context:
    cluster: # 指定 cluster 的名稱
    user: # 指定 user 的名稱
  name: # context 的自定義名稱
users:
- name: # user 的自定義名稱
  user:
    token: 
```

### cluster

該資訊可以從本機的 `.kube/config` 中找到。

### user

`token` 是從部署到目標叢集的 `ServiceAccount`，其所綁定的 `Secret` 獲取。

> 在[文章後半段](#創建-serviceaccount)會教。

### context

將 `.kube/config` 配置內的 `cluster` 和 `user` 進行綁定。

## 創建 ServiceAccount

複製模板: 

```
$ cp -r template <name>
```

進入剛剛複製的新目錄，只要修改 `argocd-ns-admin-role` 中的 `namespace`，改為要管理的名稱:

```
metadata:
  name: argocd-ns-admin
  namespace: <namespace_name>
```

> 如果有多個 `namespace` 要管理，在同文件中向下複製對應數量的 `Role` 和 `RoleBinding`，然後修改 `namespace`。

使用下面指令獲取 `ServiceAccount` 對應 `secret` 內的 `token`: 

```
$ kubectl get -n kube-system secret argocd-manager-token -o jsonpath="{.data.token}" | base64 -d
```

把獲得的 `token` 貼回去 `context` 中，就能完成連線相關的配置。

## 添加 context 到 ArgoCD

將 `context` 進行編碼，並複製:

```
$ cat context | base64
```

到 ***argocd-server*** 執行下面指令，將複製的內容，輸出到 `context`:

```
$ echo "<past_base64_encode>" | base64 -d > context
```

在 ArgoCD 配置叢集的連線資訊:

```
$ argocd cluster --kubeconfig context add <cluster_name> --service-account argocd-manager --namespace <namespace_name>,<namespace_name1>
```

使用下面指令添加新的 `namespace`:

```
$ argocd cluster set <cluster_name> --namespace <namespace_name>,<namespace_name1>,<new_namespace_name>
```
