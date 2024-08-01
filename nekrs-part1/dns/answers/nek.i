[Mesh]
  type = NekRSMesh
  order = FIRST
[]

[Problem]
  type = NekRSStandaloneProblem
  casename = 'pebble'
[]

[Executioner]
  type = Transient

  [TimeStepper]
    type = NekTimeStepper
  []
[]
