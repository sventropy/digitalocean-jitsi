# Jitsi on Digitalocean with Terraform

This project contains the terraform template and instructions to run [Jitsi](https://jitsi.org) on [digitalocean.com](https://www.digitalocean.com)

## Prerequisites

1. Create an account on [digitalocean.com](https://www.digitalocean.com) (if you don't have one)
2. [Create an access key](https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/) for that digialocean account 
3. [Install terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
4. Check the configuration in `main.tf`, as there are several values hard-coded here, e.g. size small for the ubuntu 18.04 image, Frankfurt as datacenter region, project and droplet names

## Setup steps

1. Run `cp .env.example .env` and enter your digital ocean access key to `.env`
2. Run `cp main.tfvars.example main.tfvars` and enter your ssh key public and private file path and your target hostname for which you want to configure an alias (A) DNS record to the Jitsi server later
3. Run `make create`. This will deploy the SSH public key and create a project and a single droplet running Ubuntu, plus adding the package sources for `jitsi-meet`.
4. Copy the IP address of the droplet from the digital ocean dashboard and paste it to the `.env` file
   - Optional: Setup an alias record (A) with your registrar for the chose `TARGET_URL` and IP address
5. Run `env $(cat .env | xargs) make connect` and execute the following commands after the ssh session is established

```sh
sudo apt-get -y install jitsi-meet
/usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
```

⚠️ Unfortunately, I did not figure out a way to tell the `jitsi-meet` package, about the hostname it should use. Hence the manual steps in **5**. See the `jetsi-meet` [install instructions](https://github.com/jitsi/jitsi-meet/blob/master/doc/quick-install.md) for more info.

## Feedback

Any feedback is welcome. You can find everything you need to know to reach me on [hennessen.net](https://hennessen.net) and [Twitter](https://twitter.com/svenhennessen)

Cheers!