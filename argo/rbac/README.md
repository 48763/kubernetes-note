# 創建用戶

在 `user.yml` 添加一新用戶 `yayuyo`:

```
$ vi user.yml
...
data:
  # add an additional local user with apiKey and login capabilities
  #   apiKey - allows generating API keys
  #   login - allows to login using UI
  accounts.yayuyo: login
```

連進 POD - `argocd-server`，使用下面指令更新用戶 `yayuyo` 的密碼:

```
$ argocd account update-password --account yayuyo
```

> 新創建的用戶密碼初始化，也需要使用該命令

授予用戶 `yayuyo` 專案 `admin` 權限

```
$ vi project.yml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
...
spec:
  ...
  roles:
    - name: admin
      description: Admin privileges to project
      policies:
        - p, proj:project:admin, applications, *, *, allow
      groups:
        - yayuyo
```

> [RBAC Model Structure](https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/#rbac-model-structure)
