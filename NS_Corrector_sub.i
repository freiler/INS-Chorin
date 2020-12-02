[Mesh]
  second_order = true
  [fmg]
    type = FileMeshGenerator
    file = Re500CoarseMesh.exo
  []
[]
#[Mesh]
#  file = NACA_airfoil_Corr.e
#[]

[Variables]
  [./u]
    order = SECOND
    family = LAGRANGE
    #initial_from_file_var = u
    #initial_from_file_timestep = LATEST

    [./InitialCondition]
      type = ConstantIC
      value = 1.0
    [../]
  [../]
  [./v]
    order = SECOND
    family = LAGRANGE
    #initial_from_file_var = v
    #initial_from_file_timestep = LATEST

    [./InitialCondition]
      type = ConstantIC
      value = 0.0
    [../]
  [../]
[]

[AuxVariables]
  # x-star velocity
  [./u_star]
    order = SECOND
    family = LAGRANGE
    #initial_from_file_var = u_star
    #initial_from_file_timestep = LATEST

    [./InitialCondition]
      type = ConstantIC
      value = 1.0
    [../]
  [../]

  # y-star velocity
  [./v_star]
    order = SECOND
    family = LAGRANGE
    #initial_from_file_var = v_star
    #initial_from_file_timestep = LATEST

    [./InitialCondition]
      type = ConstantIC
      value = 0.05
    [../]
  [../]

  # Pressure
  [./p]
    order = FIRST
    family = LAGRANGE
    #initial_from_file_var = p
    #initial_from_file_timestep = LATEST

    [./InitialCondition]
      type = ConstantIC
      value = 0
    [../]
  [../]

  [./p_current]
    order = FIRST
    family = LAGRANGE
    #initial_from_file_var = p
    #initial_from_file_timestep = LATEST
  [../]

  [./p_old]
    order = FIRST
    family = LAGRANGE
    #initial_from_file_var = p
    #initial_from_file_timestep = LATEST
  [../]
[]

[Kernels]
  [./x_corrector]
    type = NavStokesCorrector_p
    variable = u
    u_star = u_star
    v_star = v_star
    p = p
    p_old = p_old
    component = 0
  [../]

  [./y_corrector]
    type = NavStokesCorrector_p
    variable = v
    u_star = u_star
    v_star = v_star
    p = p
    p_old = p_old
    component = 1
  [../]
[]

[AuxKernels]
  #[./normalization_auxkernel]
  #  type = NormalizationAuxOld
  #  variable = p_old
  #  source_variable = p
  #  normal_factor = 1.0
  #  execute_on = timestep_end
  #  # Note: 'normalization' or 'shift' are provided as CLI args
  #[../]

  [./normalization_auxkernel2]
    type = NormalizationAux
    variable = p_current
    source_variable = p
    normal_factor = 1.0
    execute_on = timestep_end
    # Note: 'normalization' or 'shift' are provided as CLI args
  [../]
[]

[BCs]
  [./x_no_slip]
    type = DirichletBC
    variable = u
    boundary = 'WALL AIRFOIL'
    value = 0.0
  [../]

  [./y_no_slip]
    type = DirichletBC
    variable = v
    boundary = 'WALL AIRFOIL'
    value = 0.0
  [../]

  [./velocity_inlet_x]
    type = DirichletBC
    variable = u
    boundary = 'INLET'
    value = 1.0
  []

  [./velocity_inlet_y]
    type = DirichletBC
    variable = v
    boundary = 'INLET'
    value = 0.0
  []
[]

[Materials]
  [./const]
    type = GenericConstantMaterial
    block = 'SOLID'
    prop_names = 'rho mu'
    prop_values = '1  0.0004'
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    #solve_type = 'NEWTON'
    solve_type = 'LINEAR'
  [../]
[]

[Executioner]
  type = Transient
  #num_steps = 50
  #dt = .1
  #dtmin = .1

  #petsc_options_iname = '-pc_type'
  #petsc_options_value = 'lu'

  #line_search = 'none'
  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-8
  nl_max_its = 6
  l_tol = 1e-6
  l_max_its = 500
[]

[Outputs]
  file_base = NACA_airfoil_Corr
  exodus = true
  checkpoint = true
[]
