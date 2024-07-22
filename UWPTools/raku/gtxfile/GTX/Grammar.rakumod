

unit grammar GTX::Grammar;

token TOP		{ <pair>+ }
token pair		{ <string> <value> }
token string	{ \w+ }
token value		{ <pair> || <string> }
