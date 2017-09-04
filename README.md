# Let's Encrypt Alpine
基于的 Alpine 系统的 Docker 镜像，用于提供获取 Let's Encrypt 提供的SSL证书的服务。



## 基本信息

* 镜像地址：endial/certbot-alpine
* 依赖镜像：endial/base-alpine:v3.6



## 数据卷

```
/etc/letsencrypt: 用于存放获取到的SSL证书
/var/lib/letsencrypt
```

证书说明：

1.本案例使用443端口，请保持你的443端口畅通，成功后会在/etc/letsencrypt下生成live/your.domain.com文件夹，里面就是你的证书文件了。

- cert.pem: 申请的服务器证书文件
- privkey.pem: 服务器证书对应的私钥
- chain.pem: 除服务器证书外，浏览器解析所需的其他全部证书，比如根证书和中间证书
- fullchain.pem: 包含服务器证书的全部证书链文件



## 参数说明

```
 
```



## 使用说明

命令行中参数说明：

- me@myort.org：用于域名管理的个人邮箱，需要修改为自己的常用邮箱
- www.myorg.org：需要申请SSL证书的域名
- blog.myorg.org：需要申请SSL证书的子域名

生成并运行一个新的容器（Standalone方式，不建议）：

```
docker run -it --rm \
    -v /etc/letsencrypt:/etc/letsencrypt \
    -p 80:80 -p 443:443 \
    endial/certbot-alpine \
    certonly --standalone \
    --agree-tos \
    -m me@myorg.org \
    -d www.myorg.org \
    -d blog.myorg.org
```

注意：使用Standalone方式时，需要确保防火墙对应的端口已经打开。



生成并运行一个新的容器（Webroot方式，建议）：

```
docker run -it --rm \
	-v /etc/letsencrypt:/etc/letsencrypt \
	-v /srv/www/:/srv/www endial/certbot-alpine \
		certonly --webroot \
		--agree-tos \
		-m me@myorg.org \
		-w /var/www \
		-d www.myorg.org \
		-d blog.myorg.org \
		-w /var/www/webmail \
		-d webmail.myorg.org \
		-d mail.myorg.org
```



生成并运行一个新的容器（使用 endial/dvc-alpine 提供的数据卷）：

```
docker run -it --rm \
    --volumes-from dvc endial/certbot-alpine \
    certonly --webroot \
    --agree-tos \
    -m me@myorg.org \
		-w /srv/www \
		-d www.myorg.org \
		-d blog.myorg.org \
		-d webmail.myorg.org \
		-d mail.myorg.org
```



## 参考：

本容器参考 xataz/docker-letsencrypt 进行修改。
