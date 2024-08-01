[Mesh]
  [file]
    type = FileMeshGenerator
    file = ../tokamak.e
  []
[]

[Problem]
  type = OpenMCCellAverageProblem
  output = unrelaxed_tally_std_dev
  scaling = 100.0

  tally_type = mesh
  mesh_template = ../tokamak.e
  tally_score = 'heating_local H3_production'
  source_strength = 2e18

  # this is a low number of particles; you will want to increase in order to obtain
  # high-quality results
  particles = 100
[]

[Postprocessors]
  [heating]
    type = ElementIntegralVariablePostprocessor
    variable = heating_local
  []
  [tritium_production]
    type = ElementIntegralVariablePostprocessor
    variable = H3_production
  []
  [tritium_error]
    type = TallyRelativeError
    tally_score = H3_production
    value_type = average
  []
  [heating_error]
    type = TallyRelativeError
    tally_score = heating_local
    value_type = average
  []
[]

[Executioner]
  type = Transient
  num_steps = 1
[]

[Outputs]
  exodus = true
  csv = true
[]
