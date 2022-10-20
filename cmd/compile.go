package cmd

import (
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"
	"text/template"

	"github.com/spf13/cobra"
)

type Env struct {
	Env map[string]string
}

func getEnv() Env {
	env := make(map[string]string)
	for _, e := range os.Environ() {
		p := strings.SplitN(e, "=", 2)
		env[p[0]] = p[1]
	}
	return Env{Env: env}
}

func findAndParseTemplates(rootDir string) (*template.Template, error) {
	cleanRoot := filepath.Clean(rootDir)
	pfx := len(cleanRoot) + 1
	root := template.New("")
	err := filepath.Walk(cleanRoot, func(path string, info os.FileInfo, e1 error) error {
		if !info.IsDir() && strings.HasSuffix(path, ".tmpl") {
			if e1 != nil {
				return e1
			}

			b, e2 := ioutil.ReadFile(path)
			if e2 != nil {
				return e2
			}

			name := path[pfx:]
			println("name", name)
			t := root.New(name).Option("missingkey=error")
			t, e2 = t.Parse(string(b))
			if e2 != nil {
				return e2
			}
		}

		return nil
	})

	return root, err
}

var TemplatesPath string

var compileCmd = &cobra.Command{
	Use:   "compile [filename]",
	Short: "compiles a given template",
	Long:  `compiles a given template`,
	Args:  cobra.MinimumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		file := args[0]
		t, err := os.ReadFile(file)
		if err != nil {
			log.Fatal(err)
		}
		tmp := template.Must(findAndParseTemplates(TemplatesPath))
		c := tmp.New("__current").Option("missingkey=error")
		c, err = c.Parse(string(t))
		if err != nil {
			log.Fatal(err)
		}
		err = tmp.ExecuteTemplate(os.Stdout, "__current", getEnv())
		if err != nil {
			log.Fatal(err)
		}
	},
}

func init() {
	rootCmd.AddCommand(compileCmd)
	compileCmd.Flags().StringVarP(&TemplatesPath, "templatesPath", "t", "templates", "path to templates")
}
