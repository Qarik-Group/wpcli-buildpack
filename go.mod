module github.com/starkandwayne/wpcli-buildpack

go 1.12

require (
	github.com/Masterminds/semver v1.4.2
	github.com/blang/semver v3.5.1+incompatible
	github.com/cloudfoundry/libbuildpack v0.0.0-20190805205250-e22ed19132ff
	github.com/elazarl/goproxy v0.0.0-20190711103511-473e67f1d7d2
	github.com/elazarl/goproxy/ext v0.0.0-20190711103511-473e67f1d7d2
	github.com/fsnotify/fsnotify v1.4.7
	github.com/hpcloud/tail v1.0.0
	github.com/inconshreveable/go-vhost v0.0.0-20160627193104-06d84117953b
	github.com/onsi/ginkgo v1.9.0
	github.com/onsi/gomega v1.6.0
	github.com/pkg/errors v0.8.1
	github.com/rogpeppe/go-charset v0.0.0-20190617161244-0dc95cdf6f31
	github.com/stretchr/testify v1.4.0
	github.com/tidwall/match v1.0.1
	github.com/tidwall/pretty v1.0.0
	golang.org/x/sys v0.0.0-20190825160603-fb81701db80f
	gopkg.in/fsnotify.v1 v1.4.7
	gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7
)

replace github.com/cloudfoundry/libbuildpack => github.com/drnic/libbuildpack v0.0.0-20190527034830-1afd0c251b61
