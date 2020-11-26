<p align="center">
<img src="https://img.shields.io/docker/image-size/janrk/git-sync" alt="image-size">
</p>

quay.io/janrk/git-sync


          initContainers:
          - name: gitsync
            image: quay.io/janrk/gitsync:latest
            imagePullPolicy: IfNotPresent
            env:
            - name: GIT_SYNC_REPO
              value: https://github.com/myrepo.git  ##Changing value
            - name: GIT_SYNC_DEST
              value: git-sync
            resources: {}
            securityContext:
              capabilities:
                drop:
                - ALL
              readOnlyRootFilesystem: true
              runAsNonRoot: true
              runAsUser: 1000
            volumeMounts:
            - name: repos
              mountPath: /repos
            - name: sshkey
              mountPath: "/root/.ssh"
              readOnly: true


          volumes:
          - name: sshkey
            secret:
              secretName: github
          - name: repos
            hostPath:
              path: /mnt/kubernetes/repos
              type: Directory
