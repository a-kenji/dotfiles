; inject into node of pkgs.makeNixosTest.testScript
(
binding
attrpath: (attrpath attr: (identifier) @_test )
expression: (indented_string_expression) @python
(#eq? @_test "testScript")
)
