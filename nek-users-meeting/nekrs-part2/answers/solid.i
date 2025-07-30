pebble_diameter = 0.03
thermal_conductivity = 2.0

[Mesh]
  [sphere]
    type = SphereMeshGenerator
    radius = ${fparse pebble_diameter / 2.0}
    nr = 3 # refinment level
  []
[]

[Variables]
  [temp] # the unknown of the pde, when we have a variable we have to have a kernel
  # defult is lagrnage, first, but we can do second 
  []
[]

[Kernels]
  [hc]
    type = HeatConduction 
    variable = temp
  []
  [heat]
    type = BodyForce  # heat generation term for heat conduction
    value = 15774023
    variable = temp
  []
[]

[BCs]
  [match_nek]
    type = MatchedValueBC
    variable = temp
    boundary = '0'
    v = nek_temp  # The variable whose value we are to match
  []
[]

[Materials]
  [hc]
    type = GenericConstantMaterial
    prop_values = '${thermal_conductivity}'
    prop_names = 'thermal_conductivity'
  []
[]


# AuxVariables are used to represent field data which passes between different applications
[AuxVariables]
  [nek_temp] # the aux variable that carries the nek temperature values (to be received from nek)
  []
  [flux] # to be sent to nek after being computed from the auxkernel, material properties are only defined on qp
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [flux_computed_from_solid]
    type = DiffusionFluxAux  # solving: q = -k grad T
    diffusion_variable = temp
    component = normal
    diffusivity = thermal_conductivity
    variable = flux
    boundary = '0'
  []
[]



[MultiApps]
  [nek]
    type = TransientMultiApp
    input_files = 'nek.i'
    sub_cycling = true
  []
[]



[Transfers]
  [nek_temp]
    type = MultiAppGeneralFieldNearestLocationTransfer 
    #Transfers field data at the MultiApp position by finding the value at the nearest neighbor(s) in the origin application
    source_variable = temperature
    from_multi_app = nek
    variable = nek_temp
  []
  [flux]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = flux
    to_multi_app = nek
    variable = flux
  []
  # transfer of the total integrated heat flux from MOOSE to Cardinal, which is then used internally by NekRS 
  #to re-normalize the heat flux 
  [flux_integral_to_nek]
    type = MultiAppPostprocessorTransfer
    to_postprocessor = flux_integral
    from_postprocessor = flux_integral
    to_multi_app = nek
  []
[]

[Postprocessors]
  [flux_integral]
    type = SideDiffusiveFluxIntegral # computes the integral of the flux over the pebble's boundary
    diffusivity = thermal_conductivity
    variable = temp
    boundary = '0'
  []
  [max_T]
    type = NodalExtremeValue
    variable = temp
  []
[]

[UserObjects]
  [average_flux_axial]
    type = LayeredSideAverage
    variable = flux
    direction = z
    num_layers = 5
    boundary = '0'
  []
[]

[VectorPostprocessors]
  [flux_axial]
    type = SpatialUserObjectVectorPostprocessor
    userobject = average_flux_axial
  []
[]

[Executioner]
  type = Transient

  # Portable, Extensible Toolkit for Scientific Computation (PETSc) is used in MOOSE 
  petsc_options_iname = '-pc_type -pc_hypre_type' # Sets PETSc’s preconditioner to use the HYPRE library
  petsc_options_value = 'hypre boomeramg' # boomeramg is HYPRE’s parallel algebraic multigrid solver

  dt = 5.0
  nl_abs_tol = 1e-8 # Non-linear absolute tolerance

  steady_state_detection = true
  steady_state_tolerance = 1e-4 # Whenever the relative residual changes by less than this the solution will be considered to be at steady state
[]

[Outputs]
  csv = true
  exodus = true
  hide = 'flux_integral' # flux_integral is a postprocessor 
[]