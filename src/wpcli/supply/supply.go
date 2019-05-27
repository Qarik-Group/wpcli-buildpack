package supply

import (
	"io"
	"os"
	"path/filepath"

	"github.com/cloudfoundry/libbuildpack"
)

type Stager interface {
	//TODO: See more options at https://github.com/cloudfoundry/libbuildpack/blob/master/stager.go
	BuildDir() string
	DepDir() string
	DepsIdx() string
	DepsDir() string
}

type Manifest interface {
	//TODO: See more options at https://github.com/cloudfoundry/libbuildpack/blob/master/manifest.go
	AllDependencyVersions(string) []string
	DefaultVersion(string) (libbuildpack.Dependency, error)
}

type Installer interface {
	//TODO: See more options at https://github.com/cloudfoundry/libbuildpack/blob/master/installer.go
	InstallDependency(libbuildpack.Dependency, string) error
	InstallOnlyVersion(string, string) error
}

type Command interface {
	//TODO: See more options at https://github.com/cloudfoundry/libbuildpack/blob/master/command.go
	Execute(string, io.Writer, io.Writer, string, ...string) error
	Output(dir string, program string, args ...string) (string, error)
}

type Supplier struct {
	Manifest  Manifest
	Installer Installer
	Stager    Stager
	Command   Command
	Log       *libbuildpack.Logger
}

func (s *Supplier) Run() error {
	s.Log.BeginStep("Supplying wp-cli")

	pancake, err := s.Manifest.DefaultVersion("wp-cli")
	if err != nil {
		return err
	}
	if err := s.Installer.InstallDependency(pancake, s.Stager.DepDir()); err != nil {
		return err
	}

	wpcliBin, err := filepath.Glob(filepath.Join(s.Stager.DepDir(), "wp*"))
	if err != nil {
		return err
	}

	err = os.Rename(wpcliBin[0], filepath.Join(s.Stager.DepDir(), "bin", "wp"))
	if err != nil {
		return err
	}

	err = os.Chmod(filepath.Join(s.Stager.DepDir(), "bin", "wp"), 0755)
	if err != nil {
		return err
	}

	return nil
}
