# Install Wordpress CLI with a Cloud Foundry buildpack

If you have deployed Wordpress to Cloud Foundry then it maybe desirable to have the [`wp` CLI](https://wp-cli.org/) available when you `cf ssh` into your application container.

For example,

```plain
# cf ssh wordpress
$ /tmp/lifecycle/shell
$ wp plugin list
+-------------------+----------+--------+---------+
| name              | status   | update | version |
+-------------------+----------+--------+---------+
| aryo-activity-log | active   | none   | 2.5.2   |
| akismet           | inactive | none   | 4.1.2   |
| hello             | inactive | none   | 1.7.2   |
| s3-uploads        | active   | none   | 2.0.0   |
+-------------------+----------+--------+---------+
```

Learn more about the `wp` CLI in the [handbook](https://make.wordpress.org/cli/handbook/).

Inside `cf ssh`, the `wp` helper is already configured with the `--path=$HOME/htdocs` where Wordpress will be installed by the [php-buildpack](https://github.com/cloudfoundry/php-buildpack).

The `wp-cli` release included in the buildpack is updated automatically via a [CI job](https://ci2.starkandwayne.com/teams/cfcommunity/pipelines/wpcli-buildpack), which bumps `manifest.yml`.

## Buildpack Developer Documentation

To build this buildpack, run the following command from the buildpack's directory:

1. Source the .envrc file in the buildpack directory.

    ```bash
    source .envrc
    ```

    To simplify the process in the future, install [direnv](https://direnv.net/) which will automatically source .envrc when you change directories.

1. Install buildpack-packager

    ```bash
    ./scripts/install_tools.sh
    ```

1. Build the buildpack

    ```bash
    buildpack-packager build -stack cflinuxfs3 -cached
    ```

1. Use in Cloud Foundry

    Upload the buildpack to your Cloud Foundry.

    ```bash
    cf create-buildpack wpcli_buildpack wpcli_buildpack-*.zip 100
    ```

    Add `wpcli_buildpack` into your application's manifest.yml:

    ```yaml
    applications:
    - name: wordpress
      buildpacks:
      - wpcli_buildpack
      - php_buildpack
    ```

    If your Cloud Foundry platform operators have not yet added `wpcli_buildpack`, then you can use this buildpack via its Git URL:

    ```yaml
    applications:
    - name: wordpress
      buildpacks:
      - https://github.com/starkandwayne/wpcli-buildpack
      - php_buildpack
    ```

### Testing

Buildpacks use the [Cutlass](https://github.com/cloudfoundry/libbuildpack/cutlass) framework for running integration tests.

To test this buildpack, run the following command from the buildpack's directory:

1. Source the .envrc file in the buildpack directory.

    ```bash
    source .envrc
    ```

    To simplify the process in the future, install [direnv](https://direnv.net/) which will automatically source .envrc when you change directories.

1. Run integration tests

    ```bash
    cf cs p-mysql 10mb db
    ./scripts/integration.sh
    ```

    To run integration tests against CFDev:

    ```bash
    cf login -a https://api.dev.cfdev.sh --skip-ssl-validation -u admin -p admin
    cf cs p-mysql 10mb db
    CUTLASS_SCHEMA=https CUTLASS_SKIP_TLS_VERIFY=true ./scripts/integration.sh
    ```

    More information can be found on Github [cutlass](https://github.com/cloudfoundry/libbuildpack/cutlass).

### Reporting Issues

Open an issue on this project.