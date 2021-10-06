package packages

import (
	"flag"
	"reflect"

	"github.com/chyroc/anbko/env"
)

func init() {
	env.Packages["flag"] = map[string]reflect.Value{
		"Arg":             reflect.ValueOf(flag.Arg),
		"Args":            reflect.ValueOf(flag.Args),
		"Bool":            reflect.ValueOf(flag.Bool),
		"BoolVar":         reflect.ValueOf(flag.BoolVar),
		"CommandLine":     reflect.ValueOf(flag.CommandLine),
		"ContinueOnError": reflect.ValueOf(flag.ContinueOnError),
		"Duration":        reflect.ValueOf(flag.Duration),
		"DurationVar":     reflect.ValueOf(flag.DurationVar),
		"ErrHelp":         reflect.ValueOf(flag.ErrHelp),
		"ExitOnError":     reflect.ValueOf(flag.ExitOnError),
		"Float64":         reflect.ValueOf(flag.Float64),
		"Float64Var":      reflect.ValueOf(flag.Float64Var),
		"Int":             reflect.ValueOf(flag.Int),
		"Int64":           reflect.ValueOf(flag.Int64),
		"Int64Var":        reflect.ValueOf(flag.Int64Var),
		"IntVar":          reflect.ValueOf(flag.IntVar),
		"Lookup":          reflect.ValueOf(flag.Lookup),
		"NArg":            reflect.ValueOf(flag.NArg),
		"NFlag":           reflect.ValueOf(flag.NFlag),
		"NewFlagSet":      reflect.ValueOf(flag.NewFlagSet),
		"PanicOnError":    reflect.ValueOf(flag.PanicOnError),
		"Parse":           reflect.ValueOf(flag.Parse),
		"Parsed":          reflect.ValueOf(flag.Parsed),
		"PrintDefaults":   reflect.ValueOf(flag.PrintDefaults),
		"Set":             reflect.ValueOf(flag.Set),
		"String":          reflect.ValueOf(flag.String),
		"StringVar":       reflect.ValueOf(flag.StringVar),
		"Uint":            reflect.ValueOf(flag.Uint),
		"Uint64":          reflect.ValueOf(flag.Uint64),
		"Uint64Var":       reflect.ValueOf(flag.Uint64Var),
		"UintVar":         reflect.ValueOf(flag.UintVar),
		"Usage":           reflect.ValueOf(flag.Usage),
		"Var":             reflect.ValueOf(flag.Var),
		"Visit":           reflect.ValueOf(flag.Visit),
		"VisitAll":        reflect.ValueOf(flag.VisitAll),
	}
}
