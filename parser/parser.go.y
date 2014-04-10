%{
package parser

import (
	"github.com/mattn/anko/ast"
)

%}

%type<stmts> stmts
%type<stmt> stmt
%type<stmt_if> stmt_if
%type<stmt_default> stmt_default
%type<stmt_case> stmt_case
%type<stmt_cases> stmt_cases
%type<expr> expr
%type<exprs> exprs
%type<expr_lhs> expr_lhs
%type<expr_lhss> expr_lhss
%type<expr_pair> expr_pair
%type<expr_pairs> expr_pairs
%type<expr_idents> expr_idents

%union{
	stmt_if                ast.Stmt
	stmt_default           ast.Stmt
	stmt_case              ast.Stmt
	stmt_cases             []ast.Stmt
	stmts                  []ast.Stmt
	stmt                   ast.Stmt
	expr                   ast.Expr
	exprs                  []ast.Expr
	expr_lhs               ast.Expr
	expr_lhss              []ast.Expr
	expr_pair              ast.Expr
	expr_pairs             []ast.Expr
	expr_idents            []string
	tok                    Token
}

%token<tok> IDENT NUMBER STRING ARRAY VARARG FUNC RETURN VAR THROW IF ELSE FOR IN EQEQ NEQ GE LE OROR ANDAND NEW TRUE FALSE NIL MODULE TRY CATCH FINALLY PLUSEQ MINUSEQ MULEQ DIVEQ ANDEQ OREQ BREAK CONTINUE PLUSPLUS MINUSMINUS POW SHIFTLEFT SHIFTRIGHT SWITCH CASE DEFAULT

%right '='
%right '?' ':'
%left OROR
%left ANDAND
%left IDENT
%nonassoc EQEQ NEQ ','
%left '>' GE '<' LE SHIFTLEFT SHIFTRIGHT

%left '+' '-' PLUSPLUS MINUSMINUS
%left '*' '/' '%'
%right UNARY

%%

stmts :
	{
		$$ = nil
		if l, ok := yylex.(*Lexer); ok {
			l.stmts = $$
		}
	}
	| stmt stmts
	{
		$$ = append([]ast.Stmt{$1}, $2...)
		if l, ok := yylex.(*Lexer); ok {
			l.stmts = $$
			$1.SetPos(l.pos);
		}
	}
	| stmt ';' stmts
	{
		$$ = append([]ast.Stmt{$1}, $3...)
		if l, ok := yylex.(*Lexer); ok {
			l.stmts = $$
			$1.SetPos(l.pos);
		}
	}

stmt : expr
	{
		$$ = &ast.ExprStmt{Expr: $1}
	}
	| BREAK
	{
		$$ = &ast.BreakStmt{}
	}
	| CONTINUE
	{
		$$ = &ast.ContinueStmt{}
	}
	| RETURN exprs
	{
		$$ = &ast.ReturnStmt{Exprs: $2}
	}
	| THROW expr
	{
		$$ = &ast.ThrowStmt{Expr: $2}
	}
	| MODULE IDENT '{' stmts '}'
	{
		$$ = &ast.ModuleStmt{Name: $2.lit, Stmts: $4}
	}
	| VAR expr_idents '=' exprs
	{
		$$ = &ast.VarStmt{Names: $2, Exprs: $4}
	}
	| stmt_if
	{
		$$ = $1
	}
	| FOR IDENT IN expr '{' stmts '}'
	{
		$$ = &ast.ForStmt{Var: $2.lit, Value: $4, Stmts: $6}
	}
	| FOR '{' stmts '}'
	{
		$$ = &ast.LoopStmt{Stmts: $3}
	}
	| FOR expr '{' stmts '}'
	{
		$$ = &ast.LoopStmt{Expr: $2, Stmts: $4}
	}
	| FOR expr ';' expr ';' expr '{' stmts '}' 
	{
		$$ = &ast.CForStmt{Expr1: $2, Expr2: $4, Expr3: $6, Stmts: $8}
	}
	| TRY '{' stmts '}' CATCH IDENT '{' stmts '}' FINALLY '{' stmts '}'
	{
		$$ = &ast.TryStmt{Try: $3, Var: $6.lit, Catch: $8, Finally: $12}
	}
	| TRY '{' stmts '}' CATCH '{' stmts '}' FINALLY '{' stmts '}'
	{
		$$ = &ast.TryStmt{Try: $3, Catch: $7, Finally: $11}
	}
	| TRY '{' stmts '}' CATCH IDENT '{' stmts '}'
	{
		$$ = &ast.TryStmt{Try: $3, Var: $6.lit, Catch: $8}
	}
	| TRY '{' stmts '}' CATCH '{' stmts '}'
	{
		$$ = &ast.TryStmt{Try: $3, Catch: $7}
	}

	| SWITCH expr '{' stmt_cases '}'
	{
		$$ = &ast.SwitchStmt{Expr: $2, Cases: $4}
	}

stmt_if : stmt_if ELSE IF expr '{' stmts '}'
	{
		$1.(*ast.IfStmt).ElseIf = append($1.(*ast.IfStmt).ElseIf, &ast.IfStmt{If: $4, Then: $6})
	}
	| stmt_if ELSE '{' stmts '}'
	{
		if $$.(*ast.IfStmt).Else != nil {
			yylex.Error("multiple else statement")
		} else {
			$$.(*ast.IfStmt).Else = append($$.(*ast.IfStmt).Else, $4...)
		}
	}
	| IF expr '{' stmts '}'
	{
		$$ = &ast.IfStmt{If: $2, Then: $4, Else: nil}
	}

stmt_cases :
	{
		$$ = []ast.Stmt{}
	}
	| stmt_case
	{
		$$ = []ast.Stmt{$1}
	}
	| stmt_cases stmt_case
	{
		$$ = append($1, $2)
	}
	| stmt_default
	{
		$$ = []ast.Stmt{$1}
	}
	| stmt_cases stmt_default
	{
		for _, stmt := range $1 {
			if _, ok := stmt.(*ast.DefaultStmt); ok {
				yylex.Error("multiple default statement")
			}
		}
		$$ = append($1, $2)
	}

stmt_case : CASE expr ':' stmts
	{
		$$ = &ast.CaseStmt{Expr: $2, Stmts: $4}
	}

stmt_default : DEFAULT ':' stmts
	{
		$$ = &ast.DefaultStmt{Stmts: $3}
	}

expr_pair : STRING ':' expr
	{
		$$ = &ast.PairExpr{Key: $1.lit, Value: $3}
	}

expr_pairs :
	{
		$$ = []ast.Expr{}
	}
	| expr_pair
	{
		$$ = []ast.Expr{$1}
	}
	| expr_pairs ',' expr_pair
	{
		$$ = append($1, $3)
	}

expr_idents :
	{
		$$ = []string{}
	}
	| IDENT
	{
		$$ = []string{$1.lit}
	}
	| expr_idents ',' IDENT
	{
		$$ = append($1, $3.lit)
	}

expr_lhs : IDENT
	{
		$$ = &ast.IdentExpr{Lit: $1.lit}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '.' IDENT
	{
		$$ = &ast.MemberExpr{Expr: $1, Name: $3.lit}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '[' expr ']'
	{
		$$ = &ast.ItemExpr{Value: $1, Index: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}

expr_lhss :
	{
		$$ = []ast.Expr{}
	}
	| expr_lhs
	{
		$$ = []ast.Expr{$1}
	}
	| expr_lhs ',' expr_lhss
	{
		$$ = append([]ast.Expr{$1}, $3...)
	}

exprs :
	{
		$$ = []ast.Expr{}
	}
	| expr
	{
		$$ = []ast.Expr{$1}
	}
	| expr ',' exprs
	{
		$$ = append([]ast.Expr{$1}, $3...)
	}
	| IDENT ',' exprs
	{
		$$ = append([]ast.Expr{&ast.IdentExpr{Lit: $1.lit}}, $3...)
	}

expr : NUMBER
	{
		$$ = &ast.NumberExpr{Lit: $1.lit}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| IDENT
	{
		$$ = &ast.IdentExpr{Lit: $1.lit}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| '-' expr %prec UNARY
	{
		$$ = &ast.UnaryExpr{Operator: "-", Expr: $2}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| '!' expr %prec UNARY
	{
		$$ = &ast.UnaryExpr{Operator: "!", Expr: $2}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| '^' expr %prec UNARY
	{
		$$ = &ast.UnaryExpr{Operator: "^", Expr: $2}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| '&' IDENT %prec UNARY
	{
		$$ = &ast.AddrExpr{Expr: &ast.IdentExpr{Lit: $2.lit}}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| '&' expr '.' IDENT %prec UNARY
	{
		$$ = &ast.AddrExpr{Expr: &ast.MemberExpr{Expr: $2, Name: $4.lit}}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| '*' IDENT %prec UNARY
	{
		$$ = &ast.DerefExpr{Expr: &ast.IdentExpr{Lit: $2.lit}}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| '*' expr '.' IDENT %prec UNARY
	{
		$$ = &ast.DerefExpr{Expr: &ast.MemberExpr{Expr: $2, Name: $4.lit}}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| STRING
	{
		$$ = &ast.StringExpr{Lit: $1.lit}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| TRUE
	{
		$$ = &ast.ConstExpr{Value: $1.lit}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| FALSE
	{
		$$ = &ast.ConstExpr{Value: $1.lit}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| NIL
	{
		$$ = &ast.ConstExpr{Value: $1.lit}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '?' expr ':' expr
	{
		$$ = &ast.TernaryOpExpr{Expr: $1, Lhs: $3, Rhs: $5}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '.' IDENT
	{
		$$ = &ast.MemberExpr{Expr: $1, Name: $3.lit}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| FUNC '(' expr_idents ')' '{' stmts '}'
	{
		$$ = &ast.FuncExpr{Args: $3, Stmts: $6}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| FUNC '(' IDENT VARARG ')' '{' stmts '}'
	{
		$$ = &ast.FuncExpr{Args: []string{$3.lit}, Stmts: $7, VarArg: true}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| FUNC IDENT '(' expr_idents ')' '{' stmts '}'
	{
		$$ = &ast.FuncExpr{Name: $2.lit, Args: $4, Stmts: $7}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| FUNC IDENT '(' IDENT VARARG ')' '{' stmts '}'
	{
		$$ = &ast.FuncExpr{Name: $2.lit, Args: []string{$4.lit}, Stmts: $8, VarArg: true}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| '[' exprs ']'
	{
		$$ = &ast.ArrayExpr{Exprs: $2}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| '{' expr_pairs '}'
	{
		mapExpr := make(map[string]ast.Expr)
		for _, v := range $2 {
			mapExpr[v.(*ast.PairExpr).Key] = v.(*ast.PairExpr).Value
		}
		$$ = &ast.MapExpr{MapExpr: mapExpr}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| '(' expr ')'
	{
		$$ = &ast.ParenExpr{SubExpr: $2}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| NEW IDENT '(' exprs ')'
	{
		$$ = &ast.NewExpr{Name: $2.lit, SubExprs: $4}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '+' expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "+", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '-' expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "-", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '*' expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "*", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '/' expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "/", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '%' expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "%", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr POW expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "**", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr SHIFTLEFT expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "<<", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr SHIFTRIGHT expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: ">>", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr EQEQ expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "==", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr NEQ expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "!=", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '>' expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: ">", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr GE expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: ">=", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '<' expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "<", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr LE expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "<=", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr_lhss '=' exprs
	{
		$$ = &ast.LetsExpr{Lhss: $1, Operator: "=", Rhss: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| IDENT PLUSEQ expr
	{
		$$ = &ast.AssocExpr{Name: $1.lit, Operator: "+=", Expr: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| IDENT MINUSEQ expr
	{
		$$ = &ast.AssocExpr{Name: $1.lit, Operator: "-=", Expr: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| IDENT MULEQ expr
	{
		$$ = &ast.AssocExpr{Name: $1.lit, Operator: "*=", Expr: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| IDENT DIVEQ expr
	{
		$$ = &ast.AssocExpr{Name: $1.lit, Operator: "/=", Expr: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| IDENT ANDEQ expr
	{
		$$ = &ast.AssocExpr{Name: $1.lit, Operator: "&=", Expr: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| IDENT OREQ expr
	{
		$$ = &ast.AssocExpr{Name: $1.lit, Operator: "|=", Expr: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| IDENT PLUSPLUS
	{
		$$ = &ast.AssocExpr{Name: $1.lit, Operator: "++"}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| IDENT MINUSMINUS
	{
		$$ = &ast.AssocExpr{Name: $1.lit, Operator: "--"}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '|' expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "|", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr OROR expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "||", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '&' expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "&", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr ANDAND expr
	{
		$$ = &ast.BinOpExpr{Lhs: $1, Operator: "&&", Rhs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| IDENT '(' exprs ')'
	{
		$$ = &ast.CallExpr{Name: $1.lit, SubExprs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| IDENT '[' expr ']'
	{
		$$ = &ast.ItemExpr{Value: &ast.IdentExpr{Lit: $1.lit}, Index: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '[' expr ']'
	{
		$$ = &ast.ItemExpr{Value: $1, Index: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}
	| expr '(' exprs  ')'
	{
		$$ = &ast.AnonCallExpr{Expr: $1, SubExprs: $3}
		if l, ok := yylex.(*Lexer); ok { $$.SetPos(l.pos) }
	}

%%
