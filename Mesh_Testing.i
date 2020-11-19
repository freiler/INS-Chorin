[Mesh]
  second_order = true
  [fmg]
    type = FileMeshGenerator
    file = exodus.exo
  []
[]

[Outputs]
  file_base = NACA_test
  exodus = true
[]
